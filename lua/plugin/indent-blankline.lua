vim.g.indent_blankline_enabled = false
vim.g.indent_blankline_char = "┊"
-- vim.g.indent_blankline_char = "▏"
vim.g.indent_blankline_space_char = ' '
vim.g.indent_blankline_filetype_exclude = { 'help', 'packer', 'terminal' }
vim.g.indent_blankline_buftype_exclude = { 'terminal', 'nofile'}
vim.g.indent_blankline_char_highlight = 'LineNr'

-- vim.api.nvim_set_keymap('', '<leader>"', '<Esc>:IndentBlanklineToggle<CR>',
vim.api.nvim_set_keymap('', '<leader>"',
  '<cmd>lua require("indent_blankline.commands").toggle("<bang>" == "!")<CR>',
  { noremap = true, silent = true })
