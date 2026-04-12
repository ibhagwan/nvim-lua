return {
  src = require("utils").exists("~/Sources/nvim/fzf-lua")
      or "https://github.com/ibhagwan/fzf-lua",
  data = {
    cmd = { "FzfLua", "TogglePickers" },
    beforeAll = function()
      -- Set up keymaps immediately
      require("plugins.fzf-lua.mappings").map()
    end,
    before = function()
      ---@diagnostic disable-next-line: missing-fields
      -- Lazy load nvim-treesitter or help files err with:
      -- Query error at 2:4. Invalid node type "delimiter"
      -- This is due to fzf-lua calling `vim.treesitter.language.add`
      -- before nvim-treesitter is loaded
      require("lz.n").trigger_load({ "nvim-web-devicons", "nvim-treesitter", "snacks.nvim" })
    end,
    after = function()
      require("plugins.fzf-lua.setup").setup()

      vim.api.nvim_create_user_command("TogglePickers", function()
        local u = require("utils")
        u.__USE_SNACKS = not u.__USE_SNACKS
        u.info("Main picker set to %s", u.__USE_SNACKS and "Snacks" or "FzfLua")
        require("plugins.fzf-lua.mappings").map()
        require("plugins.snacks.mappings").map()
      end, {})
    end,
  },
}
