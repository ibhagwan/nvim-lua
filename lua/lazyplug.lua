-- bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  print("Downloading folke/lazy.nvim...")
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "--single-branch",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  })
  print("Succesfully downloaded lazy.nvim.")
end
vim.opt.runtimepath:prepend(lazypath)

local ok, lazy = pcall(require, "lazy")
if not ok then
  require "utils".error("Error downloading lazy.nvim")
  return
end

lazy.setup("plugins", {
  defaults = { lazy = true },
  dev = {
    path = "~/Sources/nvim",
    -- this is a blanket dev for all matching plugins since it
    -- doesn't check for the existence of the directory we now
    -- use the 'dev' property individually instead
    -- patterns = { "ibhagwan" },
  },
  install = { colorscheme = { "nightfly", "lua-embark" } },
  checker = { enabled = false },          -- don't auto-check for plugin updates
  change_detection = { enabled = false }, -- don't auto-check for config updates
  ui = {
    backdrop = 101,
    border = "rounded",
    custom_keys = {
      ["<localleader>l"] = false,
      ["<localleader>t"] = false,
    },
  },
  debug = false,
})
