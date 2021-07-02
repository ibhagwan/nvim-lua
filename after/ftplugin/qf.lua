-- Always open QF window at the bottom
-- vim.cmd[[wincmd J]]

-- Quit vim if the last window is qf
vim.cmd[[autocmd! BufEnter <buffer> if winnr('$') < 2| q | endif]]

vim.wo.scrolloff        = 0
vim.wo.wrap             = false
vim.wo.number           = true
vim.wo.relativenumber   = false
vim.wo.linebreak        = true
vim.wo.list             = false
vim.wo.cursorline       = true
vim.wo.spell            = false
vim.bo.buflisted        = false

vim.api.nvim_buf_set_keymap(0, 'n', '[-', "<Esc>:colder<CR>", { noremap = true })
vim.api.nvim_buf_set_keymap(0, 'n', ']+', "<Esc>:cnewer<CR>", { noremap = true })

--[[ if pcall(require, 'bqf') then
  vim.api.nvim_buf_set_keymap(0, 'n', '<F2>', "<Esc>:BqfToggle<CR>", { noremap = true })
end ]]
