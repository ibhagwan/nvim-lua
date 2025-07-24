local utils = require("utils")

return {
  {
    "williamboman/mason-lspconfig.nvim",
    enabled = utils.__HAS_NVIM_011,
    event = { "VeryLazy", "BufReadPre" },
    dependencies = {
      { "neovim/nvim-lspconfig" },
      { "mason-org/mason.nvim" },
      { "j-hui/fidget.nvim" },
    },
    config = function()
      -- Add the same capabilities to ALL server configurations.
      -- Refer to :h vim.lsp.config() for more information.
      vim.lsp.config("*", {
        capabilities = vim.lsp.protocol.make_client_capabilities()
      })
      require("lsp.diag")
      require("lsp.icons")
      require("fidget").setup({})
      require("mason").setup()
      require("mason-lspconfig").setup({
        ensure_installed = not utils.is_NetBSD()
            and not utils.is_iSH()
            and { "lua_ls" }
            or nil,
      })
    end,
  },
  {
    "mfussenegger/nvim-jdtls",
    ft = "java",
  },
  {
    "folke/lazydev.nvim",
    enabled = false,
    ft = "lua",
    opts = {
      library = {
        -- Load luvit types when the `vim.uv` word is found
        { path = "$(3rd)/luv/library", words = { "vim%.uv" } },
        -- Always luad fzf-lua
        "fzf-lua",
      },
      -- uncomment to disable when a .luarc.json file is found
      -- enabled = function(root_dir)
      --   return not vim.uv.fs_stat(root_dir .. "/.luarc.json")
      --       and not vim.uv.fs_stat(root_dir .. "/.luarc.jsonc")
      -- end,
    },
  },
}
