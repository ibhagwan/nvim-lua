local res, indent = pcall(require, "indent_blankline")
if not res then
  return
end

local opts = {
  enabled = true,
  -- char = "│",
  -- char_list = { '│', '┆', '|', '┊' },
  space_char_blankline = ' ',
  use_treesitter = true,
  show_end_of_line = true,
  show_first_indent_level = true,
  disable_with_nolist = false,
  filetype_exclude = { 'txt', 'text' },
  buftype_exclude = { 'terminal', 'nofile', 'help' },
  strict_tabs = true,
  show_current_context = true,
  show_current_context_start = true,
}

if not pcall(require, "nvim-treesitter") then
  -- will prevent plugin from working when
  -- treesitter is not available (no C compiler)
  opts.use_treesitter = false
  opts.show_current_context = false
  opts.show_current_context_start = false
end

indent.setup(opts)

-- vim.api.nvim_set_keymap('', '<leader>"', '<Esc>:IndentBlanklineToggle<CR>',
vim.api.nvim_set_keymap('', '<leader>"',
  '<cmd>lua require("indent_blankline.commands").toggle("<bang>" == "!")<CR>',
  { noremap = true, silent = true })
