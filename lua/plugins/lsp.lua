return {
  -- nvim-lspconfig (base LSP configuration)
  { src = "https://github.com/neovim/nvim-lspconfig",   data = { lazy = true } },

  -- mason.nvim (LSP installer)
  { src = "https://github.com/mason-org/mason.nvim",    data = { lazy = true } },

  -- fidget.nvim (LSP progress indicator)
  { src = "https://github.com/j-hui/fidget.nvim",       data = { lazy = true } },

  -- nvim-jdtls (Java LSP)
  { src = "https://github.com/mfussenegger/nvim-jdtls", data = { ft = "java" } },

  -- mason-lspconfig.nvim (bridge between mason and lspconfig)
  {
    src = "https://github.com/williamboman/mason-lspconfig.nvim",
    data = {
      cmd = { "Mason" },
      event = { "BufReadPre" },
      before = function()
        ---@diagnostic disable-next-line: missing-fields
        require("lz.n").trigger_load({ "nvim-lspconfig", "mason.nvim", "fidget.nvim" })
      end,
      after = function()
        local utils = require("utils")
        -- Add the same capabilities to ALL server configurations
        vim.lsp.config("*", { capabilities = vim.lsp.protocol.make_client_capabilities() })
        require("lsp.diag")
        require("lsp.icons")
        require("fidget").setup({})
        require("mason").setup()
        require("mason-lspconfig").setup({
          ensure_installed = not utils.is_NetBSD()
              and not utils.is_iSH()
              and { "emmylua_ls" }
              or nil,
        })
      end,
    },
  }
}
