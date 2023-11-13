return {
  {
    "j-hui/fidget.nvim",
    config = function()
      require("fidget").setup()
    end
  },
  {
    "williamboman/mason-lspconfig.nvim",
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = not require("utils").is_NetBSD() and { "lua_ls" } or nil,
      })
    end
  },
  {
    "mfussenegger/nvim-jdtls",
    ft = "java"
  },
  {
    "neovim/nvim-lspconfig",
    event = "BufReadPre",
    dependencies = { "hrsh7th/cmp-nvim-lsp" },
    config = function()
      require("fidget")
      require("lsp")
    end
  }
}
