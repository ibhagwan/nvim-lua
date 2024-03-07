local M = {
  "tpope/vim-fugitive",
  cmd = { "Git", "Yit", "Gread", "Gwrite", "Gvdiffsplit", "Gdiffsplit" },
}

M.init = function()
  local map = vim.keymap.set

  -- :Gedit will always send us back to the working copy
  -- and thus serves as a quasi back button
  map("n", "<leader>gg", "<Esc>:Git<CR>", { silent = true, desc = "Git" })
  map("n", "<leader>gr", "<Esc>:Gread<CR>", { silent = true, desc = "Gread (reset)" })
  map("n", "<leader>gw", "<Esc>:Gwrite<CR>", { silent = true, desc = "Gwrite (stage)" })
  -- map("n", "<leader>gb", "<Esc>:Git blame<CR>", { silent = true, desc = "git blame" })
  -- map('n', '<leader>gc', '<Esc>:Git commit<CR>', { silent = true })
  -- map("n", "<leader>gD", "<Esc>:Git diff<CR>", { silent = true, desc = "Git diff (project)" })
  map("n", "<leader>gD", "<Esc>:Gvdiffsplit!<CR>", { silent = true, desc = "Git diff (buffer)" })
  map("n", "<leader>gp", "<Esc>:Git push<CR>", { silent = true, desc = "Git push" })
  map("n", "<leader>gP", "<Esc>:Git pull<CR>", { silent = true, desc = "Git pull" })
  map("n", "<leader>g+", "<Esc>:Git stash push<CR>", { silent = true, desc = "Git stash push" })
  map("n", "<leader>g-", "<Esc>:Git stash pop<CR>", { silent = true, desc = "Git stash pop" })
  map("n", "<leader>gl", "<Esc>:Git log --stat %<CR>", { silent = true, desc = "Git log (buffer)" })
  map("n", "<leader>gL", "<Esc>:Git log --stat -n 100<CR>",
    { silent = true, desc = "Git log (project)" })
end

M.config = function()
  -- fugitive shortcuts for yadm
  -- local yadm_repo = "$YADM_REPO"
  -- hack fugitive's worktree by using a symbolic link at $HOME
  local yadm_repo = "$HOME/.git"

  -- auto-complete for our custom fugitive Yadm command
  -- https://github.com/tpope/vim-fugitive/issues/1981#issuecomment-1113825991
  vim.cmd(([[
    function! YadmComplete(A, L, P) abort
      return fugitive#Complete(a:A, a:L, a:P, {'git_dir': expand("%s")})
    endfunction
  ]]):format(yadm_repo))

  vim.cmd((
    [[command! -bang -nargs=? -range=-1 -complete=customlist,YadmComplete Yadm exe fugitive#Command(<line1>, <count>, +"<range>", <bang>0, "<mods>", <q-args>, { 'git_dir': expand("%s") })]]
  ):format(yadm_repo))

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
  fugitive_command("?", "Yit", "Git", "YadmComplete")
  fugitive_command("*", "Yread", "Gread", "fugitive#ReadComplete")
  fugitive_command("*", "Yedit", "Gedit", "fugitive#EditComplete")
  fugitive_command("*", "Ywrite", "Gwrite", "fugitive#EditComplete")
  fugitive_command("*", "Ydiffsplit", "Gdiffsplit", "fugitive#EditComplete")
  fugitive_command("*", "Yhdiffsplit", "Ghdiffsplit", "fugitive#EditComplete")
  fugitive_command("*", "Yvdiffsplit", "Gvdiffsplit", "fugitive#EditComplete")
  fugitive_command(1, "YMove", "GMove", "fugitive#CompleteObject")
  fugitive_command(1, "YRename", "GRename", "fugitive#RenameComplete")
  fugitive_command(0, "YRemove", "GRemove")
  fugitive_command(0, "YUnlink", "GUnlink")
  fugitive_command(0, "YDelete", "GDelete")
end

return M
