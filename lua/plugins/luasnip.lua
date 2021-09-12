local res, luasnip = pcall(require, "luasnip")
if not res then
  return
end

local remap = require'utils'.remap

remap({ "i", "s" }, "<C-j>", function(fallback)
  if luasnip.jumpable(-1) then
    luasnip.jump(-1)
  else
    fallback()
  end
end)

remap({ "i", "s" }, "<C-k>", function(fallback)
  if luasnip.jumpable(1) then
    luasnip.jump(1)
  else
    fallback()
  end
end)

remap({ "i", "s" }, "<C-l>", function(fallback)
  if luasnip.choice_active() then
    luasnip.change_choice(1)
  else
    fallback()
  end
end)
