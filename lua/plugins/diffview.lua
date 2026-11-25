local utils = require("utils")

local M = {}

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
    local no_changes = (ret.stdout or ""):match("nothing to commit")
    local diffview_cmd = { "DiffviewOpen" }
    for i = 1, #git_args, 2 do
      table.insert(diffview_cmd, string.format("%s=%s", git_args[i], git_args[i + 1]))
    end
    table.insert(diffview_cmd, no_changes and "HEAD~" or "HEAD")
    vim.cmd(table.concat(diffview_cmd, " "))
    return 1
  end
end

return {
  src = "https://github.com/dlyongemallo/diffview-plus.nvim",
  data = {
    cmd = { "DiffviewOpen", "DiffviewFileHistory" },
    beforeAll = function()
      vim.keymap.set({ "n", "x" }, "<leader>gd", function()
        if M._toggle() == 1 then
          M._tmux_was_unzoomed = utils.tmux_zoom()
        end
      end, { silent = true, desc = "Git diff (project)" }
      )

      vim.keymap.set({ "n", "x" }, "<leader>yd", function()
        if M._toggle({
          "-c",
          "status.showUntrackedFiles=no",
          "--git-dir",
          "$HOME/dots/.git",
          "-C",
          "$HOME",
        }) == 1 then
          M._tmux_was_unzoomed = utils.tmux_zoom()
        end
      end, { silent = true, desc = "Git diff (yadm)" }
      )
    end,
    after = function()
      local a = require("diffview.config").actions
      local function keymap_opts(k, fn, desc)
        return { { "n", "v" }, k, fn, { silent = true, desc = desc } }
      end
      local q_keymap = keymap_opts("q", M._close, "Close Diffview")
      local gq_keymap = keymap_opts("gq", M._close, "Close Diffview")
      local next_entry_keymap = keymap_opts("]f", a.select_next_entry, "Next file")
      local prev_entry_keymap = keymap_opts("[f", a.select_prev_entry, "Previous file")
      local keymaps = { q_keymap, gq_keymap, next_entry_keymap, prev_entry_keymap }
      require("diffview").setup({
        keymaps = {
          view = { unpack(keymaps) },
          file_panel = { unpack(keymaps) },
          file_history_panel = { unpack(keymaps) },
          option_panel = { unpack(keymaps) },
        },
        hooks = {
          view_closed = function()
            if M._tmux_was_unzoomed then
              utils.tmux_unzoom()
            end
            -- Remap gq to conform
            for _, w in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
              local b = vim.api.nvim_win_get_buf(w)
              require("lsp.keymaps").setup_gq({ buf = b })
            end
          end,
        },
      })
    end,
  },
}
