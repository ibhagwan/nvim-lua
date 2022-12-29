local M = {
  "tanvirtin/vgit.nvim",
  event = "VeryLazy",
  enabled = false,
}

M.config = function()
  require("vgit").setup {
    keymaps = {
      ["n [c"] = "hunk_up",
      ["n ]c"] = "hunk_down",
      ["n <leader>hs"] = "buffer_hunk_stage",
      ["n <leader>hr"] = "buffer_hunk_reset",
      ["n <leader>hp"] = "buffer_hunk_preview",
      ["n <leader>hb"] = "buffer_blame_preview",
      ["n <leader>hB"] = "buffer_gutter_blame_preview",
      ["n <leader>hd"] = "buffer_diff_preview",
      ["n <leader>hh"] = "buffer_history_preview",
      ["n <leader>hR"] = "buffer_reset",
      ["n <leader>hP"] = "project_hunks_preview",
      ["n <leader>hD"] = "project_diff_preview",
      ["n <leader>hq"] = "project_hunks_qf",
      ["n <leader>hx"] = "toggle_diff_preference",
    },
    settings = {
      live_blame = {
        enabled = false,
      },
      live_gutter = {
        enabled = true,
      },
      authorship_code_lens = {
        enabled = false,
      },
      screen = {
        diff_preference = "unified",
      },
      symbols = {
        void = "⣿",
      },
      git = {
        cmd = "git",
        fallback_cwd = vim.fn.expand("$HOME"),
        fallback_args = {
          "--git-dir",
          vim.fn.expand("$HOME/dots/yadm-repo"),
          "--work-tree",
          vim.fn.expand("$HOME"),
        },
      },
    }
  }
end

return M
