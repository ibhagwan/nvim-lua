-- help to inspect results, e.g.:
-- ':lua _G.dump(vim.fn.getwininfo())'
-- neovim 0.7 has 'vim.pretty_print())
function _G.dump(...)
  local objects = vim.tbl_map(vim.inspect, { ... })
  print(unpack(objects))
end

local DEV_DIR = "$HOME/Sources/nvim"

local M = {}

function M._echo_multiline(msg)
  for _, s in ipairs(vim.fn.split(msg, "\n")) do
    vim.cmd("echom '" .. s:gsub("'", "''") .. "'")
  end
end

function M.info(msg)
  vim.cmd("echohl Directory")
  M._echo_multiline(msg)
  vim.cmd("echohl None")
end

function M.warn(msg)
  vim.cmd("echohl WarningMsg")
  M._echo_multiline(msg)
  vim.cmd("echohl None")
end

function M.err(msg)
  vim.cmd("echohl ErrorMsg")
  M._echo_multiline(msg)
  vim.cmd("echohl None")
end

function M.has_neovim_v08()
  return (vim.fn.has("nvim-0.8") == 1)
end

function M.is_root()
  return (vim.loop.getuid() == 0)
end

function M.is_darwin()
  return vim.loop.os_uname().sysname == "Darwin"
end

function M.is_NetBSD()
  return vim.loop.os_uname().sysname == "NetBSD"
end

function M.is_dev(path)
  return vim.loop.fs_stat(string.format("%s/%s",
    vim.fn.expand(DEV_DIR), path))
end

function M.shell_error()
  return vim.v.shell_error ~= 0
end

function M.have_compiler()
  if vim.fn.executable("cc") == 1 or
      vim.fn.executable("gcc") == 1 or
      vim.fn.executable("clang") == 1 or
      vim.fn.executable("cl") == 1 then
    return true
  end
  return false
end

function M.git_root(cwd, noerr)
  local cmd = { "git", "rev-parse", "--show-toplevel" }
  if cwd then
    table.insert(cmd, 2, "-C")
    table.insert(cmd, 3, vim.fn.expand(cwd))
  end
  local output = vim.fn.systemlist(cmd)
  if M.shell_error() then
    if not noerr then M.info(unpack(output)) end
    return nil
  end
  return output[1]
end

function M.set_cwd(pwd)
  if not pwd then
    local parent = vim.fn.expand("%:h")
    pwd = M.git_root(parent, true) or parent
  end
  if vim.loop.fs_stat(pwd) then
    vim.cmd("cd " .. pwd)
    M.info(("pwd set to %s"):format(vim.fn.shellescape(pwd)))
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
    -- exit visual mode
    vim.api.nvim_feedkeys(
      vim.api.nvim_replace_termcodes("<Esc>",
        true, false, true), "n", true)
  else
    -- otherwise, use the last known visual position
    _, csrow, cscol, _ = unpack(vim.fn.getpos("'<"))
    _, cerow, cecol, _ = unpack(vim.fn.getpos("'>"))
  end
  -- swap vars if needed
  if cerow < csrow then csrow, cerow = cerow, csrow end
  if cecol < cscol then cscol, cecol = cecol, cscol end
  local lines = vim.fn.getline(csrow, cerow)
  -- local n = cerow-csrow+1
  local n = #lines
  if n <= 0 then return "" end
  lines[n] = string.sub(lines[n], 1, cecol)
  lines[1] = string.sub(lines[1], cscol)
  return table.concat(lines, nl_literal and "\\n" or "\n")
end

function M.toggle_colorcolumn()
  local wininfo = vim.fn.getwininfo()
  for _, win in pairs(wininfo) do
    local ft = vim.api.nvim_buf_get_option(win["bufnr"], "filetype")
    if ft == nil or ft == "TelescopePrompt" then return end
    local colorcolumn = ""
    if win["width"] >= vim.g._colorcolumn then
      colorcolumn = tostring(vim.g._colorcolumn)
    end
    -- TOOD: messes up tab highlighting, why?
    -- vim.api.nvim_win_set_option(win['winid'], 'colorcolumn', colorcolumn)
    vim.api.nvim_win_call(win["winid"], function()
      vim.wo.colorcolumn = colorcolumn
    end)
  end
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

M.sudo_exec = function(cmd, print_output)
  vim.fn.inputsave()
  local password = vim.fn.inputsecret("Password: ")
  vim.fn.inputrestore()
  if not password or #password == 0 then
    M.warn("Invalid password, sudo aborted")
    return false
  end
  local out = vim.fn.system(string.format("sudo -p '' -S %s", cmd), password)
  if vim.v.shell_error ~= 0 then
    print("\r\n")
    M.err(out)
    return false
  end
  if print_output then print("\r\n", out) end
  return true
end

M.sudo_write = function(tmpfile, filepath)
  if not tmpfile then tmpfile = vim.fn.tempname() end
  if not filepath then filepath = vim.fn.expand("%") end
  if not filepath or #filepath == 0 then
    M.err("E32: No file name")
    return
  end
  -- `bs=1048576` is equivalent to `bs=1M` for GNU dd or `bs=1m` for BSD dd
  -- Both `bs=1M` and `bs=1m` are non-POSIX
  local cmd = string.format("dd if=%s of=%s bs=1048576",
    vim.fn.shellescape(tmpfile),
    vim.fn.shellescape(filepath))
  -- no need to check error as this fails the entire function
  vim.api.nvim_exec(string.format("write! %s", tmpfile), true)
  if M.sudo_exec(cmd) then
    M.info(string.format([[\r\n"%s" written]], filepath))
    vim.cmd("e!")
  end
  vim.fn.delete(tmpfile)
end

M.osc52printf = function(...)
  local str = string.format(...)
  local base64 = require "base64".encode(str)
  local osc52str = string.format("\x1b]52;c;%s\x07", base64)
  local bytes = vim.fn.chansend(vim.v.stderr, osc52str)
  assert(bytes > 0)
  M.info(string.format("[OSC52] %d chars copied (%d bytes)", #str, bytes))
end

M.unload_modules = function(patterns)
  for _, p in ipairs(patterns) do
    if not p.mod and type(p[1]) == "string" then
      p = { mod = p[1], fn = p.fn }
    end
    local unloaded = false
    for m, _ in pairs(package.loaded) do
      if m:match(p.mod) then
        unloaded = true
        package.loaded[m] = nil
        M.info(string.format("UNLOADED module '%s'", m))
      end
    end
    if unloaded and p.fn then
      p.fn()
      M.warn(string.format("RELOADED module '%s'", p.mod))
    end
  end
end

M.reload_config = function()
  M.unload_modules({
    { "^options$",       fn = function() require("options") end },
    { "^autocmd$",       fn = function() require("autocmd") end },
    { "^keymaps$",       fn = function() require("keymaps") end },
    { "^utils$" },
    { "^workdirs$" },
    { mod = "ts%-vimdoc" },
    { mod = "smartyank", fn = function() require("smartyank") end },
    { mod = "fzf%-lua",  fn = function() require("plugins.fzf-lua.setup").setup() end },
  })
  -- re-source all language specific settings, scans all runtime files under
  -- '/usr/share/nvim/runtime/(indent|syntax)' and 'after/ftplugin'
  local ft = vim.bo.filetype
  vim.tbl_filter(function(s)
    for _, e in ipairs({ "vim", "lua" }) do
      if ft and #ft > 0 and s:match(("/%s.%s"):format(ft, e)) then
        local file = vim.fn.expand(s:match("[^: ]*$"))
        vim.cmd("source " .. file)
        M.warn("RESOURCED " .. vim.fn.fnamemodify(file, ":."))
        return s
      end
    end
    return nil
  end, vim.fn.split(vim.fn.execute("scriptnames"), "\n"))
  -- remove last search highlight
  vim.cmd("nohl")
end

M.tmux_aware_navigate = function(direction, no_wrap)
  local curwin = vim.api.nvim_get_current_win()
  -- First attempt to send a wincmd
  vim.cmd.wincmd(direction == "\\" and "w" or direction)
  if not vim.env.TMUX or vim.api.nvim_get_current_win() ~= curwin then
    -- Stop here if no TMUX or wincmd switched windows
    return
  end
  -- tmux exists and window wasn't switche
  -- forward the command to tmux
  local tmux_pane_flag = {
    ["h"]  = "-L",
    ["j"]  = "-D",
    ["k"]  = "-U",
    ["l"]  = "-R",
    ["\\"] = "-l",
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
  vim.fn.system(args)
end

return M
