# My nvim-lua setup

![screenshot](https://github.com/ibhagwan/nvim-lua/raw/main/screenshot.png)

## fzf-lua update, 2021-07-14

**Shameless plug, I wrote my own fzf plugin in pure lua, I removed the
leftover fzf vim files and now proudly using 
[fzf-lua](https://github.com/ibhagwan/fzf-lua)!**


## What's in this repo?

**Yet another nvim-as-IDE setup in lua for the [0.5
release](https://github.com/neovim/neovim/releases/tag/v0.5.0)**

- Minimum changes to default key mapping
- A good selection of carefully hand-picked plugins
- Lazy load plugins where possible
- Which-key to rule them all
- Misc utilities and goodies

## Plugins

- [packer.nvim](https://github.com/wbthomason/packer.nvim): lua plugin
  manager to auto-install and update our plugins

### Tpope goodness

- [vim-surround](https://github.com/tpope/vim-surround): adds the missing
  motions (`ds`, `cs`, `ys`) for dealing with pairs of "surroundings" (quotes,
  tags, etc)

- [vim-repeat](https://github.com/tpope/vim-repeat): make the surround motions
  repeatable with `.`

### Git

- [vim-fugitive](https://github.com/tpope/vim-fugitive): git porcelain and
  plumbing in one by tpope, the Swiss army knife of git, no other git plugin comes
  close

- [diffview](https://github.com/sindrets/diffview.nvim): review all project
  changes before a commit or review changes from a previous commit

- [gitsigns](https://github.com/lewis6991/gitsigns.nvim): git gutter indicators
  and hunk management

### Coding, completion & LSP

- [commented.nvim](https://github.com/winston0410/commented.nvim): use `gc` and
  `gcc` to comment visual-blocks and lines

- [indent-blankline](https://github.com/lukas-reineke/indent-blankline.nvim):
  add indentation markers based on `tabstop | shiftwidth`

- [nvim-compe](https://github.com/hrsh7th/nvim-compe): autocompletion
  framework

- [treesitter](https://github.com/nvim-treesitter/nvim-treesitter): text
  parsing library, provides better syntax highlighting and text-objects for
  different coding languages (e.g. `yaf` yank-a-function), see
  [treesitter.lua](https://github.com/ibhagwan/nvim-lua/blob/main/lua/plugin/treesitter.lua)
  for defined text objects

- [lspconfig](https://github.com/neovim/nvim-lspconfig): configuration
  quickstart for nvim's built in LSP

- [lsp_signature](https://github.com/ray-x/lsp_signature.nvim): show function
  signature help as you type

- [nvim-lspinstall](https://github.com/kabouzeid/nvim-lspinstall): automatic
  installation of LSP servers using the `:LspInstall` command

### Fuzzy search & file exploration

- [nvim-tree](https://github.com/kyazdani42/nvim-tree.lua): file-explorer tree

- [fzf-lua](https://github.com/ibhagwan/fzf-lua): the original, tried and
  tested fuzzy finder in a lua plugin written by me

- [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim): fuzzy
  search framework for searching project files, buffers, live grep (`rg`), and
  much more

- [nvim-bqf](https://github.com/kevinhwang91/nvim-bqf): better quickfix and
  location list, provides quickfix previews, history and fuzzy search, great
  companion for both telescope and fzf after sending search results to a list

### Misc

- [which-key](https://github.com/folke/which-key.nvim): a must plugin in every
  setup, when leader key (and some built-ins) sequence is pressed and times out
  which-key will generate a help window with your keybinds and also let you
  continue the sequence at your own pace

- [neoterm](https://github.com/kassio/neoterm): better term and REPLs (use
  `gx` and `gxx` to send REPLs to an interpreter)

- [oscyank](https://github.com/ojroques/vim-oscyank): copy text over ssh
  terminals using `OSC52`

- [suda](https://github.com/lambdalisue/suda.vim): elevate permissions on save
  when needed

- [nvim-reload](https://github.com/famiu/nvim-reload): properly reload your
  nvim configuration and lua modules with `<space>R`

- [previm](https://github.com/previm/previm): live preview markdown files in
  the browser with `<space>M`

### Appearence

- [feline.nvim](https://github.com/famiu/feline.nvim): a fancy statusline

- [nvcode-color-schemes](https://github.com/christianchiarulli/nvcode-color-schemes.vim):
  a collection of treesitter compatible color schemes

- [nvim-colorizer.lua](https://github.com/norcalli/nvim-colorizer.lua): color
  code highlighter, use `ColorizerAttachToBuffer` to provide a live preview of
  color codes in your buffer (e.g. `#d4bfff`)
