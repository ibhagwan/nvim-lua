local map = vim.keymap.set

-- Reload the config (including certain plugins)
vim.api.nvim_create_user_command("NvimRestart",
  function()
    if not pcall(require, 'nvim-reload') then
      require('packer').loader('nvim-reload')
    end
    require('plugins.nvim-reload')
    require('nvim-reload').Restart()
  end,
  { nargs = "*" }
)

map('', '<leader>R', "<Esc>:NvimRestart<CR>",
  { silent = true, desc = "reload nvim configuration" })

-- Use ':Grep' or ':LGrep' to grep into quickfix|loclist
-- without output or jumping to first match
-- Use ':Grep <pattern> %' to search only current file
-- Use ':Grep <pattern> %:h' to search the current file dir
vim.cmd("command! -nargs=+ -complete=file Grep noautocmd grep! <args> | redraw! | copen")
vim.cmd("command! -nargs=+ -complete=file LGrep noautocmd lgrep! <args> | redraw! | lopen")

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
map({ 'n', 'v', 'i'}, '<C-S>', '<C-c>:update<cr>', { silent = true, desc = "Save" })

-- w!! to save with sudo
map('c', 'w!!', "<esc>:lua require'utils'.sudo_write()<CR>", { silent = true })

-- Beginning and end of line in `:` command mode
map('c', '<C-a>', '<home>', {})
map('c', '<C-e>', '<end>' , {})

-- Arrows in command line mode (':') menus
-- TODO: why the below doesn't work with nightly 0.8?
-- map('c', '<down>', '(pumvisible() ? "\\<C-n>" : "\\<down>")', { expr = true })
-- map('c', '<up>',   '(pumvisible() ? "\\<C-p>" : "\\<up>")',   { expr = true })
for k, v in pairs({ ['<down>'] = '<C-n>', ['<up>'] = '<C-p>' }) do
  map('c', k, function()
    local key = vim.fn.pumvisible() ~= 0 and v or k
    vim.api.nvim_feedkeys(
      vim.api.nvim_replace_termcodes(key,
        true, false, true), 'n', false)
  end, { silent = false })
end

-- Terminal mappings
map('t', '<M-[>', [[<C-\><C-n>]],      {})
map('t', '<C-w>', [[<C-\><C-n><C-w>]], {})
map('t', '<M-r>', [['<C-\><C-N>"'.nr2char(getchar()).'pi']], { expr = true })

-- tmux like directional window resizes
map('n', '<leader>=', '<C-w>=',
  { silent = true, desc = "normalize split layout" })
map('n', '<leader><Up>',    "<cmd>lua require'utils'.resize(false, -5)<CR>",
  { silent = true, desc = "horizontal split increase" })
map('n', '<leader><Down>',  "<cmd>lua require'utils'.resize(false,  5)<CR>",
  { silent = true, desc = "horizontal split decrease" })
map('n', '<leader><Left>',  "<cmd>lua require'utils'.resize(true,  -5)<CR>",
  { silent = true, desc = "vertical split decrease" })
map('n', '<leader><Right>', "<cmd>lua require'utils'.resize(true,   5)<CR>",
  { silent = true, desc = "vertical split increase" })

-- Navigate tabs
map('n', '[t', ':tabprevious<CR>', { desc = "Previous tab" })
map('n', ']t', ':tabnext<CR>',     { desc = "Next tab" })
map('n', '[T', ':tabfirst<CR>',    { desc = "First tab" })
map('n', ']T', ':tablast<CR>',     { desc = "Last tab" })
-- Navigate buffers
map('n', '[b', ':bprevious<CR>',   { desc = "Previous buffer" })
map('n', ']b', ':bnext<CR>',       { desc = "Next buffer" })
map('n', '[B', ':bfirst<CR>',      { desc = "First buffer" })
map('n', ']B', ':blast<CR>',       { desc = "Last buffer" })
-- Quickfix list mappings
map('n', '<leader>q', "<cmd>lua require'utils'.toggle_qf('q')<CR>",
  { desc = "toggle quickfix list" })
map('n', '[q', ':cprevious<CR>',   { desc = "Next quickfix" })
map('n', ']q', ':cnext<CR>',       { desc = "Previous quickfix" })
map('n', '[Q', ':cfirst<CR>',      { desc = "First quickfix" })
map('n', ']Q', ':clast<CR>',       { desc = "Last quickfix" })
-- Location list mappings
map('n', '<leader>Q', "<cmd>lua require'utils'.toggle_qf('l')<CR>",
  { desc = "toggle location list" })
map('n', '[l', ':lprevious<CR>',   { desc = "Previous location" })
map('n', ']l', ':lnext<CR>',       { desc = "Next location" })
map('n', '[L', ':lfirst<CR>',      { desc = "First location" })
map('n', ']L', ':llast<CR>',       { desc = "Last location" })

-- shortcut to view :messages
map({'n', 'v'}, '<leader>m', '<cmd>messages<CR>',
  { desc = "open :messages" })
map({'n', 'v'}, '<leader>M', '<cmd>mes clear|echo "cleared :messages"<CR>',
  { desc = "clear :messages" })

-- <leader>v|<leader>s act as <cmd-v>|<cmd-s>
-- <leader>p|P paste from yank register (0)
-- <leader>y|Y yank into clipboard/OSCyank
map({'n', 'v'}, '<leader>v', '"+p',   { desc = "paste AFTER from clipboard" })
map({'n', 'v'}, '<leader>V', '"+P',   { desc = "paste BEFORE from clipboard" })
map({'n', 'v'}, '<leader>s', '"*p',   { desc = "paste AFTER from primary" })
map({'n', 'v'}, '<leader>S', '"*P',   { desc = "paste BEFORE from primary" })
map({'n', 'v'}, '<leader>p', '"0p',   { desc = "paste AFTER  from yank (reg:0)" })
map({'n', 'v'}, '<leader>P', '"0P',   { desc = "paste BEFORE from yank (reg:0)" })
-- NOT IN USE: instead, we use an autocmd that tests
-- for $SSH_CONNECTION to trigger the OSC52 sequence
-- map({'n', 'v'}, '<leader>y', '<cmd>OSCYankReg 0<CR>', {})
-- map({'n', 'v'}, '<leader>y', '<cmd>let @+=@0<CR>', {})

-- Overloads for 'd|c' that don't pollute the unnamed registers
map('n', '<leader>D',  '"_D',         { desc = "blackhole 'D'" })
map('n', '<leader>C',  '"_C',         { desc = "blackhole 'C'" })
map({'n', 'v'}, '<leader>c',  '"_c',  { desc = "blackhole 'c'" })

-- keep visual selection when (de)indenting
map('v', '<', '<gv', {})
map('v', '>', '>gv', {})

-- Move selected lines up/down in visual mode
map('x', 'K', ":move '<-2<CR>gv=gv", {})
map('x', 'J', ":move '>+1<CR>gv=gv", {})

-- Select last pasted/yanked text
map('n', 'g<C-v>', '`[v`]', { desc = "visual select last yank/paste" })

-- Keep matches center screen when cycling with n|N
map('n', 'n', 'nzzzv', { desc = "Fwd  search '/' or '?'" })
map('n', 'N', 'Nzzzv', { desc = "Back search '/' or '?'" })

-- Break undo chain on punctuation so we can
-- use 'u' to undo sections of an edit
-- DISABLED, ALL KINDS OF ODDITIES
--[[ for _, c in ipairs({',', '.', '!', '?', ';'}) do
   map('i', c, c .. "<C-g>u", {})
end --]]

-- any jump over 5 modifies the jumplist
-- so we can use <C-o> <C-i> to jump back and forth
for _, c in ipairs({
    { 'k', 'Line up' },
    { 'j', 'Line down' },
  }) do
  map('n', c[1], ([[(v:count > 5 ? "m'" . v:count : "") . '%s']]):format(c[1]),
    { expr = true, silent = true, desc = c[2] })
end

-- move along visual lines, not numbered ones
-- without interferring with {count}<down|up>
for _, m in ipairs({'n', 'v'}) do
  for _, c in ipairs({
      { '<up>',   'k', 'Visual line up'},
      { '<down>', 'j', 'Visual line down'}
    }) do
    map(m, c[1], ([[v:count == 0 ? 'g%s' : '%s']]):format(c[2], c[2]),
        { expr = true, silent = true, desc = c[3] })
  end
end

-- Search and Replace
-- 'c.' for word, 'c>' for WORD
-- 'c.' in visual mode for selection
map('n', 'c.', [[:%s/\<<C-r><C-w>\>//g<Left><Left>]],
  { desc = "search and replace word under cursor" })
map('n', 'c>', [[:%s/\V<C-r><C-a>//g<Left><Left>]],
  { desc = "search and replace WORD under cursor" })
map('x', 'c.', [[:<C-u>%s/\V<C-r>=luaeval("require'utils'.get_visual_selection(true)")<CR>//g<Left><Left>]], {})

-- Turn off search matches with double-<Esc>
map('n', '<Esc><Esc>', '<Esc>:nohlsearch<CR>', { silent = true })

-- Toggle display of `listchars`
map('n', "<leader>'",  '<Esc>:set list!<CR>',
  { silent = true, desc = "toggle 'listchars' on/off" })

-- Toggle colored column at 81
map('n', '<leader>|',
    ':execute "set colorcolumn=" . (&colorcolumn == "" ? "81" : "")<CR>',
    { silent = true, desc = "toggle color column on/off" })

-- Change current working dir (:pwd) to curent file's folder
map('n', '<leader>%', '<Esc>:lua require"utils".set_cwd()<CR>',
  { silent = true, desc = "smart set cwd (git|file parent)" })

-- Map <leader>o & <leader>O to newline without insert mode
map('n', '<leader>o',
    ':<C-u>call append(line("."), repeat([""], v:count1))<CR>',
    { silent = true, desc = "newline below (no insert-mode)" })
map('n', '<leader>O',
    ':<C-u>call append(line(".")-1, repeat([""], v:count1))<CR>',
    { silent = true, desc = "newline above (no insert-mode)" })

-- Use operator pending mode to visually select entire buffer, e.g.
--    d<A-a> = delete entire buffer
--    y<A-a> = yank entire buffer
--    v<A-a> = visual select entire buffer
map('o', '<A-a>', ':<C-U>normal! mzggVG<CR>`z')
map('x', '<A-a>', ':<C-U>normal! ggVG<CR>')

-- fugitive shortcuts for yadm
local yadm_repo = "$HOME/dots/yadm-repo"

-- auto-complete for our custom fugitive Yadm command
-- https://github.com/tpope/vim-fugitive/issues/1981#issuecomment-1113825991
vim.cmd(([[
  function! YadmComplete(A, L, P) abort
    return fugitive#Complete(a:A, a:L, a:P, {'git_dir': expand("%s")})
  endfunction
]]):format(yadm_repo))

vim.cmd(([[command! -bang -nargs=? -range=-1 -complete=customlist,YadmComplete Yadm exe fugitive#Command(<line1>, <count>, +"<range>", <bang>0, "<mods>", <q-args>, { 'git_dir': expand("%s") })]]):format(yadm_repo))

local function fugitive_command(nargs, cmd_name, cmd_fugitive, cmd_comp)
  vim.api.nvim_create_user_command(cmd_name,
    function(t)
      local bufnr = vim.api.nvim_get_current_buf()
      local buf_git_dir = vim.b.git_dir
      vim.b.git_dir = vim.fn.expand(yadm_repo)
      vim.cmd(cmd_fugitive .. " " .. t.args)
      -- after the fugitive window switch we must explicitly
      -- use the buffer num to restore the original 'git_dir'
      vim.b[bufnr].git_dir = buf_git_dir
    end,
    {
      nargs = nargs,
      complete = cmd_comp and string.format("customlist,%s", cmd_comp) or nil,
    }
  )
end

-- fugitive_command("?", "Yadm",        "Git",          "fugitive#Complete")
fugitive_command("?", "Yit",         "Git",          "YadmComplete")
fugitive_command("*", "Yread",       "Gread",        "fugitive#ReadComplete")
fugitive_command("*", "Yedit",       "Gedit",        "fugitive#EditComplete")
fugitive_command("*", "Ywrite",      "Gwrite",       "fugitive#EditComplete")
fugitive_command("*", "Ydiffsplit",  "Gdiffsplit",   "fugitive#EditComplete")
fugitive_command("*", "Yhdiffsplit", "Ghdiffsplit",  "fugitive#EditComplete")
fugitive_command("*", "Yvdiffsplit", "Gvdiffsplit",  "fugitive#EditComplete")
fugitive_command(1,   "YMove",       "GMove",        "fugitive#CompleteObject")
fugitive_command(1,   "YRename",     "GRename",      "fugitive#RenameComplete")
fugitive_command(0,   "YRemove",     "GRemove")
fugitive_command(0,   "YUnlink",     "GUnlink")
fugitive_command(0,   "YDelete",     "GDelete")
