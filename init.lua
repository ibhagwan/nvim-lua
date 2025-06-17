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
