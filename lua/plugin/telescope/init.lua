if not pcall(require, "telescope") then
  return
end

local actions = require "telescope.actions"
-- local action_mt = require "telescope.actions.mt"
-- local action_set = require "telescope.actions.set"
local action_state = require "telescope.actions.state"
local sorters = require "telescope.sorters"
local themes = require "telescope.themes"


local set_prompt_to_entry_value = function(prompt_bufnr)
  local entry = action_state.get_selected_entry()
  if not entry or not type(entry) == "table" then
    return
  end

  action_state.get_current_picker(prompt_bufnr):reset_prompt(entry.ordinal)
end

require("telescope").setup {
  defaults = {
    prompt_prefix = "❯ ",
    selection_caret = "❯ ",
    selection_strategy = "reset",
    sorting_strategy = "ascending",
    scroll_strategy = "cycle",
    color_devicons = true,
    winblend = 0,

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
        ["<C-x>"] = actions.delete_buffer,
        ["<C-s>"] = actions.select_horizontal,
        ["<C-v>"] = actions.select_vertical,
        ["<C-t>"] = actions.select_tab,

        ["<C-j>"] = actions.move_selection_next,
        ["<C-k>"] = actions.move_selection_previous,
        ["<S-up>"] = actions.preview_scrolling_up,
        ["<S-down>"] = actions.preview_scrolling_down,
        ["<C-up>"] = actions.preview_scrolling_up,
        ["<C-down>"] = actions.preview_scrolling_down,

        -- TODO: look into using 'actions.set.shift_selection'
        ["<C-u>"] = actions.move_to_top,
        ["<C-d>"] = actions.move_to_middle,
        ["<C-b>"] = actions.move_to_top,
        ["<C-f>"] = actions.move_to_bottom,

        ["<M-q>"] = actions.send_to_qflist + actions.open_qflist,
        ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
        ["<C-y>"] = set_prompt_to_entry_value,

        ["<C-c>"] = actions.close,
        -- ["<M-m>"] = actions.master_stack,
        -- Experimental
        -- ["<tab>"] = actions.toggle_selection,
      },
      n = {
        ["<CR>"] = actions.select_default + actions.center,
        ["<C-x>"] = actions.delete_buffer,
        ["<C-s>"] = actions.select_horizontal,
        ["<C-v>"] = actions.select_vertical,
        ["<C-t>"] = actions.select_tab,

        ["j"] = actions.move_selection_next,
        ["k"] = actions.move_selection_previous,
        ["<S-up>"] = actions.preview_scrolling_up,
        ["<S-down>"] = actions.preview_scrolling_down,
        ["<C-up>"] = actions.preview_scrolling_up,
        ["<C-down>"] = actions.preview_scrolling_down,

        ["<C-u>"] = actions.move_to_top,
        ["<C-d>"] = actions.move_to_middle,
        ["<C-b>"] = actions.move_to_top,
        ["<C-f>"] = actions.move_to_bottom,

        ["<C-q>"] = actions.send_to_qflist,
        ["<M-q>"] = actions.send_to_qflist + actions.open_qflist,

        ["<C-c>"] = actions.close,
        ["<Esc>"] = false,
        -- ["<Tab>"] = actions.toggle_selection,
      },
    },

    borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },

    file_sorter = sorters.get_fzy_sorter,
    -- we ignore individually in M.find_files()
    -- file_ignore_patterns = {"node_modules", ".pyc"},

    file_previewer = require("telescope.previewers").vim_buffer_cat.new,
    grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
    qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,

    vimgrep_arguments = {
        "rg",
        "--hidden",
        "--no-heading",
        "--with-filename",
        "--line-number",
        "--column",
        "--smart-case"
    },
  },

  extensions = {
    fzy_native = {
      override_generic_sorter = true,
      override_file_sorter = true,
    },

    fzf_writer = {
      use_highlighter = false,
      minimum_grep_characters = 6,
    },

    frecency = {
      workspaces = {
        ["conf"] = "~/.config/nvim/",
      },
    },
  },
}

require('telescope').load_extension('fzy_native')

local M = {}

--[[
lua require('plenary.reload').reload_module("plugin.telescope")
nnoremap <leader>en <cmd>lua require('plugin.telescope').edit_neovim()<CR>
--]]
function M.edit_neovim()
  require("telescope.builtin").find_files {
    prompt_title = "< VimRC >",
    path_display = { "absolute" },
    -- path_display = { "shorten", "absolute" },
    cwd = "~/.config/nvim",

    layout_strategy = "vertical",
    layout_config = {
      width = 0.9,
      height = 0.8,

      horizontal = {
        width = { padding = 0.15 },
      },
      vertical = {
        preview_height = 0.45,
      },
    },

    attach_mappings = function(_, map)
      map("i", "<c-y>", set_prompt_to_entry_value)
      return true
    end,
  }
end

function M.edit_dotfiles()
  require("telescope.builtin").find_files {
    prompt_title = "~ dotfiles ~",
    path_display = { "absolute" },
    cwd = "~/dots",

    attach_mappings = function(_, map)
      map("i", "<c-y>", set_prompt_to_entry_value)
      return true
    end,
  }
end

function M.edit_zsh()
  require("telescope.builtin").find_files {
    path_display = { "absolute" },
    cwd = "~/.config/zsh/",
    prompt = "~ zsh ~",
    hidden = true,

    layout_strategy = "vertical",
    layout_config = {
      horizontal = {
        width = { padding = 0.15 },
      },
      vertical = {
        preview_height = 0.75,
      },
    },
  }
end

M.git_branches = function()
    require("telescope.builtin").git_branches({
        attach_mappings = function(_, map)
            map('i', '<c-x>', actions.git_delete_branch)
            map('n', '<c-x>', actions.git_delete_branch)
            map("i", "<c-y>", set_prompt_to_entry_value)
            return true
        end
    })
end

function M.lsp_code_actions()
  local opts = themes.get_dropdown {
    winblend = 10,
    border = true,
    previewer = false,
    path_display = { "absolute" },
  }

  require("telescope.builtin").lsp_code_actions(opts)
end

function M.fd()
  require("telescope.builtin").fd()
end

function M.builtin()
  require("telescope.builtin").builtin()
end

--[[
function M.live_grep()
  require("telescope").extensions.fzf_writer.staged_grep {
    path_display = { "absolute" },
    previewer = false,
    fzf_separator = "|>",
  }
end
--]]

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
    only_sort_text = true,
    layout_strategy = "vertical",
    sorter = sorters.get_fzy_sorter(),
    -- search = vim.fn.expand("<cword>"),
  }
end

function M.grep_cWORD()
  require("telescope.builtin").grep_string {
    path_display = { "absolute" },
    search = vim.fn.expand("<cWORD>"),
  }
end

function M.grep_last_search(opts)
  opts = opts or {}

  -- \<getreg\>\C
  -- -> Subs out the search things
  local register = vim.fn.getreg("/"):gsub("\\<", ""):gsub("\\>", ""):gsub("\\C", "")

  opts.path_display = { "absolute" }
  opts.word_match = "-w"
  opts.search = register

  require("telescope.builtin").grep_string(opts)
end

function M.my_plugins()
  require("telescope.builtin").find_files {
    cwd = "~/plugins/",
  }
end

function M.installed_plugins()
  require("telescope.builtin").find_files {
    cwd = vim.fn.stdpath "data" .. "/site/pack/packer/",
  }
end

function M.project_search()
  require("telescope.builtin").find_files {
    previewer = false,
    layout_strategy = "vertical",
    cwd = require("nvim_lsp.util").root_pattern ".git"(vim.fn.expand "%:p"),
  }
end

function M.curbuf()
  local opts = themes.get_dropdown {
    winblend = 10,
    border = true,
    previewer = false,
    path_display = { "absolute" },
  }
  require("telescope.builtin").current_buffer_fuzzy_find(opts)
end

function M.help_tags()
  require("telescope.builtin").help_tags {
    show_version = true,
  }
end

function M.find_files()
  require("telescope.builtin").fd {
    -- find_command = { "fd", "--hidden", "--follow", "--type f" },
    file_ignore_patterns = {"node_modules", ".pyc"},
  }
end

function M.search_all_files()
  require("telescope.builtin").find_files {
    find_command = { "rg", "--no-ignore", "--files" },
  }
end

function M.file_browser()
  local opts

  opts = {
    sorting_strategy = "ascending",
    scroll_strategy = "cycle",
    layout_config = {
      prompt_position = "top",
    },

    attach_mappings = function(prompt_bufnr, map)
      local current_picker = action_state.get_current_picker(prompt_bufnr)

      local modify_cwd = function(new_cwd)
        current_picker.cwd = new_cwd
        current_picker:refresh(opts.new_finder(new_cwd), { reset_prompt = true })
      end

      map("i", "-", function()
        modify_cwd(current_picker.cwd .. "/..")
      end)

      map("i", "~", function()
        modify_cwd(vim.fn.expand "~")
      end)

      local modify_depth = function(mod)
        return function()
          opts.depth = opts.depth + mod

          local current_picker = action_state.get_current_picker(prompt_bufnr)
          current_picker:refresh(opts.new_finder(current_picker.cwd), { reset_prompt = true })
        end
      end

      map("i", "<M-=>", modify_depth(1))
      map("i", "<M-+>", modify_depth(-1))

      map("n", "yy", function()
        local entry = action_state.get_selected_entry()
        vim.fn.setreg("+", entry.value)
      end)

      return true
    end,
  }

  require("telescope.builtin").file_browser(opts)
end

--[[ function M.git_status()
  local opts = themes.get_dropdown {
    winblend = 10,
    border = true,
    previewer = false,
    path_display = { "absolute" },
  }

  -- Can change the git icons using this.
  opts.git_icons = {
    changed = "M"
  }

  require("telescope.builtin").git_status(opts)
end ]]

function M.git_commits()
  require("telescope.builtin").git_commits {
    winblend = 5,
  }
end

function M.search_only_certain_files()
  require("telescope.builtin").find_files {
    find_command = {
      "rg",
      "--files",
      "--type",
      vim.fn.input "Type: ",
    },
  }
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
