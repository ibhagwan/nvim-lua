local map = vim.keymap.set

-- :Gedit will always send us back to the working copy
-- and thus serves as a quasi back button
map('n', '<leader>gg', '<Esc>:Git<CR>', { silent = true, desc = "Git" })
map('n', '<leader>gr', '<Esc>:Gread<CR>', { silent = true, desc = "Gread (reset)" })
map('n', '<leader>gw', '<Esc>:Gwrite<CR>', { silent = true, desc = "Gwrite (stage)" })
map('n', '<leader>gb', '<Esc>:Git blame<CR>', { silent = true, desc = "git blame" })
-- map('n', '<leader>gc', '<Esc>:Git commit<CR>', { silent = true })
map('n', '<leader>gd', '<Esc>:Gvdiffsplit!<CR>', { silent = true, desc = "Git diff (buffer)" })
map('n', '<leader>gD', '<Esc>:Git diff<CR>', { silent = true, desc = "Git diff (project)" })
map('n', '<leader>gp', '<Esc>:Git push<CR>', { silent = true, desc = "Git push" })
map('n', '<leader>gP', '<Esc>:Git pull<CR>', { silent = true, desc = "Git pull" })
map('n', '<leader>g-', '<Esc>:Git stash push<CR>', { silent = true, desc = "Git stash push" })
map('n', '<leader>g+', '<Esc>:Git stash pop<CR>',  { silent = true, desc = "Git stash pop" })
map('n', '<leader>gl', '<Esc>:Git log --stat %<CR>', { silent = true, desc = "Git log (buffer)" })
map('n', '<leader>gL', '<Esc>:Git log --stat -n 100<CR>', { silent = true, desc = "Git log (project)" })
