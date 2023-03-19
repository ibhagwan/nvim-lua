local M = {
  -- vim-surround/sandwich, lua version
  -- mini also has an indent highlighter
  "echasnovski/mini.nvim",
  -- not using "VeryLazy" event as it bugs out the splashscreen
  -- https://github.com/echasnovski/mini.nvim/issues/238
  event = { "BufReadPost", "InsertEnter" }
}

function M.config()
  require("plugins.mini.surround")
  require("plugins.mini.indentscope")
  require("mini.ai").setup()
  -- require("mini.pairs").setup()
end

return M
