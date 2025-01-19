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
