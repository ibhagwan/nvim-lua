local M = {
  "esmuellert/codediff.nvim",
  dependencies = { "MunifTanjim/nui.nvim" },
  cmd = { "CodeDiff" },
}

M.config = function()
  require("codediff").setup({
    explorer = { view_mode = "tree" },
    keymaps = {
      view = {
        quit = "gq",
        toggle_explorer = "<leader>e"
      }
    },
  })
end

return M
