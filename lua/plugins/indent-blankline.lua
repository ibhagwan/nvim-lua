local res, indent = pcall(require, "indent_blankline")
if not res then
  return
end

indent.setup({
  enabled = false,
  -- char = "│",
  -- char_list = { '│', '┆', '|', '┊' },
  space_char_blankline = ' ',
  use_treesitter = true,
  show_end_of_line = true,
  show_first_indent_level = true,
  disable_with_nolist = false,
  filetype_exclude = { 'help' },
  buftype_exclude = { 'terminal', 'nofile'},
  strict_tabs = true,
  show_current_context = true,
  show_current_context_start = true,
})

-- vim.api.nvim_set_keymap('', '<leader>"', '<Esc>:IndentBlanklineToggle<CR>',
vim.api.nvim_set_keymap('', '<leader>"',
  '<cmd>lua require("indent_blankline.commands").toggle("<bang>" == "!")<CR>',
  { noremap = true, silent = true })
