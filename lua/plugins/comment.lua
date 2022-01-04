local res, comment = pcall(require, "Comment")
if not res then
  return
end

comment.setup({

    padding = true,       -- Add a space b/w comment and the line
    sticky = true,        -- Whether the cursor should stay at its position

    -- NORMAL mode line-wise mappings
    toggler = {
        line = 'gcc',
        block = 'gbc',
    },

    -- NORMAL+VISUAL mode operator mappings
    opleader = {
        line = 'gl',
        block = 'gc',
    },

    extra = {
        above = 'gcO',    -- Add comment on the line above
        below = 'gco',    -- Add comment on the line below
        eol = 'gcA',      -- Add comment at the end of line
    },

    mappings = {
        basic = true,     -- Includes `gcc`, `gbc`, `gc[count]{motion}` and `gb[count]{motion}`
        extra = true,     -- Includes `gco`, `gcO`, `gcA`
        extended = false, -- Includes `g>`, `g<`, `g>[count]{motion}` and `g<[count]{motion}`
    },
})
