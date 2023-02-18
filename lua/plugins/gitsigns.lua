local M = {
  "lewis6991/gitsigns.nvim",
  -- "VeryLazy" hides splash screen
  event = "BufReadPre",
}

M.config = function()
  require("gitsigns").setup {
    signs          = {
      add          = { text = "┃" },
      change       = { text = "┃" },
      delete       = { text = "_" },
      topdelete    = { text = "‾" },
      changedelete = { text = "~" },
      untracked    = { text = "┆" },
    },
    signcolumn     = true, -- Toggle with `:Gitsigns toggle_signs`
    numhl          = false, -- Toggle with `:Gitsigns toggle_numhl`
    linehl         = false, -- Toggle with `:Gitsigns toggle_linehl`
    word_diff      = false, -- Toggle with `:Gitsigns toggle_word_diff`
    sign_priority  = 4, -- Lower priorirty means diag signs supercede
    preview_config = { border = "rounded" },
    yadm           = { enable = true, },
    on_attach      = function(bufnr)
      local gs = package.loaded.gitsigns

      local function map(mode, l, r, opts)
        opts = opts or {}
        opts.buffer = bufnr
        vim.keymap.set(mode, l, r, opts)
      end

      map("n", "]c", function()
        if vim.wo.diff then return "]c" end
        vim.schedule(function() gs.next_hunk() end)
        return "<Ignore>"
      end, { expr = true, desc = "Next hunk" })

      map("n", "[c", function()
        if vim.wo.diff then return "[c" end
        vim.schedule(function() gs.prev_hunk() end)
        return "<Ignore>"
      end, { expr = true, desc = "Previous hunk" })

      -- Actions
      map({ "n", "v" }, "<leader>hr", '<cmd>lua require("gitsigns").reset_hunk()<CR>',
        { desc = "reset hunk" })
      map("n", "<leader>hS", '<cmd>lua require("gitsigns").stage_buffer()<CR>',
        { desc = "stage buffer" })
      map({ "n", "v" }, "<leader>hs", '<cmd>lua require("gitsigns").stage_hunk()<CR>',
        { desc = "stage hunk" })
      map("n", "<leader>hu", '<cmd>lua require("gitsigns").undo_stage_hunk()<CR>',
        { desc = "undo stage hunk" })
      -- doesn't exist yet
      -- map('n', '<leader>hU', '<cmd>lua require("gitsigns").undo_stage_buffer()<CR>')
      map("n", "<leader>hR", '<cmd>lua require("gitsigns").reset_buffer()<CR>',
        { desc = "reset buffer" })
      map("n", "<leader>hp", '<cmd>lua require("gitsigns").preview_hunk()<CR>',
        { desc = "preview hunk" })
      map("n", "<leader>hb", '<cmd>lua require("gitsigns").blame_line({full=true})<CR>',
        { desc = "line blame (popup)" })
      map("n", "<leader>hB", '<cmd>lua require("gitsigns").toggle_current_line_blame()<CR>',
        { desc = "line blame (toggle)" })
      map("n", "<leader>hd", '<cmd>lua require("gitsigns").diffthis()<CR>',
        { desc = "diff against the index" })
      map("n", "<leader>hD", '<cmd>lua require("gitsigns").diffthis("~1")<CR>',
        { desc = "diff against previous commit" })
      map("n", "<leader>hx", '<cmd>lua require("gitsigns").toggle_deleted()<CR>',
        { desc = "toggle deleted lines" })

      -- Text object
      map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>")
    end
  }
end

return M
