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
  if fzf_lua.config.globals.fzf_bin == "fzf-tmux" then
    opts.fzf_tmux_opts = { ["-p"] = "100%,100%" }
    return fzf_lua.git_status(opts)
  end

  opts = opts or {}
  opts.fn_pre_win = function(_)
    if not opts.__want_resume then
      -- new fzf window, if unzoomed, toggle tmux zoom (-Z)
      -- add small delay or fzf win gets wrong dimensions
      opts._tmux_was_unzoomed = utils.tmux_zoom()
      vim.cmd("sleep! 20m")
    end
    opts.__want_resume = nil
  end
  opts.fn_post_fzf = function(_, s)
    -- ignore triggers on resume (stage|unstage|reset)
    -- this also signals `fn_pre` to ignore the event
    opts.__want_resume = s and (s[1] == "left" or s[1] == "right" or s[1] == "ctrl-x")
    if not opts.__want_resume then
      if opts._tmux_was_unzoomed then
        utils.tmux_unzoom()
      end
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

function M.workdirs(opts)
  if not opts then opts = {} end

  -- workdirs.lua returns a table of workdirs
  local ok, dirs = pcall(function() return require("workdirs").get() end)
  if not ok then dirs = {} end

  local fzf_fn = function(cb)
    for i, entry in ipairs(dirs) do
      if i == 1 then
        entry = fzf_lua.utils.ansi_codes.yellow(entry:sub(1, 1)) .. entry:sub(2)
      elseif i == 2 then
        entry = fzf_lua.utils.ansi_codes.magenta(entry:sub(1, 1)) .. entry:sub(2)
      else
        entry = fzf_lua.utils.ansi_codes.blue(entry:sub(1, 1)) .. entry:sub(2)
      end
      cb(entry)
    end
    cb(nil)
  end

  opts.fzf_opts = {
    ["--no-multi"]       = "",
    ["--preview-window"] = "hidden:right:0",
    ["--header-lines"]   = "1",
    -- ["--prompt"]         = "Workdirs❯ ",
  }

  opts.winopts = vim.tbl_deep_extend("force", opts.winopts or {}, {
    title = { { " Workdirs ", "Cursor" } },
    title_pos = "center",
  })

  opts.actions = {
    ["default"] = function(selected)
      if not selected[1] then return end
      require("workdirs").PREV_CWD = vim.loop.cwd()
      local newcwd = vim.fs.normalize(selected[1]:match("[^ ]*$"))
      require("utils").set_cwd(newcwd)
    end
  }

  fzf_lua.fzf_exec(fzf_fn, opts)
end

return M
