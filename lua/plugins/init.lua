return {
  {
    "bluz71/vim-nightfly-guicolors",
    lazy = false,
    priority = 1000,
  },
  {
    "dstein64/vim-startuptime",
    cmd = "StartupTime",
  },
  -- SmartYank (by me)
  {
    "ibhagwan/smartyank.nvim",
    config = function()
      require("smartyank").setup({ highlight = { timeout = 1000 } })
    end,
    event = "VeryLazy",
    dev = require("utils").is_dev("smartyank.nvim")
  },
  -- plenary is required by gitsigns and telescope
  {
    "nvim-lua/plenary.nvim",
    keys = { "<leader>tt", "<leader>td" },
    config = function()
      vim.keymap.set({ "n", "v" }, "<leader>tt",
        function() require("plenary.test_harness").test_file(vim.fn.expand("%")) end,
        { silent = true, desc = "Run tests in current file" })
      vim.keymap.set({ "n", "v" }, "<leader>td",
        function() require("plenary.test_harness").test_directory_command("tests") end,
        { silent = true, desc = "Run tests in 'tests' directory" })
    end,
  },
  {
    "previm/previm",
    commit = "1978acc23c16cddcaf70c856a3b39d17943d7df0",
    config = function()
      -- vim.g.previm_open_cmd = 'firefox';
      vim.g.previm_open_cmd = "/shared/$USER/Applications/chromium/chrome";
      vim.g.previm_enable_realtime = 0
      vim.g.previm_disable_default_css = 1
      vim.g.previm_custom_css_path = vim.fn.stdpath("config") .. "/css/previm-gh-dark.css"
      -- clear cache every time we open neovim
      vim.fn["previm#wipe_cache"]()
    end,
    ft = { "markdown" },
  },
  {
    "nvchad/nvim-colorizer.lua",
    config = function()
      require("colorizer").setup()
    end,
    cmd = { "ColorizerAttachToBuffer", "ColorizerDetachFromBuffer" },
  },
  {
    "junegunn/fzf.vim",
    enabled = true,
    lazy = false,
    dev = true,
    -- windows doesn't have fzf runtime plugin
    dependencies = require("utils")._if_win({ "junegunn/fzf" }, nil),
  },
  {
    "pwntester/octo.nvim",
    enabled = false,
    lazy = false,
    dev = true,
    config = function()
      require "octo".setup({ picker = "fzf-lua" })
    end
  }
}
