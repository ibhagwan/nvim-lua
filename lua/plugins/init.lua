return {
  {
    -- "bluz71/vim-nightfly-guicolors",
    "bluz71/vim-moonfly-colors",
    enabled = true,
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd.colorscheme("moonfly")
      -- vim.cmd.colorscheme("nightfly")
    end
  },
  {
    "folke/tokyonight.nvim",
    enabled = false,
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd.colorscheme("tokyonight")
    end
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
  {
    "previm/previm",
    commit = "8d414bf9b38d2a7c65a313775e26c03a0169f67f",
    config = function()
      -- vim.g.previm_open_cmd = 'firefox';
      vim.g.previm_open_cmd = "/shared/$USER/Applications/chromium/chrome";
      vim.g.previm_enable_realtime = 0
      vim.g.previm_code_language_show = 1
      vim.g.previm_disable_default_css = 1
      vim.g.previm_custom_css_path = vim.fn.stdpath("config") .. "/css/previm-gh-dark.css"
      local hljs_ghdark_css = "highlight-gh-dark.css"
      vim.g.previm_extra_libraries = { {
        name = "highlight-gh-dark",
        files = { {
          type = "css",
          -- must use previm jailed path due to chrome running in firejail
          path = "_/css/lib/highlight-gh-dark.css",
        } },
      } }
      -- Copy our custom code highlight css to the jailbreak folder
      if not vim.uv.fs_copyfile(vim.fn.stdpath("config") .. "/css/" .. hljs_ghdark_css,
            vim.fn.stdpath("data") .. "/lazy/previm/preview/_/css/lib/" .. hljs_ghdark_css) then
        require("utils").warn(string.format(
          "Unable to copy '%s' to previm jail.", hljs_ghdark_css))
      end
      -- clear cache every time we open neovim
      vim.fn["previm#wipe_cache"]()
    end,
    ft = { "markdown" },
  },
  {
    "junegunn/fzf.vim",
    enabled = true,
    lazy = false,
    dev = require("utils").is_dev("fzf.vim"),
    -- windows doesn't have fzf runtime plugin
    dependencies = require("utils").__IS_WIN and { "junegunn/fzf" } or nil,
  },
  {
    "MeanderingProgrammer/render-markdown.nvim",
    enabled = true,
    ft = "markdown",
    config = function()
      require("render-markdown").setup({
        file_types = { "markdown" },
        code = {
          sign = false,
          width = "block",
          right_pad = 4,
          position = "right",
        },
        heading = {
          sign = false,
          -- icons = {},
        },
      })
    end,
  },
}
