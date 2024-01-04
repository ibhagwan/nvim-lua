local M = {
  "folke/which-key.nvim",
  -- "VeryLazy" hides splash screen
  -- lazy = false,
  event = "BufReadPost",
}

M.config = function()
  -- If we do not wish to wait for timeoutlen
  vim.keymap.set("v", "<Leader>?", "<Esc>:WhichKey '' v<CR>", { silent = true })
  vim.keymap.set("n", "<Leader>?", "<Esc>:WhichKey '' n<CR>",
    { silent = true, desc = "which-key root" })

  -- https://github.com/folke/which-key.nvim#colors
  vim.cmd([[highlight default link WhichKey          Label]])
  vim.cmd([[highlight default link WhichKeySeperator String]])
  vim.cmd([[highlight default link WhichKeyGroup     Include]])
  vim.cmd([[highlight default link WhichKeyDesc      Function]])
  vim.cmd([[highlight default link WhichKeyFloat     CursorLine]])
  vim.cmd([[highlight default link WhichKeyValue     Comment]])

  local wk = require("which-key")
  wk.setup {
    plugins = {
      marks = true,      -- shows a list of your marks on ' and `
      registers = false, -- shows your registers on " in NORMAL or <C-r> in INSERT mode
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
    -- add operators that will trigger motion and text object completion
    -- to enable all native operators, set the preset / operators plugin above
    operators = { gc = "Comments" },
    key_labels = {
      -- override the label used to display some keys. It doesn't effect WK in any other way.
      -- For example:
      ["<space>"] = "SPC",
      ["<cr>"] = "RET",
      ["<tab>"] = "TAB"
    },
    icons = {
      breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
      separator = "➜", -- symbol used between a key and it's label
      group = "+" -- symbol prepended to a group
    },
    window = {
      border = "none",         -- none, single, double, shadow
      position = "bottom",     -- bottom, top
      margin = { 1, 0, 1, 0 }, -- extra window margin [top, right, bottom, left]
      padding = { 1, 1, 1, 1 } -- extra window padding [top, right, bottom, left]
    },
    layout = {
      height = { min = 4, max = 25 }, -- min and max height of the columns
      width = { min = 20, max = 50 }, -- min and max width of the columns
      spacing = 5                     -- spacing between columns
    },
    -- hide mapping boilerplate
    hidden = { "<silent>", "<cmd>", "<Cmd>", "<CR>", "call", "lua", "^:", "^ " },
    show_help = true, -- show help message on the command line when the popup is visible
    triggers = "auto" -- automatically setup triggers
    -- triggers = {"<leader>"} -- or specifiy a list manually
  }

  local opts = {
    mode = "n",     -- NORMAL mode
    buffer = nil,   -- Global mappings. Specify a buffer number for buffer local mappings
    silent = true,  -- use `silent` when creating keymaps
    noremap = true, -- use `noremap` when creating keymaps
    nowait = false  -- use `nowait` when creating keymaps
  }

  local keymaps = {
    ["%"]        = "cycle through matchit group",
    ["<CR>"]     = "treesitter incremental selection",
    -- dup DAP descriptons due to plugin lazy load
    ["<F5>"]     = "DAP launch or continue",
    ["<F8>"]     = "DAP toggle UI",
    ["<F9>"]     = "DAP toggle breakpoint",
    ["<F10>"]    = "DAP step over",
    ["<F11>"]    = "DAP step into",
    ["<F12>"]    = "DAP step out",
    ["<C-\\>"]   = "Launch scratch terminal",
    ["<C-l>"]    = "Clear and redraw screen",
    ["<C-r>"]    = "Redo",
    ["u"]        = "Undo",
    ["U"]        = "Undo line",
    ["."]        = "Repeat last edit",
    ["["]        = {
      ["]"] = "Previous class/object start",
      ["["] = "Previous class/object end",
    },
    ["]"]        = {
      ["]"] = "Next class/object start",
      ["["] = "Next class/object end",
    },
    ["g"]        = {
      -- builtin commands
      ["%"] = "goto previous matching group",
      ["0"] = "goto visual line start",
      ["$"] = "goto visual line end",
      ["8"] = "print hex value under cursor",
      ["<lt>"] = "display last !command output",
      ["<C-G>"] = "print current curosr pos info",
      a = "print ascii value under cursor",
      _ = "goto last non-EOL char",
      t = "goto next tab",
      T = "goto prev tab",
      -- overridden by LSP keybinds
      -- m = { 'gm', 'goto middle of screen line' },
      M = "goto middle of text line",
      F = "goto file:line under cursor",
      E = "previous end of WORD",
    },
    ["<leader>"] = {
      g = { name = "+git", },
      G = { name = "+git", },
      f = { name = "+fzf", },
      l = { name = "+lsp", },
      L = { name = "+Lsp", },
      d = { name = "+dap" },
      y = { name = "+yadm", },
      h = { name = "+gitsigns", },
      t = {
        name = "+telescope",
        l = { name = "+lsp" }
      },
      e = {
        name = "+tree",
        e = { ":NvimTreeToggle<CR>", "nvim-tree on/off" },
        f = { ":NvimTreeFindFileToggle<CR>", "nvim-tree current file" },
      },
    },
  }

  wk.register(keymaps, opts)
end

return M
