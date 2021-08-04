local reload = require('nvim-reload')

-- If you use Neovim's built-in plugin system
-- Or a plugin manager that uses it (eg: packer.nvim)
local nvim_reload_dir = vim.fn.stdpath('data') .. '/site/pack/*/opt/nvim-reload'
local plugin_dirs_autoload = vim.fn.stdpath('data') .. '/site/pack/*/start/*'
local plugin_dirs_lazyload = {
  vim.fn.stdpath('data') .. '/site/pack/*/opt/fzf-lua',
  vim.fn.stdpath('data') .. '/site/pack/*/opt/nvim-fzf',
}

reload.vim_reload_dirs = {
    vim.fn.stdpath('config'),
    plugin_dirs_autoload,
}

reload.lua_reload_dirs = {
    vim.fn.stdpath('config'),
    nvim_reload_dir,
    plugin_dirs_autoload,
}

for _, k in ipairs(plugin_dirs_lazyload) do
    table.insert(reload.lua_reload_dirs, k)
end

reload.modules_reload_external = { 'packer' }

reload.lsp_was_loaded = nil
reload.pre_reload_hook = function()
  reload.lsp_was_loaded = pcall(require, "lspconfig")
end

reload.post_reload_hook = function()
  vim.cmd[[nohl]]
  -- recompile packer
  vim.cmd[[packadd packer.nvim]]
  require('plugins').compile()
  if pcall(require, 'feline') then
    require('feline').reset_highlights()
  end
  if reload.lsp_was_loaded and vim.fn.exists(':PackerLoad') ~= 0 then
    vim.cmd("PackerLoad nvim-lspconfig")
    vim.cmd("PackerLoad lsp_signature.nvim")
    vim.cmd("PackerLoad nvim-lspinstall")
  end
end
