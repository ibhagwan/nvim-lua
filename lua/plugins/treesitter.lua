return {
  {
    "nvim-treesitter/nvim-treesitter-context",
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
      require("treesitter-context").setup({ enable = true })
    end,
    enabled = true
  },
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    -- treesitter requires a C compiler
    cond = require("utils").have_compiler,
    event = "BufReadPost",
    cmd = { "TSUpdate", "TSUpdateSync" },
    dependencies = {
      { "nvim-treesitter/nvim-treesitter-textobjects", branch = "main" },
      { "nvim-treesitter/nvim-treesitter-context" },
    },
    build = function()
      if not require("utils").have_compiler() then return end
      -- build step is run independent of the condition
      -- make sure we have treesitter before running ':TSUpdate'
      require "nvim-treesitter".install({
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
        "regex",
      })
      vim.cmd("TSUpdate")
    end,
    config = function()
      require "nvim-treesitter".setup {}
      require("nvim-treesitter-textobjects").setup {
        select = {
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
        move = { set_jumps = true },
      }

      local ts_sel = require "nvim-treesitter-textobjects.select"
      vim.keymap.set({ "x", "o" }, "af", function()
        ts_sel.select_textobject("@function.outer", "textobjects")
      end)
      vim.keymap.set({ "x", "o" }, "if", function()
        ts_sel.select_textobject("@function.inner", "textobjects")
      end)
      vim.keymap.set({ "x", "o" }, "ap", function()
        ts_sel.select_textobject("@parameter.outer", "textobjects")
      end)
      vim.keymap.set({ "x", "o" }, "ac", function()
        ts_sel.select_textobject("@comment.outer", "textobjects")
      end)

      local ts_move = require "nvim-treesitter-textobjects.move"
      vim.keymap.set({ "n", "x", "o" }, "]f", function()
        ts_move.goto_next("@function.outer", "textobjects")
      end, { desc = "Next function boundary" })
      vim.keymap.set({ "n", "x", "o" }, "[f", function()
        ts_move.goto_previous("@function.outer", "textobjects")
      end, { desc = "Previous function boundary" })
      vim.keymap.set({ "n", "x", "o" }, "]F", function()
        ts_move.goto_next_start("@function.outer", "textobjects")
      end, { desc = "Next function start" })
      vim.keymap.set({ "n", "x", "o" }, "[F", function()
        ts_move.goto_previous_start("@function.outer", "textobjects")
      end, { desc = "Previous function start" })
      vim.keymap.set({ "n", "x", "o" }, "]p", function()
        ts_move.goto_next_start("@parameter.inner", "textobjects")
      end, { desc = "Next parameter" })
      vim.keymap.set({ "n", "x", "o" }, "[p", function()
        ts_move.goto_previous_start("@parameter.inner", "textobjects")
      end, { desc = "Previous parameter" })

      -- repeat `]f` moves with `;,`
      local ts_repeat_move = require "nvim-treesitter-textobjects.repeatable_move"
      vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move)
      vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_opposite)
      vim.keymap.set({ "n", "x", "o" }, "f", ts_repeat_move.builtin_f_expr, { expr = true })
      vim.keymap.set({ "n", "x", "o" }, "F", ts_repeat_move.builtin_F_expr, { expr = true })
      vim.keymap.set({ "n", "x", "o" }, "t", ts_repeat_move.builtin_t_expr, { expr = true })
      vim.keymap.set({ "n", "x", "o" }, "T", ts_repeat_move.builtin_T_expr, { expr = true })
    end,
  }
}
