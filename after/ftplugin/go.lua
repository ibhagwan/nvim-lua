vim.wo.spell          = false
vim.bo.shiftwidth     = 4
vim.bo.tabstop        = 4
vim.bo.softtabstop    = 0
vim.bo.expandtab      = true
vim.bo.copyindent     = true
vim.bo.preserveindent = true
-- remove {o|O} newline auto-comments
vim.opt_local.formatoptions:remove("o")
