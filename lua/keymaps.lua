local remap = vim.api.nvim_set_keymap

-- Shortcuts for editing the keymap file and reloading the config
vim.cmd [[command! -nargs=* NvimEditInit split | edit $MYVIMRC]]
vim.cmd [[command! -nargs=* NvimEditKeymap split | edit ~/.config/nvim/lua/keymaps.lua]]
vim.cmd [[command! -nargs=* NvimSourceInit luafile $MYVIMRC]]
vim.cmd [[command! -nargs=* NvimReload lua require('utils').ensure_loaded_fnc({'plenary.nvim','nvim-reload'}, function() require('nvim-reload').Reload() end)]]
vim.cmd [[command! -nargs=* NvimRestart lua require('utils').ensure_loaded_fnc({'plenary.nvim','nvim-reload'}, function() require('nvim-reload').Restart() end)]]

-- Use ':Grep' or ':LGrep' to grep into quickfix|loclist
-- without output or jumping to first match
-- Use ':Grep <pattern> %' to search only current file
-- Use ':Grep <pattern> %:h' to search the current file dir
vim.cmd("command! -nargs=+ -complete=file Grep " ..
    "lua vim.api.nvim_exec([[noautocmd grep! <args> | redraw! | copen]], true)")
vim.cmd("command! -nargs=+ -complete=file LGrep " ..
    "lua vim.api.nvim_exec([[noautocmd lgrep! <args> | redraw! | lopen]], true)")

remap('', '<leader>ei', '<Esc>:NvimEditInit<CR>',   { silent = true })
remap('', '<leader>ek', '<Esc>:NvimEditKeymap<CR>', { silent = true })
remap('', '<leader>R',  "<Esc>:NvimReload<CR>",     { silent = true })

-- Fix common typos
vim.cmd([[
    cnoreabbrev W! w!
    cnoreabbrev W1 w!
    cnoreabbrev w1 w!
    cnoreabbrev Q! q!
    cnoreabbrev Q1 q!
    cnoreabbrev q1 q!
    cnoreabbrev Qa! qa!
    cnoreabbrev Qall! qall!
    cnoreabbrev Wa wa
    cnoreabbrev Wq wq
    cnoreabbrev wQ wq
    cnoreabbrev WQ wq
    cnoreabbrev wq1 wq!
    cnoreabbrev Wq1 wq!
    cnoreabbrev wQ1 wq!
    cnoreabbrev WQ1 wq!
    cnoreabbrev W w
    cnoreabbrev Q q
    cnoreabbrev Qa qa
    cnoreabbrev Qall qall
]])

-- <ctrl-s> to Save
remap('n', '<C-S>', '<esc>:update<cr>', { silent = true })
remap('v', '<C-S>', '<esc>:update<cr>', { silent = true })
remap('i', '<C-S>', '<esc>:update<cr>', { silent = true })

-- w!! to save with sudo
remap('c', 'w!!', "<esc>:lua require'utils'.sudo_write()<CR>", { silent = true })

-- Beginning and end of line in `:` command mode
remap('c', '<C-a>', '<home>', {})
remap('c', '<C-e>', '<end>' , {})

-- Terminal mappings
remap('t', '<M-[>', [[<C-\><C-n>]],      { noremap = true })
remap('t', '<C-w>', [[<C-\><C-n><C-w>]], { noremap = true })
remap('t', '<M-r>', [['<C-\><C-N>"'.nr2char(getchar()).'pi']],
    { noremap = true, expr = true })

-- tmux like directional window resizes
remap('n', '<leader><Up>',    "<cmd>lua require'utils'.resize(false, -5)<CR>", { noremap = true, silent = true })
remap('n', '<leader><Down>',  "<cmd>lua require'utils'.resize(false,  5)<CR>", { noremap = true, silent = true })
remap('n', '<leader><Left>',  "<cmd>lua require'utils'.resize(true,  -5)<CR>", { noremap = true, silent = true })
remap('n', '<leader><Right>', "<cmd>lua require'utils'.resize(true,   5)<CR>", { noremap = true, silent = true })
remap('n', '<leader>=',       '<C-w>=',               { noremap = true, silent = true })

-- Tab navigation
remap('n', '<Leader>tp', ':tabprevious<CR>', { noremap = true })
remap('n', '<Leader>tn', ':tabnext<CR>',     { noremap = true })
remap('n', '<Leader>tf', ':tabfirst<CR>',    { noremap = true })
remap('n', '<Leader>tl', ':tablast<CR>',     { noremap = true })
remap('n', '<Leader>tN', ':tabnew<CR>',      { noremap = true })
remap('n', '<Leader>tc', ':tabclose<CR>',    { noremap = true })
-- Jump to first tab & close all other tabs. Helpful after running Git difftool.
remap('n', '<Leader>to',  ':tabfirst<CR>:tabonly<CR>', { noremap = true })
-- tmux <c-meta>z like
remap('n', '<Leader>tz',  "<cmd>lua require'utils'.tabedit()<CR>", { noremap = true })
remap('n', '<Leader>tZ',  "<cmd>lua require'utils'.tabclose()<CR>", { noremap = true })

-- Navigate buffers
remap('n', '[b', ':bprevious<CR>',      { noremap = true })
remap('n', ']b', ':bnext<CR>',          { noremap = true })
remap('n', '[B', ':bfirst<CR>',         { noremap = true })
remap('n', ']B', ':blast<CR>',          { noremap = true })
-- Quickfix list mappings
remap('n', '<leader>q', "<cmd>lua require'utils'.toggle_qf('q')<CR>", { noremap = true })
remap('n', '[q', ':cprevious<CR>',      { noremap = true })
remap('n', ']q', ':cnext<CR>',          { noremap = true })
remap('n', '[Q', ':cfirst<CR>',         { noremap = true })
remap('n', ']Q', ':clast<CR>',          { noremap = true })
-- Location list mappings
remap('n', '<leader>Q', "<cmd>lua require'utils'.toggle_qf('l')<CR>", { noremap = true })
remap('n', '[l', ':lprevious<CR>',      { noremap = true })
remap('n', ']l', ':lnext<CR>',          { noremap = true })
remap('n', '[L', ':lfirst<CR>',         { noremap = true })
remap('n', ']L', ':llast<CR>',          { noremap = true })
-- Tags / Preview tags
remap('n', '[t', ':tprevious<CR>',      { noremap = true })
remap('n', ']t', ':tNext<CR>',          { noremap = true })
remap('n', '[T', ':tfirst<CR>',         { noremap = true })
remap('n', ']T', ':tlast<CR>',          { noremap = true })
remap('n', '[p', ':ptprevious<CR>',     { noremap = true })
remap('n', ']p', ':ptnext<CR>',         { noremap = true })
--remap('n', '<Leader>ts', ':<C-u>tselect <C-r><C-w><CR>', { noremap = true })

-- <leader>v|<leader>s act as <cmd-v>|<cmd-s>
-- <leader>p|P paste from yank register (0)
remap('n', '<leader>v', '"+p',      { noremap = true })
remap('n', '<leader>V', '"+P',      { noremap = true })
remap('v', '<leader>v', '"_d"+p',   { noremap = true })
remap('v', '<leader>v', '"_d"+P',   { noremap = true })
remap('n', '<leader>s', '"*p',      { noremap = true })
remap('n', '<leader>S', '"*P',      { noremap = true })
remap('v', '<leader>s', '"*p',      { noremap = true })
remap('v', '<leader>S', '"*p',      { noremap = true })

-- Overloads for 'd|c' that don't pollute the unnamed registers
-- In visual-select mode 'd=delete, x=cut (unchanged)'
remap('n', '<leader>d',  '"_d',     { noremap = true })
remap('n', '<leader>D',  '"_D',     { noremap = true })
remap('n', '<leader>c',  '"_c',     { noremap = true })
remap('n', '<leader>C',  '"_C',     { noremap = true })
remap('v', '<leader>c',  '"_c',     { noremap = true })
remap('v', 'd',          '"_d',     { noremap = true })

-- Map `Y` to copy to end of line
-- conistent with the behaviour of `C` and `D`
remap('n', 'Y', 'y$',               { noremap = true })
remap('v', 'Y', '<Esc>y$gv',        { noremap = true })

-- keep visual selection when (de)indenting
remap('v', '<', '<gv', { noremap = true })
remap('v', '>', '>gv', { noremap = true })

-- Move selected lines up/down in visual mode
remap('x', 'K', ":move '<-2<CR>gv=gv", { noremap = true })
remap('x', 'J', ":move '>+1<CR>gv=gv", { noremap = true })

-- Select last pasted/yanked text
remap('n', 'g<C-v>', '`[v`]', { noremap = true })

-- move along visual lines, not numbered ones
-- without interferring with {count}<down|up>
vim.api.nvim_set_keymap('n', '<up>', "v:count == 0 ? 'gk' : '<up>'",
    { noremap=true, expr = true, silent = true})
vim.api.nvim_set_keymap('v', '<up>', "v:count == 0 ? 'gk' : '<up>'",
    { noremap=true, expr = true, silent = true})
vim.api.nvim_set_keymap('n', '<down>', "v:count == 0 ? 'gj' : '<down>'",
    {noremap= true, expr = true, silent = true})
vim.api.nvim_set_keymap('v', '<down>', "v:count == 0 ? 'gj' : '<down>'",
    {noremap= true, expr = true, silent = true})

-- Search and Replace
-- 'c.' for word, '<leader>c.' for WORD
remap('n', 'c.',         [[:%s/\<<C-r><C-w>\>//g<Left><Left>]], { noremap = true })
remap('n', '<leader>c.', [[:%s/\<<C-r><C-a>\>//g<Left><Left>]], { noremap = true })

-- Turn off search matches with double-<Esc>
remap('n', '<Esc><Esc>', '<Esc>:nohlsearch<CR>', { noremap = true, silent = true })

-- Toggle display of `listchars`
remap('n', '<leader>\'', '<Esc>:set list!<CR>',   { noremap = true, silent = true })

-- Toggle colored column at 81
remap('n', '<leader>|',
    ':execute "set colorcolumn=" . (&colorcolumn == "" ? "81" : "")<CR>', 
    { noremap = true, silent = true })

-- Change current working dir (:pwd) to curent file's folder
remap('n', '<leader>%', '<Esc>:cd %:h | pwd<CR>',   { noremap = true, silent = true })

-- Map <leader>o & <leader>O to newline without insert mode
remap('n', '<leader>o',
    ':<C-u>call append(line("."), repeat([""], v:count1))<CR>',
    { noremap = true, silent = true })
remap('n', '<leader>O',
    ':<C-u>call append(line(".")-1, repeat([""], v:count1))<CR>',
    { noremap = true, silent = true })

-- Map `cp` to `xp` (transpose two adjacent chars)
-- as a **repeatable action** with `.`
-- (since the `@=` trick doesn't work
-- nmap cp @='xp'<CR>
-- http://vimcasts.org/transcripts/61/en/
remap('n', '<Plug>TransposeCharacters',
    [[xp:call repeat#set("\<Plug>TransposeCharacters")<CR>]],
    { noremap = true, silent = true })
remap('n', 'cp', '<Plug>TransposeCharacters', {})
