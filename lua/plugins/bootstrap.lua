local fn = vim.fn
local utils = require'utils'

local compile_suffix = "/plugin/packer_compiled.lua"
local install_suffix = "/site/pack/packer/%s/packer.nvim"
local install_path = vim.fn.stdpath("data") .. string.format(install_suffix, "opt")
local compile_path = vim.fn.stdpath("data") .. compile_suffix
local is_installed = vim.loop.fs_stat(install_path) ~= nil
local res, packer

if is_installed then
  vim.cmd("packadd packer.nvim")
  res, packer = pcall(require, "packer")
end

if not res then
  if vim.fn.input("Install packer.nvim? (y for yes) ") == "y" then
    utils.info("Downloading packer.nvim...\n")
    fn.delete(install_path, "rf")
    fn.delete(compile_path, "rf")
    fn.system({
      "git",
      "clone",
      "https://github.com/wbthomason/packer.nvim",
      install_path,
    })

    vim.cmd("packadd packer.nvim")
    res, packer = pcall(require, "packer")

    if res then
      utils.info("Successfully installed packer.nvim.")
    else
      utils.err(("Error installing packer.nvim\nPath: %s"):format(install_path))
      return
    end
  end
end

if res and packer then
  packer.init({
    -- we don't want the compilation file in '~/.config/nvim'
    compile_path = compile_path
  })
  -- not sure why this doesn't get updated by 'packer.init()'
  packer.config.compile_path = compile_path
end

return res
