local utils = require("utils")

if not utils.has_neovim_v08() then
  utils.warn("nvim-lua requires neovim > 0.8")
  vim.o.lpl = true
  vim.o.termguicolors = true
  pcall(vim.cmd, [[colorscheme lua-embark]])
  return
end

require("options")
require("autocmd")
require("keymaps")

-- we don't use plugins as root
if not utils.is_root() then
  require("lazyplug")
end

-- set colorscheme to modified embark
-- https://github.com/embark-theme/vim
-- vim.g.embark_transparent = true
-- vim.g.embark_terminal_italics = true
vim.g.lua_embark_transparent = true
if utils.is_root() then
  pcall(vim.cmd, [[colorscheme lua-embark]])
else
  pcall(vim.cmd, [[colorscheme nightfly]])
end

-- set 'listchars' highlight
if vim.g.colors_name == "nightfly" then
  vim.cmd("hi! link Whitespace NonText")
end
