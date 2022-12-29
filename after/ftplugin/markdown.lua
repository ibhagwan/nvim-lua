vim.wo.conceallevel = 0
vim.wo.spell        = true
vim.wo.foldexpr     = ""

-- Previm plugin
-- vim.api.nvim_set_keymap('', '<leader>r', "<Esc>:PrevimOpen<CR>",
vim.api.nvim_set_keymap("", "<leader>r",
  "<cmd>call previm#open(previm#make_preview_file_path('index.html'))<CR>",
  { silent = true, desc = "open markdown preview (previm)" })

if vim.g.previm_enable_realtime == 1 then
  vim.cmd [[autocmd CursorHold,CursorHoldI,InsertLeave,BufWritePost <buffer> call previm#refresh()]]
else
  vim.cmd [[autocmd BufWritePost <buffer> call previm#refresh()]]
end
