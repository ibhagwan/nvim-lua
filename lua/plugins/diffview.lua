local utils = require("utils")

local M = {
  "sindrets/diffview.nvim",
  cmd = { "DiffviewOpen", "DiffviewFileHistory" },
}

M._is_open = function()
  return package.loaded.diffview and require("diffview.lib").get_current_view()
end

M._close = function()
  if M._is_open() then
    vim.cmd("DiffviewClose")
    return 0
  end
end

M._toggle = function(git_args)
  if M._is_open() then
    return M._close()
  else
    git_args = git_args or {}
    local git_cmd = { "git" }
    for _, arg in ipairs(git_args) do
      table.insert(git_cmd, arg:match("%$") and vim.fn.expand(arg) or arg)
    end
    table.insert(git_cmd, "status")
    local ret = vim.system(git_cmd):wait()
    if #ret.stderr > 0 then
      utils.warn(ret.stderr)
      return
    end
    local no_changes = ret.stdout:match("nothing to commit")
    local diffview_cmd = { "DiffviewOpen" }
    -- DiffviewOpen needs the args to be in the format of key=val
    for i = 1, #git_args, 2 do
      table.insert(diffview_cmd, string.format("%s=%s", git_args[i], git_args[i + 1]))
    end
    table.insert(diffview_cmd, no_changes and "HEAD~" or "HEAD")
    vim.cmd(table.concat(diffview_cmd, " "))
    return 1
  end
end

M.init = function()
  vim.keymap.set({ "n", "x" }, "<leader>gd",
    function()
      if M._toggle() == 1 then
        M._tmux_was_unzoomed = utils.tmux_zoom()
      end
    end,
    { silent = true, desc = "Git diff (project)" })

  vim.keymap.set({ "n", "x" }, "<leader>yd",
    function()
      if
          M._toggle({
            "-c", "status.showUntrackedFiles=no",
            "--git-dir", "$HOME/dots/.git",
            "-C", "$HOME",
          }) == 1
      then
        M._tmux_was_unzoomed = utils.tmux_zoom()
      end
    end,
    { silent = true, desc = "Git diff (yadm)" })
end

M.config = function()
  local gq_keymap_set_opts = {
    { "n", "v" }, "gq", M._close, { silent = true, desc = "Close Diffview" }
  }
  require("diffview").setup({
    keymaps = {
      view = { gq_keymap_set_opts },
      file_panel = { gq_keymap_set_opts },
      file_history_panel = { gq_keymap_set_opts },
      option_panel = { gq_keymap_set_opts },
    },
    hooks = {
      -- view_opened = function(_) end
      view_closed = function()
        if M._tmux_was_unzoomed then
          utils.tmux_unzoom()
        end
        -- remap `gq` to conform since we hijacked it to `DiffviewClose`
        for _, w in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
          local b = vim.api.nvim_win_get_buf(w)
          require("plugins.conform")._set_gq_keymap({ buf = b })
        end
      end
    }
  })
end

return M
