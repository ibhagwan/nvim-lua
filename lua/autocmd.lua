local au = require('au')

au.group('HighlightYankedText', function(g)
  -- highlight yanked text and copy to system clipboard
  g.TextYankPost = {
    '*',
    "if has('clipboard') && len(@0)>0 | let @+=@0 | endif | lua vim.highlight.on_yank{higroup='IncSearch', timeout=2000}"
  }
end)

-- disable mini.indentscope for certain filetype|buftype
au.group('MiniIndentscopeDisable', function(g)
  g.BufEnter = { '*', "if index(['fzf', 'help'], &ft) >= 0 "
    .. "|| index(['nofile', 'terminal'], &bt) >= 0 "
    .. "| let b:miniindentscope_disable=v:true | endif" }
end)

au.group('NewlineNoAutoComments', function(g)
  g.BufEnter = { '*', "setlocal formatoptions-=o" }
end)

au.group('TermOptions', function(g)
  g.TermOpen = { '*', 'setlocal listchars= nonumber norelativenumber' }
end)

au.group('ResizeWindows', function(g)
  g.VimResized = { '*', 'tabdo wincmd =' }
end)

au.group('ToggleColorcolumn', {
  {
    'VimResized,WinEnter,BufWinEnter', '*',
    'lua require"utils".toggle_colorcolumn()',
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
    'require("plugins").compile()',
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
      -- do nothing for floating windows or if this is
      -- the fzf-lua minimized help window (height=1)
      local cfg = vim.api.nvim_win_get_config(0)
      if cfg and (cfg.external or cfg.relative and #cfg.relative>0)
        or vim.api.nvim_win_get_height(0) == 1 then
        return
      end
      -- do not run if Diffview is open
      if vim.g.diffview_nvim_loaded and
        require'diffview.lib'.get_current_view() then
        return
      end
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
