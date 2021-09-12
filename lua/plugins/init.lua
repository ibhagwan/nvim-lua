-- Do not use plugins when running as root or neovim < 0.5
if require'utils'.is_root() or not require'utils'.has_neovim_v05() then
  return
end

local ok, packer = pcall(require, 'plugins.packer_init')
if not ok then return end

-- Packer commands
vim.cmd [[command! PackerInstall packadd packer.nvim | lua require('plugins').install()]]
vim.cmd [[command! PackerUpdate packadd packer.nvim | lua require('plugins').update()]]
vim.cmd [[command! PackerSync packadd packer.nvim | lua require('plugins').sync()]]
vim.cmd [[command! PackerClean packadd packer.nvim | lua require('plugins').clean()]]
vim.cmd [[command! PackerCompile packadd packer.nvim | lua require('plugins').compile()]]
vim.cmd [[command! PC PackerCompile]]
vim.cmd [[command! PS PackerStatus]]
vim.cmd [[command! PU PackerSync]]

if vim.loop.fs_stat(packer.config.compile_path) then
  -- since we customized the compilation path for packer
  -- we need to manually load 'packer_compiled.lua'
  vim.cmd("luafile " .. packer.config.compile_path)
else
  -- no 'packer_compiled.lua', we assume this is the
  -- first time install, 'sync()' will clone|update
  -- our plugins and generate 'packer_compiled.lua'
  packer.sync()
end

local plugins = setmetatable({}, {
  __index = function(_, key)
    return packer[key]
  end
})

return plugins
