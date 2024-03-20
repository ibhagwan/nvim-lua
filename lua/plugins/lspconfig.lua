return {
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
    dependencies = {
      {
        "folke/neodev.nvim",
        enabled = true,
        config = function()
          require("neodev").setup({
            library = {
              types = true,
              runtime = true,
              plugins = true,
              -- plugins = { "fzf-lua" },
            },
            -- much faster, but needs a recent built of lua-language-server
            -- needs lua-language-server >= 3.6.0
            pathStrict = true,
            -- (1) for Neovim config directory, the config.library settings will be used as is
            -- (2) for plugin directories (root_dirs having a /lua directory),
            --     config.library.plugins will be disabled
            -- (3) for any other directory, config.library.enabled will be set to false
            -- override by returning a modified `library` table
            ---@param root_dir string
            ---@param library table
            ---@return table?
            override = function(root_dir, library)
              return library
            end,
          })
        end,
      },
      {
        "j-hui/fidget.nvim",
        config = function()
          require("fidget").setup({})
        end
      },
      { "hrsh7th/cmp-nvim-lsp" },
    },
    config = function()
      require("lsp")
    end
  }
}
