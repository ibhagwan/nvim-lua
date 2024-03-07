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

M._toggle = function(open_args)
  if M._is_open() then
    return M._close()
  else
    open_args = open_args or ""
    vim.cmd("DiffviewOpen" .. open_args)
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
          M._toggle(" -c=status.showUntrackedFiles=no --git-dir=$HOME/dots/.git -C=$HOME") == 1
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
