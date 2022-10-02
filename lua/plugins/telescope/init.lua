if not pcall(require, "telescope") then
  return
end

local actions = require "telescope.actions"
local themes = require "telescope.themes"

require("telescope").setup {
  defaults = {
    prompt_prefix = "❯ ",
    selection_caret = "❯ ",
    selection_strategy = "reset",
    sorting_strategy = "ascending",
    scroll_strategy = "cycle",
    color_devicons = true,
    winblend = 0,

    borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },

    layout_strategy = "flex",
    layout_config = {
      width = 0.95,
      height = 0.85,
      prompt_position = "top",

      horizontal = {
        -- width_padding = 0.1,
        -- height_padding = 0.1,
        width = 0.9,
        preview_cutoff = 60,
        preview_width = function(_, cols, _)
          if cols > 200 then
            return math.floor(cols * 0.7)
          else
            return math.floor(cols * 0.6)
          end
        end,
      },
      vertical = {
        -- width_padding = 0.05,
        -- height_padding = 1,
        width = 0.75,
        height = 0.85,
        preview_height = 0.4,
        mirror = true,
      },
      flex = {
        -- change to horizontal after 120 cols
        flip_columns = 120,
      },
    },

    mappings = {
      i = {
        ["<C-s>"] = actions.select_horizontal,
        ["<C-v>"] = actions.select_vertical,
        ["<C-t>"] = actions.select_tab,

        ["<C-j>"] = actions.move_selection_next,
        ["<C-k>"] = actions.move_selection_previous,
        ["<S-up>"] = actions.preview_scrolling_up,
        ["<S-down>"] = actions.preview_scrolling_down,

        ["<C-b>"] = actions.results_scrolling_down,
        ["<C-f>"] = actions.results_scrolling_up,

        ["<C-g>"] = actions.to_fuzzy_refine,

        ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
        ["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
        ["<M-a>"] = actions.toggle_all,

        ["<C-c>"] = actions.close,

        ["<F4>"]  = require("telescope.actions.layout").toggle_preview,
      },
      n = {
        ["<CR>"] = actions.select_default + actions.center,
        ["<C-s>"] = actions.select_horizontal,
        ["<C-v>"] = actions.select_vertical,
        ["<C-t>"] = actions.select_tab,

        ["<S-up>"] = actions.preview_scrolling_up,
        ["<S-down>"] = actions.preview_scrolling_down,

        ["<C-b>"] = actions.results_scrolling_down,
        ["<C-f>"] = actions.results_scrolling_up,

        ["<C-g>"] = actions.to_fuzzy_refine,

        ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
        ["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
        ["<M-a>"] = actions.toggle_all,

        ["<C-c>"] = actions.close,
        ["<Esc>"] = false,

        ["<F4>"]  = require("telescope.actions.layout").toggle_preview,
      },
    },


    file_previewer = require("telescope.previewers").vim_buffer_cat.new,
    grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
    qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,

    vimgrep_arguments = {
        "rg",
        "--column",
        "--line-number",
        "--with-filename",
        "--no-heading",
        "--smart-case",
        -- "--hidden",
    },
  },

  extensions = {
    fzy_native = {
      override_file_sorter = true,
      override_generic_sorter = true,
    },

    fzf_writer = {
      use_highlighter = false,
      minimum_grep_characters = 6,
    },
  },
}

require('telescope').load_extension('fzy_native')

local M = {}

function M.buffers()
  require("telescope.builtin").buffers {
    attach_mappings = function(_, map)
        map('i', '<c-x>', actions.delete_buffer)
        map('n', '<c-x>', actions.delete_buffer)
      return true
    end,
  }
end

function M.find_files(opts)
  opts = opts or {}
  opts = vim.tbl_deep_extend("force", {
    find_command = {
      "fd",
      "--type=f",
      "--hidden",
      "--follow",
      "--no-ignore",
      "--exclude=.git",
      "--strip-cwd-prefix"
    },
    file_ignore_patterns = {
      "node_modules",
      ".pyc"
    },
  }, opts)
  require("telescope.builtin").fd(opts)
end

function M.installed_plugins()
  M.find_files {
    cwd = vim.fn.stdpath "data" .. "/site/pack/packer/",
  }
end

function M.grep_prompt()
  require("telescope.builtin").grep_string {
    path_display = { "absolute" },
    search = vim.fn.input "Grep String ❯ ",
  }
end

function M.grep_visual()
  require("telescope.builtin").grep_string {
    path_display = { "absolute" },
    search = require('utils').get_visual_selection()
  }
end

function M.grep_cword()
  require("telescope.builtin").grep_string {
    path_display = { "absolute" },
    word_match = "-w",
    search = vim.fn.expand("<cword>"),
  }
end

function M.grep_cWORD()
  require("telescope.builtin").grep_string {
    path_display = { "absolute" },
    search = vim.fn.expand("<cWORD>"),
  }
end

M.git_branches = function()
    require("telescope.builtin").git_branches({
        attach_mappings = function(_, map)
            map('i', '<c-x>', actions.git_delete_branch)
            map('n', '<c-x>', actions.git_delete_branch)
            return true
        end
    })
end

return setmetatable({}, {
  __index = function(_, k)
    -- reloader()

    if M[k] then
      return M[k]
    else
      return require("telescope.builtin")[k]
    end
  end,
})
