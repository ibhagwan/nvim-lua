return {
  setup = function()
    local actions = require "telescope.actions"

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
            ["<Esc>"] = actions.close,
            ["<F4>"] = require("telescope.actions.layout").toggle_preview,
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
            ["<Esc>"] = actions.close,
            ["<F4>"] = require("telescope.actions.layout").toggle_preview,
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
        fzf = {
          fuzzy = true,                   -- false will only do exact matching
          override_generic_sorter = true, -- override the generic sorter
          override_file_sorter = true,    -- override the file sorter
          case_mode = "smart_case",       -- or "ignore_case" or "respect_case"
        },
      },
    }

    require("telescope").load_extension("fzf")
  end
}
