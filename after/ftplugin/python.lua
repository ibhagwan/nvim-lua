vim.wo.spell       = false
vim.bo.shiftwidth  = 4
vim.bo.tabstop     = 4
vim.bo.softtabstop = 4
vim.bo.expandtab   = true
vim.bo.textwidth   = 0
-- remove {o|O} newline auto-comments
vim.opt_local.formatoptions:remove("o")
