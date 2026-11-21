return {
  src = "https://github.com/stevearc/conform.nvim",
  data = {
    event = "BufReadPost",
    after = function()
      -- `.emmylua/luafmt` is downloaded by this repo's `make deps/emmylua`;
      -- fall back to `luafmt` on PATH (e.g. mason) when not present.
      local luafmt = vim.fs.joinpath(tostring(vim.fn.stdpath("config")), ".emmylua", "luafmt")
      if vim.fn.executable(luafmt) == 0 then luafmt = "luafmt" end
      require("conform").setup({
        formatters = { luafmt = { command = luafmt } },
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
