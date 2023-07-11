return {
  { "j-hui/fidget.nvim", tag = "legacy" },
  { "williamboman/mason-lspconfig.nvim" },
  {  "mfussenegger/nvim-jdtls", ft = "java" },
  {
    "neovim/nvim-lspconfig",
    event = "BufReadPre",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      require("fidget").setup()
      require("mason-lspconfig").setup({
        ensure_installed = not require("utils").is_NetBSD() and { "lua_ls" } or nil,
      })
      -- lazy load null-ls
      require("null-ls")
      require("lsp")
    end
  }
}
