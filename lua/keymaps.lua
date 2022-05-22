local remap = require'utils'.remap
local command = require'utils'.command

-- Shortcuts for editing the keymap file and reloading the config
vim.cmd [[command! -nargs=* NvimEditInit split | edit $MYVIMRC]]
vim.cmd [[command! -nargs=* NvimEditKeymap split | edit ~/.config/nvim/lua/keymaps.lua]]
vim.cmd [[command! -nargs=* NvimSourceInit luafile $MYVIMRC]]

-- fugitive shortcuts for yadm
local yadm_repo = "$HOME/dots/yadm-repo"
local function fugitive_command(nargs, cmd_name, cmd_git, cmd_comp)
  local complete = cmd_comp and ("-complete=customlist,%s"):format(cmd_comp) or ""
  vim.cmd (([[command! -nargs=%s %s %s ]] ..
    [[lua require("utils").fugitive_exec("%s", "%s", <q-args>)]])
      :format(nargs, complete, cmd_name, yadm_repo, cmd_git))
end

-- auto-complete for our custom fugitive Yadm command
-- https://github.com/tpope/vim-fugitive/issues/1981#issuecomment-1113825991
vim.cmd(([[
  function! YadmComplete(A, L, P) abort
    return fugitive#Complete(a:A, a:L, a:P, {'git_dir': expand("%s")})
  endfunction
]]):format(yadm_repo))

vim.cmd(([[command! -bang -nargs=? -range=-1 -complete=customlist,YadmComplete Yadm exe fugitive#Command(<line1>, <count>, +"<range>", <bang>0, "<mods>", <q-args>, { 'git_dir': expand("%s") })]]):format(yadm_repo))

-- fugitive_command("?", "Yadm",        "Git",          "fugitive#Complete")
fugitive_command("?", "Yit",         "Git",          "YadmComplete")
fugitive_command("*", "Yread",       "Gread",        "fugitive#ReadComplete")
fugitive_command("*", "Yedit",       "Gedit",        "fugitive#EditComplete")
fugitive_command("*", "Ywrite",      "Gwrite",       "fugitive#EditComplete")
fugitive_command("*", "Ydiffsplit",  "Gdiffsplit",   "fugitive#EditComplete")
fugitive_command("*", "Yhdiffsplit", "Ghdiffsplit",  "fugitive#EditComplete")
fugitive_command("*", "Yvdiffsplit", "Gvdiffsplit",  "fugitive#EditComplete")
fugitive_command("1", "YMove",       "GMove",        "fugitive#CompleteObject")
fugitive_command("1", "YRename",     "GRename",      "fugitive#RenameComplete")
fugitive_command("0", "YRemove",     "GRemove")
fugitive_command("0", "YUnlink",     "GUnlink")
fugitive_command("0", "YDelete",     "GDelete")


command({
    "-nargs=*", "NvimRestart", function()
    if not pcall(require, 'nvim-reload') then
      require('packer').loader('nvim-reload')
    end
    require('plugins.nvim-reload')
    require('nvim-reload').Restart()
  end})

-- Use ':Grep' or ':LGrep' to grep into quickfix|loclist
-- without output or jumping to first match
-- Use ':Grep <pattern> %' to search only current file
-- Use ':Grep <pattern> %:h' to search the current file dir
vim.cmd("command! -nargs=+ -complete=file Grep noautocmd grep! <args> | redraw! | copen")
vim.cmd("command! -nargs=+ -complete=file LGrep noautocmd lgrep! <args> | redraw! | lopen")

remap('', '<leader>ei', '<Esc>:NvimEditInit<CR>',   { silent = true })
remap('', '<leader>ek', '<Esc>:NvimEditKeymap<CR>', { silent = true })
remap('', '<leader>R',  "<Esc>:NvimRestart<CR>",    { silent = true })

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
remap({ 'n', 'v', 'i'}, '<C-S>', '<C-c>:update<cr>', { silent = true })

-- w!! to save with sudo
remap('c', 'w!!', "<esc>:lua require'utils'.sudo_write()<CR>", { silent = true })

-- Beginning and end of line in `:` command mode
remap('c', '<C-a>', '<home>', {})
remap('c', '<C-e>', '<end>' , {})

-- Arrows in command line mode (':') menus
remap('c', '<down>', '(pumvisible() ? "\\<C-n>" : "\\<down>")', { noremap = true, expr = true })
remap('c', '<up>',   '(pumvisible() ? "\\<C-p>" : "\\<up>")',   { noremap = true, expr = true })

-- Terminal mappings
remap('t', '<M-[>', [[<C-\><C-n>]],      { noremap = true })
remap('t', '<C-w>', [[<C-\><C-n><C-w>]], { noremap = true })
remap('t', '<M-r>', [['<C-\><C-N>"'.nr2char(getchar()).'pi']], { noremap = true, expr = true })

-- tmux like directional window resizes
remap('n', '<leader><Up>',    "<cmd>lua require'utils'.resize(false, -5)<CR>", { noremap = true, silent = true })
remap('n', '<leader><Down>',  "<cmd>lua require'utils'.resize(false,  5)<CR>", { noremap = true, silent = true })
remap('n', '<leader><Left>',  "<cmd>lua require'utils'.resize(true,  -5)<CR>", { noremap = true, silent = true })
remap('n', '<leader><Right>', "<cmd>lua require'utils'.resize(true,   5)<CR>", { noremap = true, silent = true })
remap('n', '<leader>=',       '<C-w>=', { noremap = true, silent = true })

-- Tab navigation
remap('n', '[t',         ':tabprevious<CR>', { noremap = true })
remap('n', ']t',         ':tabnext<CR>',     { noremap = true })
remap('n', '[T',         ':tabfirst<CR>',    { noremap = true })
remap('n', ']T',         ':tablast<CR>',     { noremap = true })
remap('n', '<Leader>tn', ':tabnew<CR>',      { noremap = true })
remap('n', '<Leader>tc', ':tabclose<CR>',    { noremap = true })
remap('n', '<Leader>to', ':tabonly<CR>',     { noremap = true })
-- Jump to first tab & close all other tabs. Helpful after running Git difftool.
remap('n', '<Leader>tO', ':tabfirst<CR>:tabonly<CR>', { noremap = true })
-- tmux <c-meta>z like
remap('n', '<Leader>tz',  "<cmd>lua require'utils'.tabZ()<CR>", { noremap = true })

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

-- shortcut to view :messages
remap({'n', 'v'}, '<leader>m', '<cmd>messages<CR>',  { noremap = true })
remap({'n', 'v'}, '<leader>M', '<cmd>mes clear|echo "cleared :messages"<CR>', { noremap = true })

-- <leader>v|<leader>s act as <cmd-v>|<cmd-s>
-- <leader>p|P paste from yank register (0)
-- <leader>y|Y yank into clipboard/OSCyank
remap({'n', 'v'}, '<leader>v', '"+p',   { noremap = true })
remap({'n', 'v'}, '<leader>V', '"+P',   { noremap = true })
remap({'n', 'v'}, '<leader>s', '"*p',   { noremap = true })
remap({'n', 'v'}, '<leader>S', '"*P',   { noremap = true })
remap({'n', 'v'}, '<leader>p', '"0p',   { noremap = true })
remap({'n', 'v'}, '<leader>P', '"0P',   { noremap = true })
remap({'n', 'v'}, '<leader>y', '<cmd>OSCYankReg 0<CR>', { noremap = true })
-- remap({'n', 'v'}, '<leader>y', '<cmd>let @+=@0<CR>', { noremap = true })

-- Overloads for 'd|c' that don't pollute the unnamed registers
remap('n', '<leader>D',  '"_D',         { noremap = true })
remap('n', '<leader>C',  '"_C',         { noremap = true })
remap({'n', 'v'}, '<leader>c',  '"_c',  { noremap = true })

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

-- Keep matches center screen when cycling with n|N
remap('n', 'n', 'nzzzv', { noremap = true })
remap('n', 'N', 'Nzzzv', { noremap = true })

-- Break undo chain on punctuation so we can
-- use 'u' to undo sections of an edit
-- DISABLED, ALL KINDS OF ODDITIES
--[[ for _, c in ipairs({',', '.', '!', '?', ';'}) do
   remap('i', c, c .. "<C-g>u", { noremap = true })
end --]]

-- any jump over 5 modifies the jumplist
-- so we can use <C-o> <C-i> to jump back and forth
for _, c in ipairs({'j', 'k'}) do
  remap('n', c, ([[(v:count > 5 ? "m'" . v:count : "") . '%s']]):format(c),
    { noremap=true, expr = true, silent = true})
end

-- move along visual lines, not numbered ones
-- without interferring with {count}<down|up>
for _, m in ipairs({'n', 'v'}) do
  for _, c in ipairs({'<up>', '<down>'}) do
    remap(m, c, ([[v:count == 0 ? 'g%s' : '%s']]):format(c, c),
        { noremap=true, expr = true, silent = true})
  end
end

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
remap('n', '<leader>%', '<Esc>:lua require"utils".set_cwd()<CR>', { noremap = true, silent = true })

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
