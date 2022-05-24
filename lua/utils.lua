-- help to inspect results, e.g.:
-- ':lua _G.dump(vim.fn.getwininfo())'
-- neovim 0.7 has 'vim.pretty_print())
function _G.dump(...)
  local objects = vim.tbl_map(vim.inspect, { ... })
  print(unpack(objects))
end

local M = {}

function M._echo_multiline(msg)
  for _, s in ipairs(vim.fn.split(msg, "\n")) do
    vim.cmd("echom '" .. s:gsub("'", "''").."'")
  end
end

function M.info(msg)
  vim.cmd('echohl Directory')
  M._echo_multiline(msg)
  vim.cmd('echohl None')
end

function M.warn(msg)
  vim.cmd('echohl WarningMsg')
  M._echo_multiline(msg)
  vim.cmd('echohl None')
end

function M.err(msg)
  vim.cmd('echohl ErrorMsg')
  M._echo_multiline(msg)
  vim.cmd('echohl None')
end

function M.has_neovim_v05()
  return (vim.fn.has('nvim-0.5') == 1)
end

function M.is_root()
  return (vim.loop.getuid() == 0)
end

function M.is_darwin()
  return vim.loop.os_uname().sysname == 'Darwin'
end

function M.shell_error()
  return vim.v.shell_error ~= 0
end

function M.have_compiler()
  if vim.fn.executable('cc') == 1 or
    vim.fn.executable('gcc') == 1 or
    vim.fn.executable('clang') == 1 or
    vim.fn.executable('cl') == 1 then
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

function M.get_visual_selection()
    -- this will exit visual mode
    -- use 'gv' to reselect the text
    local _, csrow, cscol, cerow, cecol
    local mode = vim.fn.mode()
    if mode == 'v' or mode == 'V' or mode == '' then
      -- if we are in visual mode use the live position
      _, csrow, cscol, _ = unpack(vim.fn.getpos("."))
      _, cerow, cecol, _ = unpack(vim.fn.getpos("v"))
      if mode == 'V' then
        -- visual line doesn't provide columns
        cscol, cecol = 0, 999
      end
      -- exit visual mode
      vim.api.nvim_feedkeys(
        vim.api.nvim_replace_termcodes("<Esc>",
          true, false, true), 'n', true)
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
    if n <= 0 then return '' end
    lines[n] = string.sub(lines[n], 1, cecol)
    lines[1] = string.sub(lines[1], cscol)
    return table.concat(lines, "\n")
end

function M.toggle_colorcolumn()
  local wininfo = vim.fn.getwininfo()
  for _, win in pairs(wininfo) do
    local ft = vim.api.nvim_buf_get_option(win['bufnr'], 'filetype')
    if ft == nil or ft == 'TelescopePrompt' then return end
    local colorcolumn = ''
    if win['width'] >= vim.g.colorcolumn then
      colorcolumn = tostring(vim.g.colorcolumn)
    end
    -- TOOD: messes up tab highlighting, why?
    -- vim.api.nvim_win_set_option(win['winid'], 'colorcolumn', colorcolumn)
    vim.api.nvim_win_call(win['winid'], function()
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
      if type == 'l' and win['loclist'] == 1 then
        found = true
      end
      -- loclist window has 'quickfix' set, eliminate those
      if type == 'q' and win['quickfix'] == 1 and win['loclist'] == 0  then
        found = true
      end
      if found then
        table.insert(win_tbl, { winid = win['winid'], bufnr = win['bufnr'] })
      end
  end
  return win_tbl
end

-- open quickfix if not empty
function M.open_qf()
  local qf_name = 'quickfix'
  local qf_empty = function() return vim.tbl_isempty(vim.fn.getqflist()) end
  if not qf_empty() then
    vim.cmd('copen')
    vim.cmd('wincmd J')
  else
    print(string.format("%s is empty.", qf_name))
  end
end

-- enum all non-qf windows and open
-- loclist on all windows where not empty
function M.open_loclist_all()
  local wininfo = vim.fn.getwininfo()
  local qf_name = 'loclist'
  local qf_empty = function(winnr) return vim.tbl_isempty(vim.fn.getloclist(winnr)) end
  for _, win in pairs(wininfo) do
      if win['quickfix'] == 0 then
        if not qf_empty(win['winnr']) then
          -- switch active window before ':lopen'
          vim.api.nvim_set_current_win(win['winid'])
          vim.cmd('lopen')
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
    if type == 'l' then
      M.open_loclist_all()
    else
      M.open_qf()
    end
  end
end

-- taken from:
-- https://www.reddit.com/r/neovim/comments/o1byad/what_lua_code_do_you_have_to_enhance_neovim/
--
-- tmux like <C-b>z: focus on one buffer in extra tab
-- put current window in new tab with cursor restored
local _tabZ = nil

M.tabZ = function()
  if _tabZ then
    if _tabZ == vim.api.nvim_get_current_tabpage() then
      M.tabclose()
    end
    _tabZ = nil
  else
    _tabZ = M.tabedit()
  end
end

M.tabedit = function()
  -- skip if there is only one window open
  if vim.tbl_count(vim.api.nvim_tabpage_list_wins(0)) == 1 then
    print('Cannot expand single buffer')
    return
  end

  local buf = vim.api.nvim_get_current_buf()
  local view = vim.fn.winsaveview()
  -- note: tabedit % does not properly work with terminal buffer
  vim.cmd [[tabedit]]
  -- set buffer and remove one opened by tabedit
  local tabedit_buf = vim.api.nvim_get_current_buf()
  vim.api.nvim_win_set_buf(0, buf)
  vim.api.nvim_buf_delete(tabedit_buf, {force = true})
  -- restore original view
  vim.fn.winrestview(view)
  return vim.api.nvim_get_current_tabpage()
end

-- restore old view with cursor retained
M.tabclose = function()
  local buf = vim.api.nvim_get_current_buf()
  local view = vim.fn.winsaveview()
  vim.cmd [[tabclose]]
  -- if we accidentally land somewhere else, do not restore
  local new_buf = vim.api.nvim_get_current_buf()
  if buf == new_buf then vim.fn.winrestview(view) end
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
  vim.cmd(string.format('wincmd %s', vertical and 'l' or 'j'))
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

  sign = sign and '+' or '-'
  local dir = vertical and 'vertical ' or ''
  local cmd = dir .. 'resize ' .. sign .. math.abs(margin) .. '<CR>'
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
    M.info(string.format('\r\n"%s" written', filepath))
    vim.cmd("e!")
  end
  vim.fn.delete(tmpfile)
end

-- Credit to uga-rosa@github
-- https://github.com/uga-rosa/dotfiles/blob/main/.config/nvim/lua/utils.lua

---Return a string for vim from a lua function.
---Functions are stored in _G.myluafunc.
---@param func function
---@return string VimFunctionString
_G.myluafunc = setmetatable({}, {
  __call = function(self, idx, args, count)
    return self[idx](args, count)
  end,
})

local func2str = function(func, args)
  local idx = #_G.myluafunc + 1
  _G.myluafunc[idx] = func
  if not args then
    return ("lua myluafunc(%s)"):format(idx)
  else
    -- return ("lua myluafunc(%s, <q-args>)"):format(idx)
    return ("lua myluafunc(%s, <q-args>, <count>)"):format(idx)
  end
end

M.t = function(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

---API for key mapping.
---
---@param lhs string
---@param modes string|table
---@param rhs string|function
---@param opts string|table
--- opts.buffer: current buffer only
--- opts.cmd: command (format to <cmd>%s<cr>)
M.remap = function(modes, lhs, rhs, opts)
  modes = type(modes) == "string" and { modes } or modes
  opts = opts or {}
  opts = type(opts) == "string" and { opts } or opts

  local fallback = function()
    return vim.api.nvim_feedkeys(M.t(lhs), "n", true)
  end

  local _rhs = (function()
    if type(rhs) == "function" then
      opts.noremap = true
      opts.cmd = true
      return func2str(function()
        rhs(fallback)
      end)
    else
      return rhs
    end
  end)()

  for key, opt in ipairs(opts) do
    opts[opt] = true
    opts[key] = nil
  end

  local buffer = (function()
    if opts.buffer then
      opts.buffer = nil
      return true
    end
  end)()

  _rhs = (function()
    if opts.cmd then
      opts.cmd = nil
      return ("<cmd>%s<cr>"):format(_rhs)
    else
      return _rhs
    end
  end)()

  for _, mode in ipairs(modes) do
    if buffer then
      vim.api.nvim_buf_set_keymap(0, mode, lhs, _rhs, opts)
    else
      vim.api.nvim_set_keymap(mode, lhs, _rhs, opts)
    end
  end
end

---API for command mappings
-- Supports lua function args
---@param args string|table
M.command = function(args)
  if type(args) == "table" then
    for i=2,#args do
      if vim.fn.exists(':' .. args[2]) == 2 then
        vim.cmd("delcommand " .. args[2])
      end
      if type(args[i]) == "function" then
        args[i] = func2str(args[i], true)
      end
    end
    args = table.concat(args, " ")
  end
  vim.cmd("command! " .. args)
end

M.fugitive_exec = function(git_dir, git_cmd, ...)
  local args = { ... }
  local bufnr = vim.api.nvim_get_current_buf()
  local buf_git_dir = vim.b.git_dir
  vim.b.git_dir = vim.fn.expand(git_dir)
  vim.cmd(git_cmd .. " " .. table.concat(args, " "))
  -- after the fugitive window switch we must explicitly
  -- use the buffer num to restore the original 'git_dir'
  vim.b[bufnr].git_dir = buf_git_dir
end

return M
