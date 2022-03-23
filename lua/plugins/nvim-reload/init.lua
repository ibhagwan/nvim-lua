local reload = require('nvim-reload')

-- If you use Neovim's built-in plugin system
-- Or a plugin manager that uses it (eg: packer.nvim)
local nvim_reload_dir = vim.fn.stdpath('data') .. '/site/pack/*/opt/nvim-reload'
local plugin_dirs_autoload = vim.fn.stdpath('data') .. '/site/pack/*/start/*'
local plugin_dirs_lazyload = {
  vim.fn.stdpath('data') .. '/site/pack/*/opt/fzf-lua',
  vim.fn.stdpath('data') .. '/site/pack/*/opt/nvim-fzf',
  vim.fn.stdpath('data') .. '/site/pack/*/opt/lualine.nvim',
  vim.fn.stdpath('data') .. '/site/pack/*/opt/telescope.nvim',
  vim.fn.stdpath('data') .. '/site/pack/*/opt/which-key.nvim',
  vim.fn.stdpath('data') .. '/site/pack/*/opt/babelfish.nvim',
  vim.fn.stdpath('data') .. '/site/pack/*/opt/toggleterm.nvim',
  vim.fn.stdpath('data') .. '/site/pack/*/opt/indent-blankline.nvim',
  vim.fn.stdpath('data') .. '/site/pack/*/opt/nvim-dap',
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
  if reload.lsp_was_loaded and vim.fn.exists(':PackerLoad') ~= 0 then
    vim.cmd("PackerLoad nvim-lspconfig")
    vim.cmd("PackerLoad nvim-lsp-installer")
  end
  -- re-source all language specific settings, scans all runtime files under
  -- '/usr/share/nvim/runtime/(indent|syntax)' and 'after/ftplugin'
  local ft = vim.bo.filetype
  vim.tbl_filter(function(s)
    for _, e in ipairs({ "vim", "lua" }) do
      if ft and #ft>0 and s:match(("/%s.%s"):format(ft, e)) then
        local file = vim.fn.expand(s:match("[^: ]*$"))
        vim.cmd("source " .. file)
        return s
      end
    end
    return nil
  end, vim.fn.split(vim.fn.execute("scriptnames"), "\n"))
end
