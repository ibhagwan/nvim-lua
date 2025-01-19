local M = {}

local utils = require("utils")
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
  opts = opts or {}

  -- Pre fzf v0.53: fzf-tmux script
  if fzf_lua.config.globals.fzf_bin == "fzf-tmux" then
    opts.fzf_tmux_opts = { ["-p"] = "100%,100%" }
    return fzf_lua.git_status(opts)
  end

  -- Post fzf v0.53: "--tmux" flag
  if fzf_lua.config.globals.fzf_opts["--tmux"] then
    opts.fzf_opts = opts.fzf_opts or {}
    opts.fzf_opts["--tmux"] = "100%,100%"
    return fzf_lua.git_status(opts)
  end

  opts.winopts = opts.winopts or {}
  opts.winopts.on_create = function(_)
    if opts._tmux_was_unzoomed == nil then
      opts._tmux_was_unzoomed = utils.tmux_zoom()
    end
  end
  opts.winopts.on_close = function()
    if opts._tmux_was_unzoomed then
      utils.tmux_unzoom()
    end
  end
  fzf_lua.git_status(opts)
end

function M.diagnostics_document(opts)
  opts = opts or {}
  opts.diag_source = #utils.lsp_get_clients({ bufnr = vim.api.nvim_get_current_buf() }) > 1
      and true or false
  opts.icon_padding = opts.diag_source and "" or " "
  fzf_lua.diagnostics_document(opts)
end

function M.diagnostics_workspace(opts)
  opts = opts or {}
  opts.diag_source = #utils.lsp_get_clients() > 1 and true or false
  opts.icon_padding = opts.diag_source and "" or " "
  fzf_lua.diagnostics_workspace(opts)
end

return M
