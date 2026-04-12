return {
  src = "https://github.com/esmuellert/codediff.nvim",
  data = {
    cmd = { "CodeDiff" },
    after = function()
      require("codediff").setup({
        explorer = { view_mode = "tree" },
        diff = { cycle_next_hunk = false },
      })
    end,
  },
}
