local utils = require("utils")

-- Helper function for hunk navigation
local set_hunk_navigation_keymaps = function(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  local gs = package.loaded.gitsigns
  if not gs then return end
  local codediff = package.loaded.codediff
  local lifecycle = codediff and assert(require("codediff.ui.lifecycle"))
  vim.keymap.set("n", "]c", function()
    if vim.wo.diff then
      vim.cmd.normal({ "]c", bang = true })
    elseif codediff and lifecycle.get_session(vim.api.nvim_get_current_tabpage()) then
      codediff.next_hunk()
    else
      gs.nav_hunk("next")
    end
  end, { buffer = bufnr, desc = "Next hunk" })
  vim.keymap.set("n", "[c", function()
    if vim.wo.diff then
      vim.cmd.normal({ "[c", bang = true })
    elseif codediff and lifecycle.get_session(vim.api.nvim_get_current_tabpage()) then
      codediff.prev_hunk()
    else
      gs.nav_hunk("prev")
    end
  end, { buffer = bufnr, desc = "Previous hunk" })
end

return {
  src = "https://github.com/lewis6991/gitsigns.nvim",
  data = {
    event = "BufReadPre",
    after = function()
      require("gitsigns").setup({
        signs = { change = { text = "┋" } },
        signs_staged = { change = { text = "┋" } },
        signcolumn = true,
        numhl = false,
        linehl = false,
        word_diff = false,
        sign_priority = 4,
        worktrees = not utils.__IS_WIN and {
          {
            toplevel = vim.env.HOME,
            gitdir = vim.env.HOME .. "/dots/.git",
          }
        } or nil,
        on_attach = function(bufnr)
          local gs = assert(package.loaded.gitsigns)

          local function map(mode, l, r, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(mode, l, r, opts)
          end

          -- Set hunk navigation keymaps
          set_hunk_navigation_keymaps(bufnr)

          -- Actions
          map("n", "<leader>hs", gs.stage_hunk, { desc = "Stage hunk" })
          map("n", "<leader>hr", gs.reset_hunk, { desc = "Reset hunk" })
          map("v", "<leader>hs", function()
            gs.stage_hunk { vim.fn.line("."), vim.fn.line("v") }
          end, { desc = "Stage hunk" })
          map("v", "<leader>hr", function()
            gs.reset_hunk { vim.fn.line("."), vim.fn.line("v") }
          end, { desc = "Reset hunk" })
          map("n", "<leader>hu", gs.undo_stage_hunk, { desc = "Undo stage hunk" })
          map("n", "<leader>hS", gs.stage_buffer, { desc = "Stage buffer" })
          map("n", "<leader>hR", gs.reset_buffer, { desc = "Reset buffer" })
          map("n", "<leader>hp", gs.preview_hunk_inline, { desc = "preview hunk (inline)" })
          map("n", "<leader>hP", gs.preview_hunk, { desc = "preview hunk (float)" })
          map("n", "<leader>hb", function() gs.blame_line({ full = true }) end,
            { desc = "Line blame (float)" })
          map("n", "<leader>hB", gs.toggle_current_line_blame, { desc = "line blame (toggle)" })
          map("n", "<leader>hd", gs.diffthis, { desc = "diff against the index" })
          map("n", "<leader>hD", function() gs.diffthis("~1") end,
            { desc = "diff against previous commit" })
          map("n", "<leader>hx", gs.toggle_deleted, { desc = "toggle deleted lines" })

          -- Text object
          map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>")
          map({ "n", "x" }, "[h", ":<C-U>Gitsigns select_hunk<CR>o^<Esc>",
            { silent = true, desc = "Hunk top" })
          map({ "n", "x" }, "]h", ":<C-U>Gitsigns select_hunk<CR>^g_<Esc>",
            { silent = true, desc = "Hunk bottom" })
        end,
      })
      -- restore hunk navigation on CodeDiff.nvim close
      vim.api.nvim_create_autocmd("User", {
        pattern = "CodeDiffClose",
        callback = function() set_hunk_navigation_keymaps() end,
      })
    end,
  },
}
