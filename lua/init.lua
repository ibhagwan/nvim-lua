vim.o.mouse             = ''        -- disable the mouse
vim.o.exrc              = false     -- ignore '~/.exrc'
vim.o.secure            = true
vim.o.modelines         = 1         -- read a modeline at EOF
vim.o.errorbells        = false     -- disable error bells (no beep/flash)
vim.o.termguicolors     = true      -- enable 24bit colors

vim.o.updatetime        = 250       -- decrease update time
vim.o.autoread          = true      -- auto read file if changed outside of vim
vim.o.fileformat        = 'unix'    -- <nl> for EOL
vim.o.switchbuf         = 'useopen'
vim.o.encoding          = 'utf-8'
vim.o.fileencoding      = 'utf-8'
vim.o.backspace         = 'indent,eol,start'

-- recursive :find in current dir
vim.cmd[[set path=.,,,$PWD/**]]

-- vim clipboard copies to system clipboard
-- unnamed     = use the " register (cmd-s paste in our term)
-- unnamedplus = use the + register (cmd-v paste in our term)
vim.o.clipboard         = 'unnamedplus'

vim.o.showmode          = true      -- show current mode (insert, etc) under the cmdline
vim.o.showcmd           = true      -- show current command under the cmd line
vim.o.cmdheight         = 2         -- cmdline height
vim.o.laststatus        = 2         -- 2 = always show status line (filename, etc)
vim.o.scrolloff         = 3         -- min number of lines to keep between cursor and screen edge
vim.o.sidescrolloff     = 5         -- min number of cols to keep between cursor and screen edge
vim.o.textwidth         = 78        -- max inserted text width for paste operations
vim.o.linespace         = 0         -- font spacing
vim.o.ruler             = true      -- show line,col at the cursor pos
vim.o.number            = true      -- show absolute line no. at the cursor pos
vim.o.relativenumber    = true      -- otherwise, show relative numbers in the ruler
vim.o.cursorline        = true      -- Show a line where the current cursor is
vim.wo.signcolumn       = 'yes'     -- Show sign column as first column
vim.g.colorcolumn       = 81        -- mark column 81
vim.o.colorcolumn       = string.format(vim.g.colorcolumn)
vim.o.wrap              = true      -- wrap long lines
vim.o.breakindent       = true      -- start wrapped lines indented
vim.o.linebreak         = true      -- do not break words on line wrap

-- invisible characters to use on ':set list'
vim.opt.listchars = {
  tab       = '→ '  ,
  eol       = '↲'   ,
  nbsp      = '␣'   ,
  trail     = '•'   ,
  extends   = '⟩'   ,
  precedes  = '⟨'   ,
  space     = '␣'   ,
}
vim.o.showbreak = '↪ '
-- find out which char you want using the below
-- `xfd -fn -xos4-terminus-medium-r-normal--32-320-72-72-c-160-iso10646-1`
-- `xfd -fa "InputMono Nerd Font"`
-- special chars can be inputed in nvim with the sequence
-- `ctrl-v, u, xxxx` xxxx being the char hex code
-- 0x2587=▇
-- 0x2591=░
-- 0x2592=▒
-- 0x21bb=↻
-- 0x21b5=↵
-- 0x2192=→
--vim.o.listchars = 'tab:→ ,eol:↵,nbsp:▒,trail:•,extends:⟩,precedes:⟨,space:▇'
--vim.o.showbreak = '↻ '

-- show menu even for one item do not auto select/insert
vim.o.completeopt       = 'noinsert,menuone,noselect'
vim.o.wildmenu          = true
vim.o.wildmode          = 'longest:full,full'
vim.o.wildoptions       = 'pum'     -- Show completion items using the pop-up-menu (pum)
vim.o.pumblend          = 30        -- Give the pum some transparency

vim.o.joinspaces        = true      -- insert spaces after '.?!' when joining lines
vim.o.autoindent        = true      -- copy indent from current line on newline
vim.o.smartindent       = true          -- add <tab> depending on syntax (C/C++)
vim.o.startofline       = false     -- keep cursor column on navigation

vim.o.tabstop           = 4         -- Tab indentation levels every two columns
vim.o.softtabstop       = 4         -- Tab indentation when mixing tabs & spaces
vim.o.shiftwidth        = 4         -- Indent/outdent by two columns
vim.o.shiftround        = true      -- Always indent/outdent to nearest tabstop
vim.o.expandtab         = true      -- Convert all tabs that are typed into spaces
vim.o.smarttab          = true      -- Use shiftwidths at left margin, tabstops everywhere else

-- c: auto-wrap comments using textwidth
-- r: auto-insert the current comment leader after hitting <Enter>
-- o: auto-insert the current comment leader after hitting 'o' or 'O'
-- q: allow formatting comments with 'gq'
-- n: recognize numbered lists
-- 1: don't break a line after a one-letter word
-- j: remove comment leader when it makes sense
-- this gets overwritten by ftplugins (:verb set fo)
-- we use autocmd to remove 'o' in '/lua/autocmd.lua'
-- borrowed from tjdevries
vim.opt.formatoptions = vim.opt.formatoptions
  - "a" -- Auto formatting is BAD.
  - "t" -- Don't auto format my code. I got linters for that.
  + "c" -- In general, I like it when comments respect textwidth
  + "q" -- Allow formatting comments w/ gq
  - "o" -- O and o, don't continue comments
  + "r" -- But do continue when pressing enter.
  + "n" -- Indent past the formatlistpat, not underneath it.
  + "j" -- Auto-remove comments if possible.
  - "2" -- I'm not in gradeschool anymore

vim.o.splitbelow        = true      -- ':new' ':split' below current
vim.o.splitright        = true      -- ':vnew' ':vsplit' right of current

vim.o.foldenable        = true      -- enable folding
vim.o.foldlevelstart    = 10        -- open most folds by default
vim.o.foldnestmax       = 10        -- 10 nested fold max
vim.o.foldmethod        = 'indent'  -- fold based on indent level

vim.o.undofile          = false     -- no undo file
vim.o.hidden            = true      -- do not unload buffer when abandoned
vim.o.autochdir         = false     -- do not change dir when opening a file

vim.o.magic             = true      --  use 'magic' chars in search patterns
vim.o.hlsearch          = true      -- highlight all text matching current search pattern
vim.o.incsearch         = true      -- show search matches as you type
vim.o.ignorecase        = true      -- ignore case on search
vim.o.smartcase         = true      -- case sensitive when search includes uppercase
vim.o.showmatch         = true      -- highlight matching [{()}]
vim.o.inccommand        = 'nosplit' -- show search and replace in real time
vim.o.autoread          = true      -- reread a file if it's changed outside of vim
vim.o.wrapscan          = true      -- begin search from top of the file when nothng is found
vim.o.cpoptions         = vim.o.cpoptions .. 'x' -- stay at seach item when <esc>

vim.o.backup            = false     -- no backup file
vim.o.writebackup       = false     -- do not backup file before write
vim.o.swapfile          = false     -- no swap file

--[[
  ShDa (viminfo for vim): session data history
  --------------------------------------------
  ! - Save and restore global variables (their names should be without lowercase letter).
  ' - Specify the maximum number of marked files remembered. It also saves the jump list and the change list.
  < - Maximum of lines saved for each register. All the lines are saved if this is not included, <0 to disable pessistent registers.
  % - Save and restore the buffer list. You can specify the maximum number of buffer stored with a number.
  / or : - Number of search patterns and entries from the command-line history saved. vim.o.history is used if it’s not specified.
  f - Store file (uppercase) marks, use 'f0' to disable.
  s - Specify the maximum size of an item’s content in KiB (kilobyte).
      For the viminfo file, it only applies to register.
      For the shada file, it applies to all items except for the buffer list and header.
  h - Disable the effect of 'hlsearch' when loading the shada file.

  :oldfiles - all files with a mark in the shada file
  :rshada   - read the shada file (:rviminfo for vim)
  :wshada   - write the shada file (:wrviminfo for vim)
]]
vim.o.shada             = [[!,'100,<0,s100,h]]
vim.o.sessionoptions    = 'blank,buffers,curdir,folds,help,tabpages,winsize'
vim.o.diffopt           = 'internal,filler,algorithm:histogram,indent-heuristic'

--[[
-- Install neovim-nightly on mac:
❯ brew tap jason0x43/homebrew-neovim-nightly
❯ brew install --cask neovim-nightly
]]

-- MacOS clipboard
if require'utils'.is_darwin() then
  vim.g.clipboard = {
    name = "macOS-clipboard",
    copy = {
      ["+"] = "pbcopy",
      ["*"] = "pbcopy",
    },
    paste = {
      ["+"] = "pbpaste",
      ["*"] = "pbpaste",
    },
  }
end

if require'utils'.is_darwin() then
    vim.g.python3_host_prog       = '/usr/local/bin/python3'
else
    vim.g.python3_host_prog       = '/usr/bin/python3'
end

-- use ':grep' to send resulsts to quickfix
-- use ':lgrep' to send resulsts to loclist
if require'utils'.shell_type('rg') then
    vim.o.grepprg = 'rg --vimgrep --no-heading --smart-case --hidden'
    vim.o.grepformat = '%f:%l:%c:%m'
end

-- Disable providers we do not care a about
vim.g.loaded_python_provider  = 0
vim.g.loaded_ruby_provider    = 0
vim.g.loaded_perl_provider    = 0
vim.g.loaded_node_provider    = 0

-- Disable some in built plugins completely
local disabled_built_ins = {
  'netrw', 'netrwPlugin', 'netrwSettings', 'netrwFileHandlers',
  'gzip', 'zip', 'zipPlugin', 'tar', 'tarPlugin', -- 'man',
  'getscript', 'getscriptPlugin','vimball', 'vimballPlugin',
  '2html_plugin', 'logipat', 'rrhelper', 'spellfile_plugin',
  -- 'matchit', 'matchparen', 'shada_plugin',
}
for _, plugin in pairs(disabled_built_ins) do
  vim.g['loaded_' .. plugin] = 1
end

vim.g.markdown_fenced_languages = {
  'vim',
  'lua',
  'cpp',
  'sql',
  'python',
  'bash=sh',
  'console=sh',
  'javascript',
  'typescript',
  'js=javascript',
  'ts=typescript',
  'yaml',
  'json',
}

-- Map leader to <space>
-- vim.api.nvim_set_keymap('', '<Space>', '<Nop>', { noremap = true, silent=true})
vim.g.mapleader      = ' '
vim.g.maplocalleader = ' '

-- We do this to prevent the loading of the system fzf.vim plugin. This is
-- present at least on Arch/Manjaro/Void
vim.api.nvim_command('set rtp-=/usr/share/vim/vimfiles')

require 'plugins'
require 'autocmd'
require 'keymaps'
require 'lsp'

-- set colorscheme to modified embark
-- https://github.com/embark-theme/vim
pcall(vim.cmd, [[colorscheme embark]])
