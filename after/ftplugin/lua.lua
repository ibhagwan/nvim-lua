vim.wo.spell       = false
vim.bo.shiftwidth  = 2
vim.bo.tabstop     = 2
vim.bo.softtabstop = 2
vim.bo.textwidth   = 120
-- remove {o|O} newline auto-comments
vim.opt_local.formatoptions:remove("o")
-- remove auto-indent after 'end|until'
-- set by '/usr/share/nvim/runtime/indent/lua.vim'
-- this gets overwritten, moved to autocmd
-- vim.cmd[[setlocal indentkeys-=0=end,0=until]]
