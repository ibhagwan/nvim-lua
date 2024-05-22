local M = {
  "L3MON4D3/LuaSnip",
  enabled = not vim.snippet,
}

M.config = function()
  local luasnip = require("luasnip")
  local map = vim.keymap.set

  map({ "i", "s" }, "<C-j>", function(fallback)
    if luasnip.jumpable(-1) then
      luasnip.jump(-1)
    else
      fallback()
    end
  end)

  map({ "i", "s" }, "<C-k>", function(fallback)
    if luasnip.jumpable(1) then
      luasnip.jump(1)
    else
      fallback()
    end
  end)

  map({ "i", "s" }, "<C-l>", function(fallback)
    if luasnip.choice_active() then
      luasnip.change_choice(1)
    else
      fallback()
    end
  end)
end

return M
