return {
  {
    "williamboman/mason-lspconfig.nvim",
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = not require("utils").is_NetBSD() and { "lua_ls" } or nil,
      })
    end,
  },
  {
    "mfussenegger/nvim-jdtls",
    ft = "java",
  },
  {
    "neovim/nvim-lspconfig",
    event = "BufReadPre",
    dependencies = {
      {
        "j-hui/fidget.nvim",
        config = function()
          require("fidget").setup({})
        end,
      },
      {
        "hrsh7th/cmp-nvim-lsp",
        enabled = not require("utils").USE_BLINK_CMP,
      },
    },
    config = function()
      require("lsp")
    end,
  },
  {
    "folke/lazydev.nvim",
    enabled = true,
    ft = "lua",
    opts = {
      library = {
        -- Load luvit types when the `vim.uv` word is found
        { path = "luvit-meta/library", words = { "vim%.uv" } },
      },
    },
    -- optional `vim.uv` typings
    dependencies = { "Bilal2453/luvit-meta", lazy = true },
  },
}
