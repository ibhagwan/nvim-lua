local M = {
  "ibhagwan/fzf-lua",
  dev = require("utils").is_dev("fzf-lua"),
  cmd = "FzfLua",
}

function M.init()
  require("plugins.fzf-lua.mappings")
end

function M.config()
  -- Lazy load nvim-treesitter or help files err with:
  --   Query error at 2:4. Invalid node type "delimiter"
  -- This is due to fzf-lua calling `vim.treesitter.language.add`
  -- before nvim-treesitter is loaded
  pcall(require, "nvim-treesitter")

  require("plugins.fzf-lua.cmds")
  require("plugins.fzf-lua.setup").setup()

  -- register fzf-lua as vim.ui.select interface
  require("fzf-lua").register_ui_select(function(_, items)
    local min_h, max_h = 0.15, 0.70
    local h = (#items + 4) / vim.o.lines
    if h < min_h then
      h = min_h
    elseif h > max_h then
      h = max_h
    end
    return { winopts = { height = h, width = 0.60, row = 0.40 } }
  end)
end

return M
