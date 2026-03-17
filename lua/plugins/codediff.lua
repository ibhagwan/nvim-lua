local M = {
  "esmuellert/codediff.nvim",
  dependencies = { "MunifTanjim/nui.nvim" },
  cmd = { "CodeDiff" },
}

M.config = function()
  vim.api.nvim_create_autocmd("User", {
    pattern = "CodeDiffClose",
    callback = function()
      require("plugins.gitsigns").set_hunk_navigation_keymaps(vim.api.nvim_get_current_buf())
    end
  })
  require("codediff").setup({
    explorer = { view_mode = "tree" },
    diff = { cycle_next_hunk = false },
  })
end

return M
