<div align="center">

![Neovim version](https://img.shields.io/badge/Neovim-0.11-57A143?style=flat-square&logo=neovim)

</div>

![screenshot](https://github.com/ibhagwan/nvim-lua/raw/main/screenshot.png)

## What's in this repo?

**My personal neovim lua config (requires neovim >= `0.11`)**

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
  the clipboard when you really mean it (written by me)!

- [mini.surround](https://github.com/nvim-mini/mini.nvim): adds the missing
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

- [blink.cmp](https://github.com/Saghen/blink.cmp): autocompletion framework

- [treesitter](https://github.com/nvim-treesitter/nvim-treesitter): text
  parsing library, provides better syntax highlighting and text-objects for
  different coding languages (e.g. `yaf` yank-a-function), see
  [treesitter.lua](https://github.com/ibhagwan/nvim-lua/blob/main/lua/plugins/treesitter.lua)
  for defined text objects

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

- [snacks.nvim](https://github.com/folke/snacks.nvim): amazing set of plugins
  from the great @folke, image previews using the kitty protocol, picker to rival
  no less than our own fzf-lua :-)

- [oil.nvim](https://github.com/stevearc/oil.nvim): file explorer as a neovim
  buffer which also replaces netrw

### Misc

- [mini.nvim](https://github.com/nvim-mini/mini.nvim): a must have plugin from
  the great @echasnovski, used for statusline, indent lines, surround and much more

- [which-key](https://github.com/folke/which-key.nvim): a must plugin in every
  setup, when leader key (and some built-ins) sequence is pressed and times out
  which-key will generate a help window with your keybinds and also let you
  continue the sequence at your own pace

- [previm](https://github.com/previm/previm): live preview markdown files in
  the browser with `<space>r`

- [render-markdown.nvim](https://github.com/MeanderingProgrammer/render-markdown.nvim):
  magical plugin rendering markdown files inside neovim

