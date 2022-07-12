local res, comment = pcall(require, "Comment")
if not res then
  return
end

comment.setup({

    padding = true,       -- Add a space b/w comment and the line
    sticky = true,        -- Whether the cursor should stay at its position

    -- We define all mappings manually to support neovim < 0.7
    mappings = {
        basic = false,    -- Includes `gcc`, `gbc`, `gc[count]{motion}` and `gb[count]{motion}`
        extra = false,    -- Includes `gco`, `gcO`, `gcA`
        extended = false, -- Includes `g>`, `g<`, `g>[count]{motion}` and `g<[count]{motion}`
    },
})

local map = vim.keymap.set
local remap = { remap = true }

-- NORMAL mode line-wise mappings
map('n', 'gcc',
  [[v:count == 0 ? '<CMD>lua require("Comment.api").call("toggle_current_linewise_op")<CR>g@$' : '<CMD>lua require("Comment.api").call("toggle_linewise_count_op")<CR>g@$']],
  { expr = true, silent = true })

map('n', 'gbc',
  [[v:count == 0 ? '<CMD>lua require("Comment.api").call("toggle_current_blockwise_op")<CR>g@$' : '<CMD>lua require("Comment.api").call("toggle_blockwise_count_op")<CR>g@$']],
  { expr = true, silent = true })

-- Toggle in NORMAL Op-pending mode
map('n', 'gc', '<CMD>lua require("Comment.api").call("toggle_linewise_op")<CR>g@', remap)
map('n', 'gb', '<CMD>lua require("Comment.api").call("toggle_blockwise_op")<CR>g@', remap)

-- Toggle in VISUAL mode
map('x', 'gl', '<ESC><CMD>lua require("Comment.api").locked.toggle_linewise_op(vim.fn.visualmode())<CR>', remap)
map('x', 'gc', '<ESC><CMD>lua require("Comment.api").locked.toggle_blockwise_op(vim.fn.visualmode())<CR>', remap)
