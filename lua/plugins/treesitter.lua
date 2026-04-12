return {

  -- nvim-treesitter-textobjects (must be loaded before nvim-treesitter)
  {
    src = "https://github.com/nvim-treesitter/nvim-treesitter-textobjects",
    version = "main",
    data = { lazy = true },
  },

  -- nvim-treesitter-context
  {
    src = "https://github.com/nvim-treesitter/nvim-treesitter-context",
    data = {
      lazy = true,
      cmd = { "TSContextEnable", "TSContextDisable", "TSContextToggle" },
      beforeAll = function()
        vim.keymap.set({ "n" }, "[C",
          function() require("treesitter-context").go_to_context(vim.v.count1) end,
          { silent = true, desc = "Goto treesitter context" })
        vim.keymap.set({ "n" }, "]C",
          function() require("treesitter-context").toggle() end,
          { silent = true, desc = "Toggle treesitter context" })
      end,
      after = function()
        require("treesitter-context").setup({ enable = true })
      end,
    },
  },

  -- nvim-treesitter (main plugin)
  {
    src = "https://github.com/nvim-treesitter/nvim-treesitter",
    version = "main",
    data = {
      event = "BufReadPost",
      cmd = { "TSUpdate" },
      before = function()
        ---@diagnostic disable-next-line: missing-fields
        require("lz.n").trigger_load({ "nvim-treesitter-context", "nvim-treesitter-textobjects" })
      end,
      after = function()
        require("nvim-treesitter").setup({})
        require("nvim-treesitter-textobjects").setup({
          select = {
            selection_modes = {
              ["@parameter.inner"] = "v",
              ["@parameter.outer"] = "v",
              ["@function.inner"] = "V",
              ["@function.outer"] = "V",
              ["@class.inner"] = "V",
              ["@class.outer"] = "V",
              ["@scope"] = "v",
            },
          },
          move = { set_jumps = true },
        })

        local ts_sel = require("nvim-treesitter-textobjects.select")
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

        local ts_move = require("nvim-treesitter-textobjects.move")
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

        -- Repeat moves with ;,
        local ts_repeat_move = require("nvim-treesitter-textobjects.repeatable_move")
        vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move)
        vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_opposite)
        vim.keymap.set({ "n", "x", "o" }, "f", ts_repeat_move.builtin_f_expr, { expr = true })
        vim.keymap.set({ "n", "x", "o" }, "F", ts_repeat_move.builtin_F_expr, { expr = true })
        vim.keymap.set({ "n", "x", "o" }, "t", ts_repeat_move.builtin_t_expr, { expr = true })
        vim.keymap.set({ "n", "x", "o" }, "T", ts_repeat_move.builtin_T_expr, { expr = true })
      end,
    },
  }
}
