local M = {
  "nvim-tree/nvim-tree.lua",
  cmd = { "NvimTreeToggle", "NvimTreeFindFileToggle" },
}

M.init = function()
  vim.keymap.set("", "<leader>ee", "<Esc>:NvimTreeToggle<CR>", { silent = true })
  vim.keymap.set("", "<leader>ef", "<Esc>:NvimTreeFindFileToggle<CR>", { silent = true })
end

M.config = function()
  require "nvim-tree".setup {
    disable_netrw = true,
    hijack_cursor = true,
    hijack_netrw = false,
    update_cwd = true,
    view = {
      width = 30,
      side = "left",
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
        symlink_arrow = " → ", -- ➜ → ➛
        show = {
          file = true,
          folder = true,
          folder_arrow = true,
          git = false,
        },
        glyphs = {
          git = {
            -- staged      = "✓",
            -- renamed     = "➜",
            -- renamed     = "→",
            unstaged  = "M",
            staged    = "S",
            unmerged  = "U",
            renamed   = "R",
            untracked = "?",
            deleted   = "✗",
            ignored   = "◌",
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
        "go.mod",
        "go.sum",
      }
    },
    diagnostics = {
      enable = true,
      show_on_dirs = true,
      icons = {
        hint = "󰌵",
        info = "",
        warning = "",
        error = "",
      },
    },
    filters = {
      enable = true,
      dotfiles = false,
      custom = {
        "^\\.git$",
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
    -- https://github.com/nvim-tree/nvim-tree.lua/wiki/Migrating-To-on_attach
    on_attach = function(bufnr)
      local api = require("nvim-tree.api")

      local function opts(desc)
        return {
          desc = "nvim-tree: " .. desc,
          buffer = bufnr,
          noremap = true,
          silent = true,
          nowait = true
        }
      end

      api.config.mappings.default_on_attach(bufnr)

      vim.keymap.set("n", "<C-s>", api.node.open.horizontal, opts("Open: Horizontal Split"))
    end,
  }
end

return M
