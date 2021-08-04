local remap = vim.api.nvim_set_keymap

-- :Gedit will always send us back to the working copy
-- and thus serves as a quasi back button
remap('', '<leader>gg', '<Esc>:Gedit<CR>',          { noremap = true })
remap('', '<leader>gs', '<Esc>:Git<CR>',            { noremap = true })
remap('', '<leader>gr', '<Esc>:Gread<CR>',          { noremap = true })
remap('', '<leader>gw', '<Esc>:Gwrite<CR>',         { noremap = true })
remap('', '<leader>ga', '<Esc>:Git add %<CR>',      { noremap = true })
remap('', '<leader>gA', '<Esc>:Git add .<CR>',      { noremap = true })
remap('', '<leader>gb', '<Esc>:Git blame<CR>',      { noremap = true })
remap('', '<leader>gc', '<Esc>:Git commit<CR>',     { noremap = true })
remap('', '<leader>gd', '<Esc>:Gvdiffsplit!<CR>',   { noremap = true })
remap('', '<leader>gD', '<Esc>:Git diff | setlocal nonumber norelativenumber | wincmd o<CR>',   { noremap = true })
remap('', '<leader>gp', '<Esc>:Git push<CR>',       { noremap = true })
remap('', '<leader>gS', '<Esc>:Git stash -- %<CR>', { noremap = true })
remap('', '<leader>g-', '<Esc>:Git stash<CR>',      { noremap = true })
remap('', '<leader>g+', '<Esc>:Git stash pop<CR>',  { noremap = true })
remap('', '<leader>gf', '<Esc>:Git fetch --all<CR>',                { noremap = true })
remap('', '<leader>gF', '<Esc>:Git fetch origin<CR>',               { noremap = true })
remap('', '<leader>gl', '<Esc>:Git log --stat %<CR>',               { noremap = true })
remap('', '<leader>gL', '<Esc>:Git log --stat -n 100<CR>',          { noremap = true })
remap('', '<leader>ge', '<Esc>:vsp<CR>:Gedit HEAD~:%<left><left>',  { noremap = true })
remap('', '<leader>gE', '<Esc>:sp<CR>:Gedit HEAD~:%<left><left>',   { noremap = true })

-- 'sindrets/diffview.nvim'
remap('', '<leader>gv', '<Esc>:DiffviewOpen<CR>',   { noremap = true })
remap('', '<leader>gV', '<Esc>:DiffviewClose<CR>',  { noremap = true })
