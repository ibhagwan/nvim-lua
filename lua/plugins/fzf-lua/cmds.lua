local M = {}

local fzf_lua = require("fzf-lua")

function M.git_bcommits(opts)
  local function diffthis(action)
    return function(...)
      local curwin = vim.api.nvim_get_current_win()
      action(...)
      vim.cmd("windo diffthis")
      vim.api.nvim_set_current_win(curwin)
    end
  end

  opts.actions = {
    ["ctrl-v"] = diffthis(fzf_lua.actions.git_buf_vsplit),
  }
  return fzf_lua.git_bcommits(opts)
end

function M.git_status_tmuxZ(opts)
  if fzf_lua.config.globals.fzf_bin == "fzf-tmux" then
    opts.fzf_tmux_opts = { ["-p"] = "100%,100%" }
    return fzf_lua.git_status(opts)
  end

  local function tmuxZ()
    vim.cmd("!tmux resize-pane -Z")
  end

  opts = opts or {}
  opts.fn_pre_win = function(_)
    if not opts.__want_resume then
      -- new fzf window, set tmux Z
      -- add small delay or fzf
      -- win gets wrong dimensions
      tmuxZ()
      vim.cmd("sleep! 20m")
    end
    opts.__want_resume = nil
  end
  opts.fn_post_fzf = function(_, s)
    opts.__want_resume = s and (s[1] == "left" or s[1] == "right")
    if not opts.__want_resume then
      -- resume asked do not resize
      -- signals fn_pre to do the same
      tmuxZ()
    end
  end
  fzf_lua.git_status(opts)
end

local _previous_cwd = nil

function M.diagnostics_document(opts)
  opts = opts or {}
  opts.diag_source =
      #vim.lsp.get_active_clients({ bufnr = vim.api.nvim_get_current_buf() }) > 1
      and true or false
  opts.icon_padding = opts.diag_source and "" or " "
  fzf_lua.diagnostics_document(opts)
end

function M.diagnostics_workspace(opts)
  opts = opts or {}
  opts.diag_source = #vim.lsp.get_active_clients() > 1 and true or false
  opts.icon_padding = opts.diag_source and "" or " "
  fzf_lua.diagnostics_workspace(opts)
end

function M.workdirs(opts)
  if not opts then opts = {} end

  -- workdirs.lua returns a table of workdirs
  local ok, dirs = pcall(require, "workdirs")
  if not ok then dirs = {} end

  local iconify = function(path, color, icon)
    icon = fzf_lua.utils.ansi_codes[color](icon)
    path = fzf_lua.path.relative(path, vim.env.HOME)
    return ("%s  %s"):format(icon, path)
  end

  local dedup = {}
  local entries = {}
  local add_entry = function(path, color, icon)
    if not path then return end
    path = vim.fn.expand(path)
    if not vim.loop.fs_stat(path) then return end
    if dedup[path] ~= nil then return end
    entries[#entries + 1] = iconify(path, color or "blue", icon or "")
    dedup[path] = true
  end

  add_entry(vim.loop.cwd(), "magenta", "")
  add_entry(_previous_cwd, "yellow")
  for _, path in ipairs(dirs) do
    add_entry(path)
  end

  local fzf_fn = function(cb)
    for _, entry in ipairs(entries) do
      cb(entry)
    end
    cb(nil)
  end

  opts.fzf_opts = {
    ["--no-multi"]       = "",
    ["--prompt"]         = "Workdirs❯ ",
    ["--preview-window"] = "hidden:right:0",
    ["--header-lines"]   = "1",
  }

  opts.actions = {
    ["default"] = function(selected)
      _previous_cwd = vim.loop.cwd()
      local newcwd = selected[1]:match("[^ ]*$")
      newcwd = fzf_lua.path.starts_with_separator(newcwd) and newcwd
          or fzf_lua.path.join({ vim.env.HOME, newcwd })
      require "utils".set_cwd(newcwd)
    end
  }

  fzf_lua.fzf_exec(fzf_fn, opts)
end

return M
