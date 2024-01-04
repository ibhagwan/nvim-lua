local utils = require("utils")

M = {}

M.DIRS = {
  -- cwd is always added so we can go back
  utils._if_win_fs_norm(vim.loop.cwd()),
  -- runtime path
  utils._if_win_fs_norm(vim.opt.runtimepath._info.default:match(
    utils._if_win([[%u:\]], "/") .. "[^,]+runtime")),
  -- Lazy plugins
  utils._if_win_fs_norm(vim.fn.stdpath("data") .. "/lazy"),
  utils._if_win_fs_norm(vim.fn.stdpath("config")),
  utils._if_win_fs_norm("~/.config/zsh"),
  utils._if_win_fs_norm("~/.config/awesome"),
  utils._if_win_fs_norm("~/dots"),
  utils._if_win_fs_norm("~/Sources/nvim/demo"),
  utils._if_win_fs_norm("~/Sources/nvim/test-go"),
  utils._if_win_fs_norm("~/Sources/nvim/neovim"),
  utils._if_win_fs_norm("~/Sources/nvim/fzf-lua"),
  utils._if_win_fs_norm("~/Sources/nvim/fzf-lua.wiki"),
  utils._if_win_fs_norm("~/Sources/nvim/fzf.vim"),
  utils._if_win_fs_norm("~/Sources/nvim/nvim-lua"),
  utils._if_win_fs_norm("~/Sources/nvim/nvim-fzf"),
  utils._if_win_fs_norm("~/Sources/nvim/nvim-dap"),
  utils._if_win_fs_norm("~/Sources/nvim/ts-vimdoc.nvim"),
  utils._if_win_fs_norm("~/Sources/nvim/smartyank.nvim"),
  utils._if_win_fs_norm("~/Sources/nvim/vim-cheatsheet"),
  utils._if_win_fs_norm("~/Sources/nvim/plenary.nvim"),
  utils._if_win_fs_norm("~/Sources/nvim/telescope.nvim"),
  utils._if_win_fs_norm("~/Sources/reveal.js"),
}

M.PREV_CWD = nil

M.get = function(noicons)
  local iconify = function(path, icon)
    return string.format("%s  %s", icon, path)
  end

  local dirs = {}
  local dedup = {}

  local add_entry = function(path, icon)
    if not path then return end
    local expanded = vim.fn.expand(path)
    if not vim.loop.fs_stat(expanded) then return end
    if dedup[expanded] ~= nil then return end
    path = vim.fn.fnamemodify(expanded, ":~")
    table.insert(dirs, noicons and path or iconify(path, icon or ""))
    dedup[expanded] = true
  end

  add_entry(vim.loop.cwd(), "")
  add_entry(M.PREV_CWD)

  for _, path in ipairs(M.DIRS) do
    add_entry(path)
  end

  return dirs
end

return M
