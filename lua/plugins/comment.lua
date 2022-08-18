local res, comment = pcall(require, "Comment")
if not res then
  return
end

comment.setup({

    padding = true,       -- Add a space b/w comment and the line
    sticky = true,        -- Whether the cursor should stay at its position

    mappings = {
        basic = true,     -- Includes `gcc`, `gbc`, `gc[count]{motion}` and `gb[count]{motion}`
        extra = true,     -- Includes `gco`, `gcO`, `gcA`
        extended = false, -- Includes `g>`, `g<`, `g>[count]{motion}` and `g<[count]{motion}`
    },

    toggler = {
        line = 'gcc',     -- Line-comment toggle keymap
        block = 'gbc',    -- Block-comment toggle keymap
    },

    opleader = {
        line = 'gl',      -- Line-comment keymap
        block = 'gc',     -- Block-comment keymap
    },
})
