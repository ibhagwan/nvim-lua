return {
  src = "https://github.com/stevearc/conform.nvim",
  data = {
    event = "BufReadPost",
    after = function()
      require("conform").setup({
        -- Downloaded by fzf-lua's `make deps/emmylua`
        formatters = { luafmt = { command = ".emmylua/luafmt" } },
        formatters_by_ft = {
          lua = { "luafmt" },
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
