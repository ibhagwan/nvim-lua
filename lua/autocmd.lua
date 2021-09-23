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

au.group('Solidity', {
  { 'BufRead,BufNewFile', '*.sol', 'set filetype=solidity' }
})
