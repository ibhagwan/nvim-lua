local remap = vim.api.nvim_set_keymap

remap('', '<leader>ee', "<Esc>:NvimTreeToggle<CR>",         { silent = true })
remap('', '<leader>ef', "<Esc>:NvimTreeFindFileToggle<CR>", { silent = true })

require'nvim-tree'.setup {
  disable_netrw = true,
  hijack_cursor = true,
  hijack_netrw = false,
  update_cwd = true,
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
  renderer = {
    indent_markers = {
      enable = true,
      icons = {
        corner = "└ ",
        edge = "│ ",
        none = "  ",
      },
    },
    icons = {
      symlink_arrow = " → ",  -- ➜ → ➛
      show = {
        file = true,
        folder = true,
        folder_arrow = true,
        git = true,
      },
      glyphs = {
        git = {
          -- staged      = "✓",
          -- renamed     = "➜",
          -- renamed     = "→",
          unstaged    = "M",
          staged      = "S",
          unmerged    = "U",
          renamed     = "R",
          untracked   = "?",
          deleted     = "✗",
          ignored     = "◌",
        },
      },
    },
    special_files = {
      "README.md",
      "LICENSE",
      "Cargo.toml",
      "Makefile",
      "package.json",
      "package-lock.json",
    }
  },
  diagnostics = {
    enable = true,
    show_on_dirs = false,
    icons = {
      hint = "", -- "",
      info = "",
      warning = "",
      error = "",
    },
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
  git = {
    enable = true,
    ignore = false,
    timeout = 400,
  },
  actions = {
    use_system_clipboard = false,
    change_dir = {
      enable = false,
      global = false,
      restrict_above_cwd = false,
    },
    open_file = {
      quit_on_open = true,
      resize_window = true,
    },
  },
}
