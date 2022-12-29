local M = {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    { "nvim-telescope/telescope-fzy-native.nvim" },
  },
}

function M.init()
  require("plugins.telescope.mappings")
end

function M.config()
  require("plugins.telescope.cmds")
  require("plugins.telescope.setup").setup()
end

return M
