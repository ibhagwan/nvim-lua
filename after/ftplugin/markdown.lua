vim.bo.tabstop = 4
vim.wo.spell = true

-- Previm plugin
vim.keymap.set({ "n", "v" }, "<leader>r", function()
  vim.cmd [[call previm#open(previm#make_preview_file_path("index.html"))]]
end, { buffer = true, silent = true, desc = "open markdown preview (previm)" })

vim.api.nvim_create_autocmd(vim.g.previm_enable_realtime == 1
  and { "CursorHold", "CursorHoldI", "InsertLeave", "BufWritePost" }
  or { "BufWritePost" },
  {
    group = vim.api.nvim_create_augroup("ibhagwan/PrevimRefresh", { clear = true }),
    buffer = 0,
    desc = "Previm refresh",
    callback = function()
      vim.cmd [[call previm#refresh()]]
    end,
  })
