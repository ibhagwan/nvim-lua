local au = require('au')

au.group('HighlightYankedText', function(g)
  g.TextYankPost = {
    '*',
    function()
      vim.highlight.on_yank{higroup='IncSearch', timeout=2000}
    end
  }
end)

au.group('NewlineNoAutoComments', function(g)
  g.BufEnter = { '*', "setlocal formatoptions-=o" }
end)

au.group('TermOptions', function(g)
    -- conflicts with neoterm
    -- g.TermOpen = { '*', 'startinsert' },
    g.TermOpen = { '*', 'setlocal listchars= nonumber norelativenumber' }
end)

au.group('ResizeWindows', function(g)
    g.VimResized = { '*', 'tabdo wincmd =' }
end)

au.group('ToggleColorcolumn', {
  {
    'VimResized,WinEnter,BufWinEnter', '*',
    function()
      require'utils'.toggle_colorcolumn()
    end,
  }
})

au.group('ToggleSearchHL', function(g)
  g.InsertEnter = { '*', ':nohl | redraw' }
end)

au.group('ActiveWinCursorLine', {
  -- Highlight current line only on focused window
  {'WinEnter,BufEnter,InsertLeave', '*', 'if ! &cursorline && ! &pvw | setlocal cursorline | endif'};
  {'WinLeave,BufLeave,InsertEnter', '*', 'if &cursorline && ! &pvw | setlocal nocursorline | endif'};
})

au.group('PackerCompile', function(g)
  g.BufWritePost = {
    'packer_init.lua',
    function()
      require('plugins').compile()
    end
  }
end)

-- auto-delete fugitive buffers
au.group('Fugitive', {
  { 'BufReadPost,', 'fugitive://*', 'set bufhidden=delete' }
})

au.group('Solidity', {
  { 'BufRead,BufNewFile', '*.sol', 'set filetype=solidity' }
})

-- Display help|man in vertical splits
au.group('Help', function(g)
  g.FileType = { 'help,man',
    function()
      -- do nothing for floating windows
      local cfg = vim.api.nvim_win_get_config(0)
      if cfg and (cfg.external or cfg.relative and #cfg.relative>0) then
        return
      end
      -- do not run if Diffview is open
      if vim.g.diffview_nvim_loaded and
        require'diffview.lib'.get_current_view() then
        return
      end
      -- local var = vim.bo.filetype .. "_init"
      -- local ok, is_init = pcall(vim.api.nvim_buf_get_var, 0, var)
      -- if ok and is_init == true then return end
      -- vim.api.nvim_buf_set_var(0, var, true)
      local width = math.floor(vim.o.columns*0.75)
      vim.cmd("wincmd L")
      vim.cmd("vertical resize " .. width)
    end
  }
  -- TODO:
  -- Why does setting this event ft to 'man' not work?
  -- but at the same time '*' works and shows 'man' for ft?
  g.BufHidden = { '*',
    function()
      if vim.bo.filetype == 'man' then
        local bufnr = vim.api.nvim_get_current_buf()
        vim.defer_fn(function()
          if vim.api.nvim_buf_is_valid(bufnr) then
            vim.api.nvim_buf_delete(bufnr, {force=true})
          end
        end, 0)
      end
    end }
end)
