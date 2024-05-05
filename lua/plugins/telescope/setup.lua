local utils = require("utils")

return {
  setup = function()
    local actions = require "telescope.actions"

    local insert_actions = {
      ["<C-s>"] = actions.select_horizontal,
      ["<C-v>"] = actions.select_vertical,
      ["<C-t>"] = actions.select_tab,
      ["<C-j>"] = actions.move_selection_next,
      ["<C-k>"] = actions.move_selection_previous,
      ["<C-n>"] = actions.cycle_history_next,
      ["<C-p>"] = actions.cycle_history_prev,
      ["<S-up>"] = actions.preview_scrolling_up,
      ["<S-down>"] = actions.preview_scrolling_down,
      ["<S-left>"] = actions.preview_scrolling_left,
      ["<S-right>"] = actions.preview_scrolling_right,
      ["<C-u>"] = false,
      ["<C-d>"] = actions.results_scrolling_down,
      ["<C-b>"] = actions.results_scrolling_up,
      ["<C-f>"] = actions.results_scrolling_down,
      ["<C-h>"] = actions.results_scrolling_left,
      ["<C-l>"] = actions.results_scrolling_right,
      ["<C-g>"] = actions.to_fuzzy_refine,
      ["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
      ["<C-q>"] = actions.send_selected_to_loclist + actions.open_loclist,
      ["<M-a>"] = actions.toggle_all,
      ["<C-\\>"] = {
        function()
          -- exit to normal mode
          vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(
            "<Esc>", true, false, true), "n", true)
        end,
        type = "command"
      },
      ["<C-c>"] = actions.close,
      ["<C-z>"] = actions.close,
      ["<Esc>"] = actions.close,
      ["<F1>"] = actions.which_key,
      ["<F4>"] = require("telescope.actions.layout").toggle_preview,
      ["<F5>"] = require("telescope.actions.layout").cycle_layout_prev,
      ["<F6>"] = require("telescope.actions.layout").cycle_layout_next,
    }

    local normal_actions = vim.tbl_extend("force", insert_actions, {
      ["<CR>"] = actions.select_default + actions.center,
    })

    require("telescope").setup {
      defaults = {
        prompt_prefix = "❯ ",
        selection_caret = "❯ ",
        selection_strategy = "reset",
        sorting_strategy = "ascending",
        scroll_strategy = "limit",
        layout_strategy = "flex",
        results_title = false,
        dynamic_preview_title = true,
        -- path_display = { truncate = 0 },
        -- https://github.com/nvim-telescope/telescope.nvim/pull/3010
        path_display = { filename_first = { reverse_directories = false } },
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
        mappings = { i = insert_actions, n = normal_actions },
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
        fzy_native = {
          override_generic_sorter = false,
          override_file_sorter = true,
        }
      },
    }

    -- verify a successfull build
    if not pcall(require("telescope").load_extension,
          utils.IS_WINDOWS and "fzy_native" or "fzf") then
      require("utils").warn(
        string.format("Unable to build telescope-fz%s-native, is `cmake` inatalled?",
          utils.IS_WINDOWS and "y" or "f")
      )
    end
  end
}
