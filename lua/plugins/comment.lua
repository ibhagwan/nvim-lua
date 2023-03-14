local M = {
  "numToStr/Comment.nvim",
  event = "VeryLazy",
  -- TODO: doesn't work in visual mode
  -- keys = { "gc", "gb" },
}

M.config = function()
  require("Comment").setup({
    padding = true,     -- Add a space b/w comment and the line
    sticky = true,      -- Whether the cursor should stay at its position
    mappings = {
      basic = true,     -- Includes `gcc`, `gbc`, `gc[count]{motion}` and `gb[count]{motion}`
      extra = true,     -- Includes `gco`, `gcO`, `gcA`
      extended = false, -- Includes `g>`, `g<`, `g>[count]{motion}` and `g<[count]{motion}`
    },
    toggler = {
      line = "gcc",  -- Line-comment toggle keymap
      block = "gbc", -- Block-comment toggle keymap
    },
    opleader = {
      line = "gc",  -- Line-comment keymap
      block = "gb", -- Block-comment keymap
    },
  })
end

return M
