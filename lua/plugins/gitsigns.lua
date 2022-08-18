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
    local gs = package.loaded.gitsigns

    local function map(mode, l, r, opts)
      opts = opts or {}
      opts.buffer = bufnr
      vim.keymap.set(mode, l, r, opts)
    end

    map('n', ']c', function()
      if vim.wo.diff then return ']c' end
      vim.schedule(function() gs.next_hunk() end)
      return '<Ignore>'
    end, {expr=true, desc="Next hunk"})

    map('n', '[c', function()
      if vim.wo.diff then return '[c' end
      vim.schedule(function() gs.prev_hunk() end)
      return '<Ignore>'
    end, {expr=true, desc="Previous hunk"})

    -- Actions
    map({'n', 'v'}, '<leader>hs', '<cmd>lua require("gitsigns").stage_hunk()<CR>')
    map({'n', 'v'}, '<leader>hr', '<cmd>lua require("gitsigns").reset_hunk()<CR>')
    map('n', '<leader>hS', '<cmd>lua require("gitsigns").stage_buffer()<CR>')
    map('n', '<leader>hu', '<cmd>lua require("gitsigns").undo_stage_hunk()<CR>')
    -- doesn't exist yet
    -- map('n', '<leader>hU', '<cmd>lua require("gitsigns").undo_stage_buffer()<CR>')
    map('n', '<leader>hR', '<cmd>lua require("gitsigns").reset_buffer()<CR>')
    map('n', '<leader>hp', '<cmd>lua require("gitsigns").preview_hunk()<CR>')
    map('n', '<leader>hb', '<cmd>lua require("gitsigns").blame_line({full=true})<CR>')
    map('n', '<leader>hB', '<cmd>lua require("gitsigns").toggle_current_line_blame()<CR>')
    map('n', '<leader>hd', '<cmd>lua require("gitsigns").diffthis()<CR>')
    map('n', '<leader>hD', '<cmd>lua require("gitsigns").diffthis("~1")<CR>')
    map('n', '<leader>hx', '<cmd>lua require("gitsigns").toggle_deleted()<CR>')

    -- Text object
    map({'o', 'x'}, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
  end
}
