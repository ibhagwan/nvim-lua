local fn = vim.fn
local utils = require'utils'

local function packer_bootstrap(install_path, compile_path)

  if not install_path then
    local install_suffix = "/site/pack/packer/%s/packer.nvim"
    install_path = vim.fn.stdpath("data") .. string.format(install_suffix, "opt")
  end

  if not compile_path then
    local compile_suffix = "/plugin/packer_compiled.lua"
    compile_path = vim.fn.stdpath("data") .. compile_suffix
  end

  local res, packer
  local is_installed = vim.loop.fs_stat(install_path) ~= nil

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

  return res and packer or nil
end

return packer_bootstrap
