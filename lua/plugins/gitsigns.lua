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
    signcolumn     = true,  -- Toggle with `:Gitsigns toggle_signs`
    numhl          = false, -- Toggle with `:Gitsigns toggle_numhl`
    linehl         = false, -- Toggle with `:Gitsigns toggle_linehl`
    word_diff      = false, -- Toggle with `:Gitsigns toggle_word_diff`
    sign_priority  = 4,     -- Lower priorirty means diag signs supercede
    -- Use detached worktrees instead of `yadm`
    -- https://github.com/lewis6991/gitsigns.nvim/pull/600
    -- yadm           = { enable = not require("utils").IS_WINDOWS and true, },
    worktrees      = not require("utils").IS_WINDOWS and {
      {
        toplevel = vim.env.HOME,
        gitdir   = vim.env.HOME .. "/dots/.git"
      }
    } or nil,
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
      map("n", "<leader>hs", gs.stage_hunk, { desc = "Stage hunk" })
      map("n", "<leader>hr", gs.reset_hunk, { desc = "Reset hunk" })
      map("v", "<leader>hs", function() gs.stage_hunk { vim.fn.line("."), vim.fn.line("v") } end,
        { desc = "Stage hunk" })
      map("v", "<leader>hr", function() gs.reset_hunk { vim.fn.line("."), vim.fn.line("v") } end,
        { desc = "Reset hunk" })
      map("n", "<leader>hu", gs.undo_stage_hunk, { desc = "Undo stage hunk" })
      map("n", "<leader>hS", gs.stage_buffer, { desc = "Stage buffer" })
      map("n", "<leader>hR", gs.reset_buffer, { desc = "Reset buffer" })
      map("n", "<leader>hp", gs.preview_hunk_inline, { desc = "preview hunk (inline)" })
      map("n", "<leader>hP", gs.preview_hunk, { desc = "preview hunk (float)" })
      -- map gb, yb and hb to git blame
      for _, c in ipairs({ "g", "y", "h" }) do
        map("n", string.format("<leader>%sb", c),
          function() gs.blame_line({ full = true }) end, { desc = "Line blame (float)" })
      end
      map("n", "<leader>hB", gs.toggle_current_line_blame, { desc = "line blame (toggle)" })
      map("n", "<leader>hd", gs.diffthis, { desc = "diff against the index" })
      map("n", "<leader>hD", function() gs.diffthis("~1") end,
        { desc = "diff against previous commit" })
      map("n", "<leader>hx", gs.toggle_deleted, { desc = "toggle deleted lines" })

      -- Text object
      map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>")
    end
  }
end

return M
