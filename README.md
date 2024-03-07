# My nvim-lua setup

![screenshot](https://github.com/ibhagwan/nvim-lua/raw/main/screenshot.png)

## What's in this repo?

**My personal neovim lua config (requires neovim >= `0.8`)**

- Minimum changes to default key mapping
- A good selection of carefully hand-picked plugins
- Lazy load plugins where possible
- Which-key to rule them all
- Misc utilities and goodies

## Plugins & Packages

- [lazy.nvim](https://github.com/folke/lazy.nvim): lua plugin
  manager to auto-install and update our plugins

- [mason.nvim](https://github.com/williamboman/mason.nvim):
  automatic installation of LSP servers using the `:Mason` command

### Basics

- [smartyank.nvim](https://github.com/ibhagwan/smartyank.nvim): only pollute
  the clipboard when you really mean it!

- [mini.surround](https://github.com/echasnovski/mini.nvim): adds the missing
  operators (`ds`, `cs`, `ys`) for dealing with pairs of "surroundings"
  (quotes, tags, etc)

### Git

- [vim-fugitive](https://github.com/tpope/vim-fugitive): git porcelain and
  plumbing in one by tpope, the Swiss army knife of git

- [gitsigns](https://github.com/lewis6991/gitsigns.nvim): git gutter indicators
  and hunk management

- [diffview.nvim](https://github.com/sindrets/diffview.nvim): powerful git diff/merge
  tool (`<leader>gd|yd` to invoke for project|dotfiles)

### Coding, completion & LSP

- [Comment.nvim](https://github.com/numToStr/Comment.nvim): use `gc` and
  `gcc` to comment visual-blocks and lines

- [mini.indentscope](https://github.com/echasnovski/mini.nvim):
  add indentation markers based on `tabstop | shiftwidth`

- [nvim-cmp](https://github.com/hrsh7th/nvim-cmp): autocompletion framework

- [treesitter](https://github.com/nvim-treesitter/nvim-treesitter): text
  parsing library, provides better syntax highlighting and text-objects for
  different coding languages (e.g. `yaf` yank-a-function), see
  [treesitter.lua](https://github.com/ibhagwan/nvim-lua/blob/main/lua/plugins/treesitter.lua)
  for defined text objects

- [lspconfig](https://github.com/neovim/nvim-lspconfig): configuration
  quickstart for nvim's built in LSP

- [conform.nvim](https://github.com/stevearc/conform.nvim): formatter
  plugin where LSP formatting isn't what you need, format `js|json|html`
  with `prettier` or lua with `stylua` using the `gQ` mapping.
  
- [nvim-dap](https://github.com/mfussenegger/nvim-dap):
  set breakpoints and debug applications using Debug Adapter Protocol (DAP)

- [fidget.nvim](https://github.com/j-hui/fidget.nvim): Eye candy LSP progress
  indicator above the status line (top right)

### Fuzzy search & file exploration

- [fzf-lua](https://github.com/ibhagwan/fzf-lua): the original, tried and
  tested fuzzy finder, lua plugin that does pretty much everything, written by
  yours truly

- [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim): fuzzy
  search framework for searching project files, buffers, ripgrep and much more

- [nvim-tree](https://github.com/nvim-tree/nvim-tree.lua): file-explorer tree

### Misc

- [which-key](https://github.com/folke/which-key.nvim): a must plugin in every
  setup, when leader key (and some built-ins) sequence is pressed and times out
  which-key will generate a help window with your keybinds and also let you
  continue the sequence at your own pace

- [toggleterm.nvim](https://github.com/akinsho/toggleterm.nvim): better term and
  REPLs (use `gx` and `gxx` to send REPLs to an interpreter)

- [previm](https://github.com/previm/previm): live preview markdown files in
  the browser with `<space>r`

### Appearence

- [heirline.nvim](https://github.com/rebelot/heirline.nvim):
  DIY status line plugin, semi-minimalistic setup.

- [nvim-colorizer.lua](https://github.com/nvchad/nvim-colorizer.lua): color
  code highlighter, use `ColorizerAttachToBuffer` to provide a live preview of
  color codes in your buffer (e.g. `#d4bfff`)
