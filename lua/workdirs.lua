return {
  vim.loop.cwd(),
  -- runtime path
  vim.opt.runtimepath._info.default:match("/[^,]+runtime"),
  '~/dots',
  '~/.config/nvim',
  '~/.config/zsh',
  '~/.config/awesome',
  '~/Sources/nvim/neovim',
  '~/Sources/nvim/fzf-lua',
  '~/Sources/nvim/fzf-lua.wiki',
  '~/Sources/nvim/nvim-lua',
  '~/Sources/nvim/nvim-fzf',
  '~/Sources/nvim/plenary.nvim',
  '~/Sources/nvim/telescope.nvim',
  '~/Sources/nvim/babelfish.nvim',
  vim.fn.stdpath("data") .. "/site/pack/packer",
}
