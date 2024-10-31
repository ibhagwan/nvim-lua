local M = {
  "folke/which-key.nvim",
  enabled = vim.fn.has("nvim-0.9.4") == 1,
  event = "VeryLazy",
}

M.keys = {
  {
    mode = { "n", "v" },
    "<Leader>?",
    function()
      require("which-key").show({ global = true })
    end,
    silent = true,
    desc = "Which-key root"
  }
}

M.config = function()
  local wk = require("which-key")
  wk.setup({
    ---@type false | "classic" | "modern" | "helix"
    preset = "helix",
    plugins = {
      marks = true,     -- shows a list of your marks on ' and `
      registers = true, -- shows your registers on " in NORMAL or <C-r> in INSERT mode
      -- the presets plugin, adds help for a bunch of default keybindings in Neovim
      -- No actual key bindings are created
      spelling = {
        enabled = true,  -- enabling this will show WhichKey when pressing z= to spell suggest
        suggestions = 20 -- how many suggestions should be shown in the list?
      },
      presets = {
        operators = false,    -- adds help for operators like d, y, ...
        motions = false,      -- adds help for motions
        text_objects = false, -- help for text objects triggered after entering an operator
        windows = true,       -- default bindings on <c-w>
        nav = true,           -- misc bindings to work with windows
        z = true,             -- bindings for folds, spelling and others prefixed with z
        g = true              -- bindings for prefixed with g
      }
    },
    icons = { mappings = false },
  })

  local opts = { nowait = false, remap = false }
  local add = {
    { "<leader>g", group = "Git",                             unpack(opts) },
    { "<leader>G", group = "Git",                             unpack(opts) },
    { "<leader>y", group = "Git (yadm)",                      unpack(opts) },
    { "<leader>l", group = "Lsp",                             unpack(opts) },
    { "<leader>L", group = "Lsp",                             unpack(opts) },
    { "<leader>d", group = "Dap",                             unpack(opts) },
    { "<leader>e", group = "Nvim-tree",                       unpack(opts) },
    { "<leader>f", group = "Fzf",                             unpack(opts) },
    { "<leader>F", group = "Telescope",                       unpack(opts) },
    { "<leader>h", group = "Gitsigns",                        unpack(opts) },
    { "<leader>t", group = "Plenary testing",                 unpack(opts) },
    { "<C-\\>",    desc = "Launch scratch terminal",          unpack(opts) },
    { "<A-h>",     desc = "Tmux-aware win left",              unpack(opts) },
    { "<A-l>",     desc = "Tmux-aware win right",             unpack(opts) },
    { "<A-j>",     desc = "Tmux-aware win down",              unpack(opts) },
    { "<A-k>",     desc = "Tmux-aware win up",                unpack(opts) },
    { "<A-o>",     desc = "Tmux-aware win last",              unpack(opts) },
    { "<CR>",      desc = "Treesitter incremental selection", unpack(opts) },
    { "<C-l>",     desc = "Clear and redraw screen",          unpack(opts) },
    { "<C-r>",     desc = "Redo",                             unpack(opts) },
    { "u",         desc = "Undo",                             unpack(opts) },
    { "U",         desc = "Undo line",                        unpack(opts) },
    { ".",         desc = "Repeat last edit",                 unpack(opts) },
    { "%",         desc = "Cycle through matchit group",      unpack(opts) },
    { "[[",        desc = "Previous class/object end",        unpack(opts) },
    { "[]",        desc = "Previous class/object start",      unpack(opts) },
    { "][",        desc = "Next class/object end",            unpack(opts) },
    { "]]",        desc = "Next class/object start",          unpack(opts) },
    { "g$",        desc = "goto visual line end",             unpack(opts) },
    { "g%",        desc = "goto previous matching group",     unpack(opts) },
    { "g0",        desc = "goto visual line start",           unpack(opts) },
    { "g8",        desc = "print hex value under cursor",     unpack(opts) },
    { "g<",        desc = "display last !command output",     unpack(opts) },
    { "g<C-G>",    desc = "print current curosr pos info",    unpack(opts) },
    { "gE",        desc = "previous end of WORD",             unpack(opts) },
    { "gF",        desc = "goto file:line under cursor",      unpack(opts) },
    { "gM",        desc = "goto middle of text line",         unpack(opts) },
    { "gT",        desc = "goto prev tab",                    unpack(opts) },
    { "g_",        desc = "goto last non-EOL char",           unpack(opts) },
    { "ga",        desc = "print ascii value under cursor",   unpack(opts) },
    { "gt",        desc = "goto next tab",                    unpack(opts) },
  }
  wk.add(add)
end

return M
