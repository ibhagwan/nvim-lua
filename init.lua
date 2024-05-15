local utils = require("utils")

if not utils.__HAS_NVIM_08 then
  utils.warn("nvim-lua requires neovim > 0.8")
  vim.o.lpl = true
  vim.o.termguicolors = true
  pcall(vim.cmd, [[colorscheme lua-embark]])
  return
end

require("options")
require("autocmd")
require("keymaps")

-- Don't load plugins as root and use a different colorscheme
-- NOTE: embark colorscheme set transparent background for root in "options.lua"
if not utils.is_root() then
  require("lazyplug")
  vim.cmd.colorscheme("nightfly")
  -- vim.cmd.colorscheme("lua-embark")
else
  vim.cmd.colorscheme("lua-embark")
end
