vim.g.indent_blankline_enabled = false
-- vim.g.indent_blankline_char = "┊"
vim.g.indent_blankline_char = "│"
vim.g.indent_blankline_space_char = ' '
vim.g.indent_blankline_filetype_exclude = { 'help', 'packer' }
vim.g.indent_blankline_buftype_exclude = { 'terminal', 'nofile'}
vim.g.indent_blankline_char_highlight = 'LineNr'
vim.g.indent_blankline_strict_tabs = true
vim.g.indent_blankline_show_current_context = true
vim.g.indent_blankline_context_patterns = {
    "class",
    "function",
    "method",
    "^if",
    "while",
    "for",
    "with",
    "func_literal",
    "block",
    "try",
    "except",
    "argument_list",
    "object",
    "dictionary"
}

-- vim.api.nvim_set_keymap('', '<leader>"', '<Esc>:IndentBlanklineToggle<CR>',
vim.api.nvim_set_keymap('', '<leader>"',
  '<cmd>lua require("indent_blankline.commands").toggle("<bang>" == "!")<CR>',
  { noremap = true, silent = true })
