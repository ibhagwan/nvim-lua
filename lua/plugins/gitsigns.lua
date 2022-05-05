local res, gitsigns = pcall(require, "gitsigns")
if not res then
  return
end

gitsigns.setup {
  signs = {
    add          = {hl = 'GitSignsAdd'   , text = '┃', numhl='GitSignsAddNr'   , linehl='GitSignsAddLn'},
    change       = {hl = 'GitSignsChange', text = '┃', numhl='GitSignsChangeNr', linehl='GitSignsChangeLn'},
    delete       = {hl = 'GitSignsDelete', text = '_', numhl='GitSignsDeleteNr', linehl='GitSignsDeleteLn'},
    topdelete    = {hl = 'GitSignsDelete', text = '‾', numhl='GitSignsDeleteNr', linehl='GitSignsDeleteLn'},
    changedelete = {hl = 'GitSignsChange', text = '~', numhl='GitSignsChangeNr', linehl='GitSignsChangeLn'},
  },
  numhl = false,
  linehl = false,
  watch_gitdir = { interval = 1000 },
  current_line_blame = false,
  current_line_blame_opts = { delay = 1000, virt_text_pos = 'eol' },
  preview_config = { border = 'rounded' },
  diff_opts = { internal = true, },
  yadm = { enable = true, },
  on_attach = function(bufnr)
    local map = require'utils'.remap
    local opts = { noremap = true, buffer = bufnr }
    local opts_expr = { noremap = true, buffer = bufnr, expr = true }

    -- creates too many lua func references as
    -- this is called for every bufer attach
    -- local gs = package.loaded.gitsigns
    -- map('n', ']c', function()
    --   if vim.wo.diff then vim.api.nvim_feedkeys(']c', 'n', true) end
    --   vim.schedule(function() gs.next_hunk() end)
    -- end, opts)
    --
    -- map('n', '[c', function()
    --   if vim.wo.diff then vim.api.nvim_feedkeys('[c', 'n', true) end
    --   vim.schedule(function() gs.prev_hunk() end)
    -- end, opts)

    map('n', '[c', "&diff ? '[c' : '<cmd>lua package.loaded.gitsigns.prev_hunk()<CR>'", opts_expr)
    map('n', ']c', "&diff ? ']c' : '<cmd>lua package.loaded.gitsigns.next_hunk()<CR>'", opts_expr)

    -- Actions
    map({'n', 'v'}, '<leader>hs', '<cmd>lua require("gitsigns").stage_hunk()<CR>', opts)
    map({'n', 'v'}, '<leader>hr', '<cmd>lua require("gitsigns").reset_hunk()<CR>', opts)
    map('n', '<leader>hS', '<cmd>lua require("gitsigns").stage_buffer()<CR>', opts)
    map('n', '<leader>hu', '<cmd>lua require("gitsigns").undo_stage_hunk()<CR>', opts)
    -- doesn't exist yet
    -- map('n', '<leader>hU', '<cmd>lua require("gitsigns").undo_stage_buffer()<CR>', opts)
    map('n', '<leader>hR', '<cmd>lua require("gitsigns").reset_buffer()<CR>', opts)
    map('n', '<leader>hp', '<cmd>lua require("gitsigns").preview_hunk()<CR>', opts)
    map('n', '<leader>hb', '<cmd>lua require("gitsigns").blame_line({full=true})<CR>', opts)
    map('n', '<leader>hB', '<cmd>lua require("gitsigns").toggle_current_line_blame()<CR>', opts)
    map('n', '<leader>hd', '<cmd>lua require("gitsigns").diffthis()<CR>', opts)
    map('n', '<leader>hD', '<cmd>lua require("gitsigns").diffthis("~")<CR>', opts)
    map('n', '<leader>hx', '<cmd>lua require("gitsigns").toggle_deleted()<CR>', opts)

    -- Text object
    map({'o', 'x'}, 'ih', ':<C-U>Gitsigns select_hunk<CR>', opts)
  end
}
