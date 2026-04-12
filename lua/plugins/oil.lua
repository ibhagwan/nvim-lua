return {
  src = "https://github.com/stevearc/oil.nvim",
  data = {
    cmd = { "Oil" },
    beforeAll = function()
      vim.keymap.set({ "n", "v" }, "-", "<CMD>Oil<CR>",
        { silent = true, desc = "Open parent directory [Oil]" })
    end,
    after = function()
      require("oil").setup({
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
      })
    end,
  },
}
