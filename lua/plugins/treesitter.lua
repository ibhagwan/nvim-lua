return {
  {
    "nvim-treesitter/nvim-treesitter-context",
    dependencies = { "nvim-treesitter/nvim-treesitter-textobjects" },
    cmd = { "TSContextEnable", "TSContextDisable", "TSContextToggle" },
    keys = {
      {
        "[C",
        function()
          require("treesitter-context").go_to_context(vim.v.count1)
        end,
        silent = true,
        desc = "Goto treesitter context"
      },
      {
        "]C",
        function() require("treesitter-context").toggle() end,
        silent = true,
        desc = "Toggle treesitter context"
      },
    },
    opts = {},
    config = function()
      require("treesitter-context").setup({ enable = true, multiwindow = true })
    end,
    enabled = true
  },
  {
    "nvim-treesitter/nvim-treesitter",
    -- treesitter requires a C compiler
    cond = not require("utils").is_NetBSD() and require("utils").have_compiler,
    event = "BufReadPost",
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
      "nvim-treesitter/nvim-treesitter-context",
    },
    build = function()
      -- build step is run independent of the condition
      -- make sure we have treesitter before running ':TSUpdate'
      if require("utils").have_compiler() then
        vim.cmd("TSUpdate")
      end
    end,
    config = function()
      require "nvim-treesitter.configs".setup {
        ensure_installed = {
          "bash",
          "c",
          "cpp",
          "go",
          "javascript",
          "typescript",
          "json",
          "jsonc",
          "jsdoc",
          "lua",
          "python",
          "rust",
          "html",
          "yaml",
          "css",
          "toml",
          "markdown",
          "markdown_inline",
          "solidity",
          "vimdoc",
          -- for `nvim-treesitter/playground` / `:InspectTree`
          "query",
        },
        highlight = { enable = true },
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = "<CR>",
            node_incremental = "<CR>",
            node_decremental = "<S-Tab>",
            scope_incremental = "<Tab>",
          },
        },
        textobjects = {
          select = {
            enable = true,
            -- Automatically jump forward to textobj, similar to targets.vim
            lookahead = true,
            keymaps = {
              ["ac"] = { query = "@comment.outer", desc = "Select comment (outer)" },
              ["ic"] = { query = "@comment.inner", desc = "Select comment (inner)" },
              ["ao"] = { query = "@class.outer", desc = "Select class (outer)" },
              ["io"] = { query = "@class.inner", desc = "Select class (inner)" },
              ["af"] = { query = "@function.outer", desc = "Select function (outer)" },
              ["if"] = { query = "@function.inner", desc = "Select function (inner)" },
              ["ap"] = { query = "@parameter.outer", desc = "Select parameter (outer)" },
              ["ip"] = { query = "@parameter.inner", desc = "Select parameter (inner)" },
              ["as"] = { query = "@scope", query_group = "locals", desc = "Select language scope" }
            },
            selection_modes = {
              -- default is charwise 'v'
              ["@parameter.inner"] = "v", -- charwise
              ["@parameter.outer"] = "v", -- charwise
              ["@function.inner"] = "V",  -- linewise
              ["@function.outer"] = "V",  -- linewise
              ["@class.inner"] = "V",     -- linewise
              ["@class.outer"] = "V",     -- linewise
              ["@scope"] = "v",           -- charwise
            },
          },
          move = {
            enable = true,
            set_jumps = true, -- whether to set jumps in the jumplist
            goto_next = {     -- jump to next start or end
              ["]f"] = { query = "@function.outer", desc = "Next function start|end" },
              -- overrides next misspelled word
              -- ["]s"] = { query = "@scope", query_group = "locals", desc = "Next scope" },
            },
            goto_previous = { -- jump to previous start or end
              ["[f"] = { query = "@function.outer", desc = "Previous function start" },
              -- overrides previous misspelled word
              -- ["[s"] = { query = "@scope", query_group = "locals", desc = "Previous scope" },
            },
            goto_next_start = {
              ["]F"] = { query = "@function.outer", desc = "Next function" },
              ["]p"] = { query = "@parameter.inner", desc = "Next parameter" },
            },
            goto_previous_start = {
              ["[F"] = { query = "@function.outer", desc = "Previous function" },
              ["[p"] = { query = "@parameter.inner", desc = "Previous parameter" },
            },
          },
        },
      }
      -- repeat `]f` moves with `;,` disabled as doesn't fallback to normal `;,`
      -- local ts_repeat_move = require "nvim-treesitter.textobjects.repeatable_move"
      -- vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move)
      -- vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_opposite)
    end,
  }
}
