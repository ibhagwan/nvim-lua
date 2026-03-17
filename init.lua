local utils = require("utils")

if vim.fn.has("nvim-0.10") ~= 1 then
  utils.warn("This config requires neovim 0.10 and above")
  vim.o.loadplugins = false
  vim.o.termguicolors = true
  return
end

require("options")
require("autocmd")
require("keymaps")
require("term")

-- Don't load plugins as root and use a different colorscheme
if not utils.is_root() then
  require("lazy_nvim")
end

-- Neovim from source is run with "VIMRUNTIME=... .../bin/build/nvim"
-- we aren't using "VIMRUNTIME=.../build/runtime" as it's missing "lua" folder
-- instead we use the source folder directly but since it's missing "doc/tasg"
-- we can't use `:help`, this restores the help tags
if vim.v.progpath:match("Sources") then
  local rtp = vim.fs.joinpath(vim.fn.fnamemodify(vim.v.progpath, ":h:h"), "runtime")
  vim.opt.runtimepath:append(rtp)
  vim.env.FZF_LUA_NVIM_BIN=vim.v.progpath
  vim.env.FZF_LUA_NVIM_RUNTIME=assert(vim.env.VIMRUNTIME)
end
