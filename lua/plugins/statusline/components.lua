if not pcall(require, "el") then
  return
end

local Job = require "plenary.job"
local el_sub = require "el.subscribe"

local M = {}

function M.extract_hl(spec)
  if not spec or vim.tbl_isempty(spec) then return end
  local hl_name, hl_cmd, hl_props = { "El" }, {}, {}
  for attr, val in pairs(spec) do
    if type(val) == 'table' then
      table.insert(hl_name, attr)
      local mode = val.mode or "gui"
      val.mode = nil
      assert(vim.tbl_count(val)==1)
      local hl, what = next(val)
      local hlID = vim.fn.hlID(hl)
      if hlID > 0  then
        table.insert(hl_name, hl)
        local col = vim.fn.synIDattr(hlID, what, mode)
        if col and #col>0 then
          table.insert(hl_name, what)
          table.insert(hl_cmd, ("%s%s=%s"):format(mode, attr, col))
          hl_props[attr] = { mode = mode, val = col }
        end
      end
    else
      -- this is where 'gui="bold"' can be set
      -- synIDattr returns '1' for these
      table.insert(hl_cmd, ("%s=%s"):format(attr, val))
      hl_props[val] = { mode = attr, val = '1' }
    end
  end
  hl_name = table.concat(hl_name, '_')
  hl_cmd = ("highlight %s %s"):format(hl_name, table.concat(hl_cmd, ' '))
  -- if highlight exists, verify it has
  -- the correct colorscheme highlights
  local newID = vim.fn.hlID(hl_name)
  if newID > 0 then
    for what, expected in pairs(hl_props) do
      local res = vim.fn.synIDattr(newID, what, expected.mode)
      if newID > 0 and res ~= expected.val then
        -- need to regen the highlight
        -- print("color mismatch", hl_name, what, "e", expected.val, "c", res)
        newID = 0
      end
    end
  end
  if newID == 0 then
    vim.api.nvim_command(hl_cmd)
  end
  return hl_name
end

local function set_hl(hls, s)
  if not hls or not s then return s end
  hls = type(hls)=='string' and { hls } or hls
  for _, hl in ipairs(hls) do
    if vim.fn.hlID(hl) > 0 then
      return ("%%#%s#%s%%0*"):format(hl, s)
    end
  end
  return s
end

local function wrap_fnc(opts, fn)
  return function(window, buffer)
    -- buf_autocmd doesn't send win
    if not window and buffer then
      window = { win_id = vim.fn.bufwinid(buffer.bufnr) }
    end
    if opts.hide_inactive and window and
      window.win_id ~= vim.api.nvim_get_current_win() then
      return ""
    end
    return fn(window, buffer)
  end
end

M.mode = function(opts)
  opts = opts or {}
  return wrap_fnc(opts, function(_, _)
    local fmt = opts.fmt or "%s%s"
    local mode = vim.api.nvim_get_mode().mode
    local mode_data = opts.modes and opts.modes[mode]
    local hls = mode_data and mode_data[3]
    local icon = opts.hl_icon_only and set_hl(hls, opts.icon) or opts.icon
    mode = mode_data and mode_data[1]:upper() or mode
    mode = (fmt):format(icon or "", mode)
    return not opts.hl_icon_only and set_hl(hls, mode) or mode
  end)
end

M.try_devicons = function()
  if not M._has_devicons then
    M._has_devicons, M._devicons = pcall(require, "nvim-web-devicons")
  end
  return M._devicons
end

M.file_icon = function(opts)
  opts = opts or {}
  return el_sub.buf_autocmd("el_file_icon", "BufRead",
    wrap_fnc(opts, function(_, buffer)
      if not M.try_devicons() then return "" end
      local fmt = opts.fmt or "%s"
      local ext = vim.fn.fnamemodify(buffer.name, ':p:e')
      local icon, hl = M._devicons.get_icon(buffer.name, ext:lower(), {default = true})
      -- local icon = extensions.file_icon(_, bufnr)
      if icon then
        if opts.hl_icon then
          local hlgroup = M.extract_hl({
            bg = { StatusLine   = 'bg' },
            fg = { [hl]         = 'fg' },
          })
          icon = set_hl(hlgroup, icon)
        end
        return (fmt):format(icon)
      end
      return ""
    end))
end

M.git_branch = function(opts)
  opts = opts or {}
  return el_sub.buf_autocmd("el_git_branch", "BufEnter",
    wrap_fnc(opts, function(_, buffer)
      -- Try fugitive first as it's most reliable
      local branch = vim.g.loaded_fugitive == 1 and
        vim.fn.FugitiveHead() or nil
      -- buffer can be null and code will crash with:
      -- E5108: Error executing lua ... 'attempt to index a nil value'
      if not buffer or not (buffer.bufnr > 0) then
        return
      end
      -- fugitive is empty or not loaded, try gitsigns
      if not branch or #branch==0 then
        local ok, res = pcall(vim.api.nvim_buf_get_var,
          buffer.bufnr, 'gitsigns_head')
        if ok then branch = res end
      end
      -- last resort run git command
      if not branch then
        local j = Job:new {
          command = "git",
          args = { "branch", "--show-current" },
          cwd = vim.fn.fnamemodify(buffer.name, ":h"),
        }

        local ok, result = pcall(function()
          return vim.trim(j:sync()[1])
        end)
        if ok then
          branch = result
        end
      end

      if branch and #branch>0 then
        local fmt = opts.fmt or "%s %s"
        local icon = opts.icon or ''
        return set_hl(opts.hl, (fmt):format(icon, branch))
      end
    end))
end

local git_changes_formatter = function(opts)
  local specs = {
    insert = {
      regex = "(%d+) insertions?",
      icon  = opts.icon_insert or '+',
      hl    = opts.hl_insert,
    },
    change = {
      regex = "(%d+) files? changed",
      icon  = opts.icon_change or '~',
      hl    = opts.hl_change,
    },
    delete = {
      regex = "(%d+) deletions?",
      icon  = opts.icon_delete or '-',
      hl    = opts.hl_delete,
    },
  }
  return function(_, _, s)
    local result = {}
    for k, v in pairs(specs) do
      local count = nil
      if type(s) == 'string' then
        -- 'git diff --shortstat' output
        -- from 'git_changes_all'
        count = tonumber(string.match(s, v.regex))
      else
        -- map from 'git_changes_buf'
        count = s[k]
      end
      if count and count > 0 then
        table.insert(result, set_hl(v.hl, ("%s%d"):format(v.icon, count)))
      end
    end
    return table.concat(result, ", ")
  end
end

-- requires gitsigns
M.git_changes_buf = function(opts)
  opts = opts or {}
  local formatter = opts.formatter or git_changes_formatter(opts)
  return wrap_fnc(opts, function(window, buffer)
    local stats = {}
    if buffer and buffer.bufnr > 0 then
      local ok, res = pcall(vim.api.nvim_buf_get_var,
        buffer.bufnr, 'vgit_status')
      if ok then stats = res end
    end
    if buffer and buffer.bufnr > 0 then
      local ok, res = pcall(vim.api.nvim_buf_get_var,
        buffer.bufnr, 'gitsigns_status_dict')
      if ok then stats = res end
    end
    local counts = {
      insert = stats.added > 0 and stats.added or nil,
      change = stats.changed > 0 and stats.changed or nil,
      delete = stats.removed > 0 and stats.removed or nil,
    }
    if not vim.tbl_isempty(counts) then
      local fmt = opts.fmt or "%s"
      local out = formatter(window, buffer, counts)
      return out and fmt:format(out) or nil
    else
      -- el functions that return a
      -- string must not return nil
      return ""
    end
  end)
end

M.git_changes_all = function(opts)
  opts = opts or {}
  local formatter = opts.formatter or git_changes_formatter(opts)
  return el_sub.buf_autocmd("el_git_changes", "BufWritePost",
    wrap_fnc(opts, function(window, buffer)
      if not buffer or
        not (buffer.bufnr>0) or
        vim.bo[buffer.bufnr].bufhidden ~= "" or
        vim.bo[buffer.bufnr].buftype  == "nofile" or
        vim.fn.filereadable(buffer.name) ~= 1 then
        return
      end

      local j = Job:new {
        command = "git",
        args = { "diff", "--shortstat" },
        -- makes no sense to run for one file as
        -- 'file(s) changed' will always be 1
        -- args = { "diff", "--shortstat", buffer.name },
        cwd = vim.fn.fnamemodify(buffer.name, ":h"),
      }

      local ok, git_changes = pcall(function()
        return formatter(window, buffer, vim.trim(j:sync()[1]))
      end)

      if ok then
        local fmt = opts.fmt or "%s"
        return git_changes and fmt:format(git_changes) or nil
      end
    end))
end

local function lsp_srvname()
  local buf_ft = vim.api.nvim_buf_get_option(0, 'filetype')
  local clients = vim.lsp.get_active_clients()
  if next(clients) == nil then
    return nil
  end
  for _, client in ipairs(clients) do
    local filetypes = client.config.filetypes
    if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
      return client.name
    end
  end
  return nil
end

local function diag_formatter(opts)
  return function(_, _, counts)
    local items = {}
    local icons = {
     ['errors']     = { opts.icon_err or 'E',  opts.hl_err },
     ['warnings']   = { opts.icon_warn or 'W', opts.hl_warn },
     ['infos']      = { opts.icon_info or 'I', opts.hl_info },
     ['hints']      = { opts.icon_hint or 'H', opts.hl_hint },
   }
    for _, k in ipairs({ 'errors', 'warnings', 'infos', 'hints' }) do
      if counts[k] > 0 then
        table.insert(items,
          set_hl(icons[k][2], ("%s:%s"):format(icons[k][1], counts[k])))
      end
    end
    local fmt = opts.fmt or "%s"
    local lsp_name = opts.lsp and lsp_srvname()
    if not lsp_name and vim.tbl_isempty(items) then
      return ""
    else
      local contents = lsp_name
      if not vim.tbl_isempty(items) then
        contents = ("%s %s"):format(lsp_name, table.concat(items, " "))
      end
      return fmt:format(contents)
    end
  end
end

local get_buffer_counts = function(diagnostic, _, buffer)
  local counts = {  0, 0, 0, 0 }
  local diags = diagnostic.get(buffer.bufnr)
  if diags and not vim.tbl_isempty(diags) then
    for _, d in ipairs(diags) do
      if tonumber(d.severity) then
        counts[d.severity] = counts[d.severity] + 1
      end
    end
  end
  return {
    errors    = counts[1],
    warnings  = counts[2],
    infos     = counts[3],
    hints     = counts[4],
  }
end

M.lsp_diagnostics = function(opts)
  opts = opts or {}
  local formatter = opts.formatter or diag_formatter(opts)
  return el_sub.user_autocmd("el_buf_diagnostic", "LspDiagnosticsChanged",
    wrap_fnc(opts, function(window, buffer)
      return formatter(window, buffer, get_buffer_counts(vim.lsp.diagnostic, window, buffer))
    end))
end


M.vim_diagnostics = function(opts)
  opts = opts or {}
  local formatter = opts.formatter or diag_formatter(opts)
  return el_sub.buf_autocmd("el_buf_diagnostic", "DiagnosticChanged",
    wrap_fnc(opts, function(window, buffer)
      return formatter(window, buffer, get_buffer_counts(vim.diagnostic, window, buffer))
    end))
end

M.diagnostics = function(opts)
  if vim.diagnostic then
    return M.vim_diagnostics(opts)
  else
    return M.lsp_diagnostics(opts)
  end
end

return M
