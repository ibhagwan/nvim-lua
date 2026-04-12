return {
  src = "https://github.com/stevearc/conform.nvim",
  data = {
    event = "BufReadPost",
    after = function()
      require("conform").setup({
        formatters_by_ft = {
          lua = { "stylua" },
          python = { "black" },
          css = { "prettier", "prettierd", stop_after_first = true },
          html = { "prettier", "prettierd", stop_after_first = true },
          yaml = { "prettier", "prettierd", stop_after_first = true },
          json = { "prettier", "prettierd", stop_after_first = true },
          jsonc = { "prettier", "prettierd", stop_after_first = true },
          json5 = { "prettier", "prettierd", stop_after_first = true },
          javascript = { "prettier", "prettierd", stop_after_first = true },
        },
      })
    end,
  },
}
