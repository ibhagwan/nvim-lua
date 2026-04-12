-- help to inspect results, e.g.:
-- ':lua _G.dump(vim.fn.getwininfo())'
-- neovim 0.7 has 'vim.pretty_print())
function _G.dump(...)
  local objects = vim.tbl_map(vim.inspect, { ... })
  print(unpack(objects))
end

local M = {}

M.__IS_WIN = jit.os == "Windows"
-- M.__IS_WIN = vim.fn.has("win32") == 1 or vim.fn.has("win64") == 1
-- M.__USE_SNACKS = M.__IS_WIN

M._notify_header = "LineNr"

--- Fancy notification wrapper, idea borrowed from blink.nvim
--- @param lvl? number
--- @param ... any
function M.notify(lvl, ...)
  -- Message can be specified directly as table with highlights, i.e. { "foo", "Error" }
  -- or as a vararg of strings/numbers to be sent to string.format
  local arg1 = (...)
  local msg = type(arg1) == "table" and arg1 or string.format(...)

  local header_hl, chunks = (function()
    local hl = (function()
      if lvl == vim.log.levels.ERROR then
        return "DiagnosticVirtualLinesError"
      elseif lvl == vim.log.levels.WARN then
        return "DiagnosticVirtualLinesWarn"
      elseif lvl == vim.log.levels.INFO then
        return "DiagnosticVirtualLinesInfo"
      else
        return "DiagnosticVirtualLinesHint"
      end
    end)()
    -- When using vararg for msg (i.e. only text) we color the text based on the
    -- requested log level, when msg is already highlighted (i.e. table) we leave
    -- the msg highlights as requested by the caller and color the header (plugin
    -- name) instead
    if type(msg) == "table" then
      for i, v in ipairs(msg) do
        if type(v) ~= "table" or not v[2] then
          msg[i] = { type(v) ~= "table" and tostring(v) or v[1], "" }
        end
      end
      return hl, msg
    else
      return M._notify_header, { { msg, hl } }
    end
  end)()

  assert(type(chunks) == "table")

  table.insert(chunks, 1, { "[Nvim]", header_hl })
  table.insert(chunks, 2, { " " })

  local function nvim_echo()
    local echo_opts = { verbose = false, err = lvl == vim.log.levels.ERROR }
    if echo_opts.err and _G.fzf_jobstart and #vim.api.nvim_list_uis() == 0 then
      local output = vim.tbl_map(function(chunk) return chunk[1] end, chunks)
      error(table.concat(output, ""))
    else
      vim.api.nvim_echo(chunks, true, echo_opts)
    end
  end
  if vim.in_fast_event() then
    vim.schedule(nvim_echo)
  else
    nvim_echo()
  end
end

function M.info(...)
  M.notify(vim.log.levels.INFO, ...)
end

function M.warn(...)
  M.notify(vim.log.levels.WARN, ...)
end

function M.error(...)
  M.notify(vim.log.levels.ERROR, ...)
end

function M.is_root()
  return not M.__IS_WIN and vim.uv.getuid() == 0
end

function M.is_darwin()
  -- return vim.uv.os_uname().sysname == "Darwin"
  return jit.os == "OSX"
end

function M.is_NetBSD()
  -- return vim.uv.os_uname().sysname == "NetBSD"
  return jit.os == "BSD"
end

function M.is_iSH()
  return vim.uv.os_uname().release:match("%-ish$") ~= nil
end

--- @param path string
--- @return string?
function M.exists(path)
  local normalized = vim.fs.normalize(path)
  local exists = vim.uv.fs_stat(normalized) ~= nil
  -- NOTE: isdirectory seems slower
  -- local exists = vim.fn.isdirectory(normalized) == 1
  return exists and normalized or nil
end

function M.have_compiler()
  if vim.fn.executable("cc") == 1
      or vim.fn.executable("gcc") == 1
      or vim.fn.executable("clang") == 1
      or vim.fn.executable("cl") == 1
      or vim.fn.executable("zig") == 1
  then
    return true
  end
  return false
end

function M.cargo_has_nightly()
  local ok, res = pcall(function()
    return vim.system({ "cargo", "+nightly" }):wait()
  end)
  return ok and res.code == 0
end

function M.git_root(cwd, noerr)
  local cmd = { "git", "rev-parse", "--show-toplevel" }
  if cwd then
    table.insert(cmd, 2, "-C")
    table.insert(cmd, 3, vim.fn.expand(cwd))
  end
  local ok, res = pcall(function() return vim.system(cmd):wait() end)
  if not ok or not res then
    if not noerr then M.info(res) end
    return nil
  end
  return assert(res.stdout):gsub("\n$", "")
end

function M.set_cwd(pwd)
  if not pwd then
    local parent = vim.fn.expand("%:h")
    -- pwd = M.git_root(parent, true) or parent
    local lsp_util = require("lspconfig.util")
    pwd = lsp_util.root_pattern({
      ".luarc.json",
      ".luarc.jsonc",
      ".luacheckrc",
      ".stylua.toml",
      "stylua.toml",
      ".git",
    })(parent) or parent
  end
  if pwd and vim.uv.fs_stat(pwd) then
    vim.cmd("cd " .. pwd)
    M.info("pwd set to %s", vim.fn.shellescape(pwd))
  else
    M.warn(("Unable to set pwd to %s, directory is not accessible")
      :format(vim.fn.shellescape(pwd)))
  end
end

function M.get_visual_selection(nl_literal)
  -- this will exit visual mode
  -- use 'gv' to reselect the text
  local _, csrow, cscol, cerow, cecol
  local mode = vim.fn.mode()
  if mode == "v" or mode == "V" or mode == "" then
    -- if we are in visual mode use the live position
    _, csrow, cscol, _ = unpack(vim.fn.getpos("."))
    _, cerow, cecol, _ = unpack(vim.fn.getpos("v"))
    if mode == "V" then
      -- visual line doesn't provide columns
      cscol, cecol = 0, 999
    end
  else
    -- otherwise, use the last known visual position
    _, csrow, cscol, _ = unpack(vim.fn.getpos("'<"))
    _, cerow, cecol, _ = unpack(vim.fn.getpos("'>"))
  end
  -- swap vars if needed
  if cerow < csrow then csrow, cerow = cerow, csrow end
  if cecol < cscol then cscol, cecol = cecol, cscol end
  local lines = vim.fn.getline(csrow, cerow) ---@cast lines string[]
  -- local n = cerow-csrow+1
  local n = #lines
  if n <= 0 then return "" end
  lines[n] = string.sub(lines[n] --[[@as string]], 1, cecol)
  lines[1] = string.sub(lines[1] --[[@as string]], cscol)
  return table.concat(lines, nl_literal and "\\n" or "\n")
end

-- 'q': find the quickfix window
-- 'l': find all loclist windows
function M.find_qf(type)
  local wininfo = vim.fn.getwininfo()
  local win_tbl = {}
  for _, win in pairs(wininfo) do
    local found = false
    if type == "l" and win["loclist"] == 1 then
      found = true
    end
    -- loclist window has 'quickfix' set, eliminate those
    if type == "q" and win["quickfix"] == 1 and win["loclist"] == 0 then
      found = true
    end
    if found then
      table.insert(win_tbl, { winid = win["winid"], bufnr = win["bufnr"] })
    end
  end
  return win_tbl
end

-- open quickfix if not empty
function M.open_qf()
  local qf_name = "quickfix"
  local qf_empty = function() return vim.tbl_isempty(vim.fn.getqflist()) end
  if not qf_empty() then
    vim.cmd("copen")
    vim.cmd("wincmd J")
  else
    print(string.format("%s is empty.", qf_name))
  end
end

-- enum all non-qf windows and open
-- loclist on all windows where not empty
function M.open_loclist_all()
  local wininfo = vim.fn.getwininfo()
  local qf_name = "loclist"
  local qf_empty = function(winnr) return vim.tbl_isempty(vim.fn.getloclist(winnr)) end
  for _, win in pairs(wininfo) do
    if win["quickfix"] == 0 then
      if not qf_empty(win["winnr"]) then
        -- switch active window before ':lopen'
        vim.api.nvim_set_current_win(win["winid"])
        vim.cmd("lopen")
      else
        print(string.format("%s is empty.", qf_name))
      end
    end
  end
end

-- toggle quickfix/loclist on/off
-- type='*': qf toggle and send to bottom
-- type='l': loclist toggle (all windows)
function M.toggle_qf(type)
  local windows = M.find_qf(type)
  if #windows > 0 then
    -- hide all visible windows
    for _, win in ipairs(windows) do
      vim.api.nvim_win_hide(win.winid)
    end
  else
    -- no windows are visible, attempt to open
    if type == "l" then
      M.open_loclist_all()
    else
      M.open_qf()
    end
  end
end

-- expand or minimize current buffer in a more natural direction (tmux-like)
-- ':resize <+-n>' or ':vert resize <+-n>' increases or decreasese current
-- window horizontally or vertically. When mapped to '<leader><arrow>' this
-- can get confusing as left might actually be right, etc
-- the below can be mapped to arrows and will work similar to the tmux binds
-- map to: "<cmd>lua require'utils'.resize(false, -5)<CR>"
M.resize = function(vertical, margin)
  local cur_win = vim.api.nvim_get_current_win()
  -- go (possibly) right
  vim.cmd(string.format("wincmd %s", vertical and "l" or "j"))
  local new_win = vim.api.nvim_get_current_win()

  -- determine direction cond on increase and existing right-hand buffer
  local not_last = not (cur_win == new_win)
  local sign = margin > 0
  -- go to previous window if required otherwise flip sign
  if not_last == true then
    vim.cmd [[wincmd p]]
  else
    sign = not sign
  end

  local sign_str = sign and "+" or "-"
  local dir = vertical and "vertical " or ""
  local cmd = dir .. "resize " .. sign_str .. math.abs(margin) .. "<CR>"
  vim.cmd(cmd)
end

M.sudo_exec = function(cmd, filepath, print_output)
  vim.fn.inputsave()
  local password = vim.fn.inputsecret("Password: ")
  vim.fn.inputrestore()
  if not password or #password == 0 then
    M.warn("Invalid password, sudo aborted")
    return false
  end
  local ok, res = pcall(function()
    return vim.system({ "sh", "-c",
      string.format("echo '%s' | sudo -p '' -S %s", password, cmd) }):wait()
  end)
  if not ok or res.code ~= 0 then
    M.warn(not ok and res or assert(res).stderr)
    return false
  else
    if print_output then M.info('"%s" written\r\n%s', filepath, res.stderr) end
    return true
  end
end

M.sudo_write = function(tmpfile, filepath)
  if not tmpfile then tmpfile = vim.fn.tempname() end
  if not filepath then filepath = vim.fn.expand("%") end
  if not filepath or #filepath == 0 then
    M.warn("E32: No file name")
    return
  end
  -- store alt buffer
  local alt_buf = vim.fn.bufnr("#")
  -- `bs=1048576` is equivalent to `bs=1M` for GNU dd or `bs=1m` for BSD dd
  -- Both `bs=1M` and `bs=1m` are non-POSIX
  local cmd = string.format("dd if=%s of=%s bs=1048576",
    vim.fn.shellescape(tmpfile),
    vim.fn.shellescape(filepath))
  -- no need to check error as this fails the entire function
  vim.api.nvim_exec2(string.format("write! %s", tmpfile), { output = true })
  if M.sudo_exec(cmd, filepath, true) then
    -- TODO: triggers unsaved warning on exit, use e! instead
    -- ignore W12 triggered by checktime
    -- vim.api.nvim_create_autocmd("FileChangedShell", {
    --   buffer = 0,
    --   once = true,
    --   callback = function(_) M.info('"%s" reloaded', filepath) end,
    -- })
    -- reload the buffer
    -- vim.cmd.checktime()
    vim.cmd("e!")
  end
  -- restore alt buf
  if alt_buf and vim.api.nvim_buf_is_valid(alt_buf) then
    vim.fn.setreg("#", alt_buf)
  end
  vim.fn.delete(tmpfile)
end

M.osc52printf = function(...)
  local str = string.format(...)
  local base64 = vim.base64.encode(str)
  local osc52str = string.format("\x1b]52;c;%s\x07", base64)
  local bytes = vim.fn.chansend(vim.v.stderr, osc52str)
  assert(bytes > 0)
  M.info("[OSC52] %d chars copied (%d bytes)", #str, bytes)
end

M.win_is_float = function(winnr)
  local wincfg = vim.api.nvim_win_get_config(winnr)
  if wincfg and (wincfg.external or wincfg.relative and #wincfg.relative > 0) then
    return true
  end
  return false
end

M.tmux_aware_navigate = function(direction, no_wrap)
  local curwin = vim.api.nvim_get_current_win()
  -- First attempt to send a wincmd, skip if window is floating
  -- Do not skip "alt-h" due to fzf-lua's toggle_hidden default
  if not M.win_is_float(curwin) or direction == "h" then
    vim.cmd.wincmd(direction == "o" and "w" or direction)
    if not vim.env.TMUX or vim.api.nvim_get_current_win() ~= curwin then
      -- Stop here if no TMUX or wincmd switched windows
      return
    end
  end
  -- tmux exists and window wasn't switche
  -- forward the command to tmux
  local tmux_pane_flag = {
    ["h"] = "-L",
    ["j"] = "-D",
    ["k"] = "-U",
    ["l"] = "-R",
    ["o"] = "-l",
  }
  local tmux_pane_to = {
    ["h"] = "left",
    ["j"] = "bottom",
    ["k"] = "top",
    ["l"] = "right",
  }
  local args = { "tmux" }
  if no_wrap then
    table.insert(args, "if-shell")
    table.insert(args, "-F")
    table.insert(args, string.format("#{pane_at_%s}", tmux_pane_to[direction]))
    table.insert(args, "")
    table.insert(args, string.format("select-pane -t %s %s",
      vim.env.TMUX_PANE, tmux_pane_flag[direction]))
  else
    table.insert(args, "select-pane")
    table.insert(args, "-t")
    table.insert(args, vim.env.TMUX_PANE)
    table.insert(args, tmux_pane_flag[direction])
  end
  vim.system(args):wait()
end

M.tmux_is_zoomed = function()
  if not vim.env.TMUX then return end
  local out = vim.system({ "tmux", "display-message", "-p", "#{window_flags}" }):wait().stdout
  return type(out) == "string" and out:match("Z") and 1 or 0
end

M.tmux_toggle_Z = function()
  if not vim.env.TMUX then return end
  vim.system({ "tmux", "resize-pane", "-Z" }):wait()
  return true
end

M.tmux_zoom = function()
  if M.tmux_is_zoomed() == 0 then
    return M.tmux_toggle_Z()
  end
end

M.tmux_unzoom = function()
  if M.tmux_is_zoomed() == 1 then
    return M.tmux_toggle_Z()
  end
end

function M.input(prompt)
  local res
  local ok, _ = pcall(vim.ui.input, { prompt = prompt }, function(input) res = input end)
  return ok and res or nil
end

return M
