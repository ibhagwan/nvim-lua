vim.g.fzf_command_prefix = 'Fzf'

local remap = vim.api.nvim_set_keymap

--remap('n', '<Leader>z\\', ':FZFRg<CR>',         { noremap = true })
--remap('n', '<Leader>zR',  ':FZFGrep<Space>',    { noremap = true })
--remap('n', '<Leader>zG',  ':FZFGGrep<Space>',   { noremap = true })
--remap('n', '<Leader>zl',  ':FZFBLines<CR>',   { noremap = true })
--remap('n', '<Leader>zT',  ':FZFTags<SPACE>',  { noremap = true })

-- Ensure lazy-loaded fzf is actually loaded
remap('n', '<Leader>z\\',
    [[:lua require('utils').ensure_loaded_cmd({'fzf.vim', 'fzf-preview.vim'}, {'FZFRg'})<CR>]],
    { noremap = true, silent = true })

remap('n', '<Leader>zR',
    [[:lua require('utils').ensure_loaded_cmd({'fzf.vim', 'fzf-preview.vim'}, {'FZFGrep'})<CR>]],
    { noremap = true, silent = true })

remap('n', '<Leader>zG',
    [[:lua require('utils').ensure_loaded_cmd({'fzf.vim', 'fzf-preview.vim'}, {'FZFGGrep'})<CR>]],
    { noremap = true, silent = true })

remap('n', '<Leader>zq',
    [[:lua require('utils').ensure_loaded_cmd({'fzf.vim', 'fzf-preview.vim'}, {'cclose', 'FZFQuickFix'})<CR>]],
    { noremap = true, silent = true })

remap('n', '<Leader>zQ',
    [[:lua require('utils').ensure_loaded_cmd({'fzf.vim', 'fzf-preview.vim'}, {'lclose', 'FZFLocList'})<CR>]],
    { noremap = true, silent = true })

remap('n', '<Leader>zm',
    [[:lua require('utils').ensure_loaded_cmd({'fzf.vim', 'fzf-preview.vim'}, {'FZFMarks'})<CR>]],
    { noremap = true, silent = true })

remap('n', '<Leader>zb',
    [[:lua require('utils').ensure_loaded_cmd({'fzf.vim', 'fzf-preview.vim'}, {'FZFBLines'})<CR>]],
    { noremap = true, silent = true })

-- workaround for quickfix/loclist not aviailable after nvim-reload
vim.cmd[[command! -bar -bang FZFQuickFix call fzf_preview#quickfix(0, <bang>0)]]
vim.cmd[[command! -bar -bang FZFLocList call fzf_preview#quickfix(1, <bang>0)]]
