vim.wo.conceallevel = 0
vim.wo.spell        = true
vim.wo.foldexpr     = ""

-- Previm plugin
-- vim.api.nvim_set_keymap('', '<leader>M', "<Esc>:PrevimOpen<CR>",
-- lazy load doesn't load plugin commands, workaround
vim.api.nvim_set_keymap('', '<leader>M', "<cmd>call previm#open(previm#make_preview_file_path('index.html'))<CR>", { silent = true })

-- conditionally load previm (packer.opt = true)
if pcall(require, 'packer') then
  if pcall(require'packer'.loader, 'previm') then
    if vim.g.previm_enable_realtime == 1 then
      vim.cmd[[autocmd CursorHold,CursorHoldI,InsertLeave,BufWritePost <buffer> call previm#refresh()]]
    else
      vim.cmd[[autocmd BufWritePost <buffer> call previm#refresh()]]
    end
  end
end
