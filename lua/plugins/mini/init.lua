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
  vim.api.nvim_create_user_command("MiniHipatternsToggle", function()
    local hipatterns = require("mini.hipatterns")
    local hex_from_colormap = function()
      local colormap = vim.api.nvim_get_color_map()
      return function(_, match)
        match = #match > 0 and match:sub(1, 1):upper() .. match:sub(2) or match
        local col = colormap[match]
        if col == nil then return nil end
        return hipatterns.compute_hex_color_group(string.format("#%06x", col), "bg")
      end
    end
    if vim.b.minihipatterns_disable ~= false then
      vim.b.minihipatterns_disable = false
      hipatterns.enable(0, {
        highlighters = {
          hex_color = hipatterns.gen_highlighter.hex_color(),
          word_color = { pattern = "%w+", group = hex_from_colormap() },
        },
      })
    else
      hipatterns.disable(0)
      vim.b.minihipatterns_disable = true
    end
  end, {})
  -- require("mini.pairs").setup()
end

return M
