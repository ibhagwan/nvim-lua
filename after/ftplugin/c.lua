vim.wo.spell         = false
vim.bo.shiftwidth    = 4
vim.bo.tabstop       = 4
vim.bo.softtabstop   = 4
vim.bo.commentstring = "// %s"
vim.cmd [[setlocal path+=/usr/include/**,/usr/local/include/**]]
-- remove {o|O} newline auto-comments
vim.opt_local.formatoptions:remove("o")
