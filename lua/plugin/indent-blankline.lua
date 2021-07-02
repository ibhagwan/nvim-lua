vim.g.indent_blankline_enabled = false
vim.g.indent_blankline_char = "┊"
vim.g.indent_blankline_space_char = ' '
vim.g.indent_blankline_filetype_exclude = { 'help', 'packer' }
vim.g.indent_blankline_buftype_exclude = { 'terminal', 'nofile'}
vim.g.indent_blankline_char_highlight = 'LineNr'

vim.api.nvim_set_keymap('', '<leader>"', '<Esc>:IndentBlanklineToggle<CR>',
{ noremap = true, silent = true })
