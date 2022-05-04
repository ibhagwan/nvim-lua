local remap = vim.api.nvim_set_keymap

remap('', '<leader>ee', "<Esc>:NvimTreeToggle<CR>",         { silent = true })
remap('', '<leader>ef', "<Esc>:NvimTreeFindFileToggle<CR>", { silent = true })

-- files that get highlighted with 'NvimTreeSpecialFile'
vim.g.nvim_tree_special_files = {
  ["README.md"]           = true,
  ["LICENSE"]             = true,
  ["Makefile"]            = true,
  ["package.json"]        = true,
  ["package-lock.json"]   = true,
}

vim.g.nvim_tree_show_icons = {
  git = 1,
  folders = 1,
  files = 1,
  folder_arrows = 1,
}

vim.g.nvim_tree_icons = {
  default = "",
  symlink = "",
  git = {
    -- staged      = "✓",
    -- renamed     = "➜",
    unstaged    = "★",
    staged      = "+",
    unmerged    = "",
    renamed     = "→",
    untracked   = "?",
    deleted     = "✗",
    ignored     = "◌",
  },
  folder = {
    arrow_open      = "",
    arrow_closed    = "",
    default         = "",
    open            = "",
    empty           = "",
    empty_open      = "",
    symlink         = "",
    symlink_open    = "",
  },
}

require'nvim-tree'.setup {
  open_on_setup       = false,
  open_on_tab         = false,
  disable_netrw       = true,
  hijack_netrw        = false,
  hijack_cursor       = false,
  update_cwd          = true,
  update_focused_file = {
    enable      = false,
    update_cwd  = false,
    ignore_list = {}
  },
  diagnostics = {
    enable = true,
    show_on_dirs = true,
    icons = {
      hint = "H",
      info = "I",
      warning = "W",
      error = "E",
    }
  },
  view = {
    width = 30,
    side = 'left',
    mappings = {
      custom_only = false,
      list = {
        { key = "<C-x>", action = nil },
        { key = "<C-s>", action = "split" },
      }
    }
  },
  actions = {
    open_file = {
      quit_on_open = true,
    }
  },
  filters = {
    dotfiles = false,
    custom = {
      "\\.git",
      ".cache",
      "node_modules",
      "__pycache__",
    }
  },
}
