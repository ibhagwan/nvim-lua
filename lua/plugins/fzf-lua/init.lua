local M = {
  "ibhagwan/fzf-lua",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  dev = require("utils").is_dev("fzf-lua"),
  cmd = { "FzfLua", "TogglePickers" },
}

function M.init()
  require("plugins.fzf-lua.mappings").map()
end

function M.config()
  -- Lazy load nvim-treesitter or help files err with:
  --   Query error at 2:4. Invalid node type "delimiter"
  -- This is due to fzf-lua calling `vim.treesitter.language.add`
  -- before nvim-treesitter is loaded
  pcall(require, "nvim-treesitter")
  require("plugins.fzf-lua.setup").setup()

  vim.api.nvim_create_user_command("TogglePickers", function()
    local utils = require("utils")
    utils.USE_SNACKS = not utils.USE_SNACKS
    utils.info(string.format("Main picker set to %s", utils.USE_SNACKS and "Snacks" or "FzfLua"))
    require("plugins.fzf-lua.mappings").map()
    require("plugins.snacks.mappings").map()
  end, {})
end

return M
