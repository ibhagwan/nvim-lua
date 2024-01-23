local M = {}

local actions = require "telescope.actions"

function M.buffers()
  require("telescope.builtin").buffers {
    sort_mru = true,
    ignore_current_buffer = false,
    attach_mappings = function(_, map)
      map("i", "<c-x>", actions.delete_buffer)
      map("n", "<c-x>", actions.delete_buffer)
      return true
    end,
  }
end

function M.find_files(opts)
  opts = opts or {}
  opts = vim.tbl_deep_extend("force", {
    find_command = vim.fn.executable("fd") == 1
        and {
          "fd",
          "--type=f",
          "--hidden",
          "--follow",
          "--no-ignore",
          "--exclude=.git",
          "--strip-cwd-prefix"
        }
        or vim.fn.executable("rg") == 1 and { "rg", "--files" }
        or error("Telescope requires fd|rg installed."),
    file_ignore_patterns = {
      "node_modules",
      ".pyc"
    },
  }, opts)
  require("telescope.builtin").find_files(opts)
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
    search = require("utils").get_visual_selection()
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
      map("i", "<c-x>", actions.git_delete_branch)
      map("n", "<c-x>", actions.git_delete_branch)
      return true
    end
  })
end

function M.workdirs(opts)
  opts = opts or {}
  -- workdirs.lua returns a table of workdirs
  local ok, dirs = pcall(function() return require("workdirs").get() end)
  if not ok then dirs = {} end

  local pickers = require("telescope.pickers")
  local finders = require("telescope.finders")
  local action_state = require("telescope.actions.state")
  local conf = require("telescope.config").values

  pickers.new(opts, {
    prompt_title = "Workdirs",
    finder = finders.new_table {
      results = dirs,
    },
    sorter = conf.generic_sorter(opts),
    attach_mappings = function(prompt_bufnr)
      actions.select_default:replace(function()
        local selection = action_state.get_selected_entry()
        if selection == nil then
          print "[telescope] Nothing currently selected"
          return
        end

        actions.close(prompt_bufnr)
        require("workdirs").PREV_CWD = vim.loop.cwd()
        local newcwd = vim.fs.normalize(selection[1]:match("[^ ]*$"))
        require("utils").set_cwd(newcwd)
      end)
      return true
    end,
  })
      :find()
end

return M
