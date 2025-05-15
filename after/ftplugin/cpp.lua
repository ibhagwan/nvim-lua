vim.bo.tabstop = 4
vim.cmd [[setlocal path+=/usr/include/**,/usr/local/include/**]]
-- remove {o|O} newline auto-comments
vim.opt_local.formatoptions:remove("o")
