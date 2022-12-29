local M = {}

local actions = require "telescope.actions"

function M.buffers()
  require("telescope.builtin").buffers {
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
    cwd = vim.fn.stdpath "data" .. "/lazy",
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

return M
