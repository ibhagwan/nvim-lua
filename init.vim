if !has('nvim-0.5')
  echohl Error
  echomsg "nvim-lua requires neovim > v0.5, no config will be loaded"
  echohl clear
  " set rtp-=~/.local/share/nvim/site
  " set rtp-=~/.local/share/nvim/site/after
  " do not load any plugins, equivalent to '--noplugin'
  set nolpl
  " use our embark color scheme
  set termguicolors
  colorscheme embark
  " no further configuration
  finish
end

" source our 'init.lua'
" https://github.com/nanotee/nvim-lua-guide#sourcing-a-lua-file-vs-calling-require
" luafile $XDG_CONFIG_HOME/nvim/lua/init.lua
lua require'init'
