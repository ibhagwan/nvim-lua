return {
  "stevearc/conform.nvim",
  event = "BufReadPost",
  config = function()
    require("conform").setup({
      formatters_by_ft = {
        lua = { "stylua" },
        html = { { "prettier", "prettierd" } },
        jsonc = { { "prettier", "prettierd" } },
        javascript = { { "prettier", "prettierd" } },
      },
    })
  end,
}
