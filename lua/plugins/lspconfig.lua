return {
  { "j-hui/fidget.nvim" },
  { "williamboman/mason-lspconfig.nvim" },
  {
    "neovim/nvim-lspconfig",
    event = "BufReadPre",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      require("fidget").setup()
      require("mason-lspconfig").setup({
        ensure_installed = { "sumneko_lua" },
      })
      -- lazy load null-ls
      require("null-ls")
      require("lsp")
    end
  }
}
