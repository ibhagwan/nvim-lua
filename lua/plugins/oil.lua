return {
  "stevearc/oil.nvim",
  enabled = true,
  cmd = { "Oil" },
  keys = {
    { mode = { "n", "v" }, "-", "<CMD>Oil<CR>", desc = "Open parent directory [Oil]" },
  },
  opts = {
    keymaps = {
      ["<C-c>"] = false,
      ["<C-s>"] = false,
      ["<C-p>"] = false,
      ["<C-h>"] = false,
      ["<C-v>"] = { "actions.select", opts = { horizontal = true } },
      ["gq"] = { "actions.close", mode = "n" },
      ["gp"] = "actions.preview",
      ["<F4>"] = "actions.preview",
    },
  },
}
