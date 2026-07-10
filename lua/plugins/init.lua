local utils = require("utils")

local plugins = {}

-- Moonfly colorscheme (high priority, load immediately)
table.insert(plugins, {
  src = "https://github.com/bluz71/vim-moonfly-colors",
  data = {
    after = function() vim.cmd.colorscheme("moonfly") end
  },
})

-- SmartYank.nvim with local dev support
table.insert(plugins, {
  src = utils.exists("~/Sources/nvim/smartyank.nvim")
      or "https://github.com/ibhagwan/smartyank.nvim",
  data = {
    enabled = false,
    after = function()
      require("smartyank").setup({ highlight = { timeout = 1000 } })
    end,
  },
})

-- previm (lazy-load on markdown filetype)
table.insert(plugins, {
  src = "https://github.com/previm/previm",
  version = "8d414bf9b38d2a7c65a313775e26c03a0169f67f",
  data = {
    ft = "markdown",
    before = function()
      vim.g.previm_open_cmd = "/shared/$USER/Applications/chromium/chrome"
      vim.g.previm_enable_realtime = 0
      vim.g.previm_code_language_show = 1
      vim.g.previm_disable_default_css = 1
      vim.g.previm_custom_css_path = vim.fn.stdpath("config") .. "/css/previm-gh-dark.css"
      local hljs_ghdark_css = "highlight-gh-dark.css"
      vim.g.previm_extra_libraries = { {
        name = "highlight-gh-dark",
        files = { { type = "css", path = "_/css/lib/highlight-gh-dark.css" } },
      } }
      -- Copy custom CSS to previm jail
      if not vim.uv.fs_copyfile(
            vim.fn.stdpath("config") .. "/css/" .. hljs_ghdark_css,
            vim.fn.stdpath("data") .. "/site/pack/core/opt/previm/preview/_/css/lib/"
            .. hljs_ghdark_css)
      then
        utils.warn("Unable to copy '%s' to previm jail.", hljs_ghdark_css)
      end
    end,
    after = function()
      -- Clear cache
      vim.fn["previm#wipe_cache"]()
    end,
  },
})

-- Load fzf dependency on Windows
if utils.__IS_WIN then
  table.insert(plugins, {
    src = "https://github.com/junegunn/fzf",
    data = { lazy = false },
  })
end

-- fzf.vim with local dev support
table.insert(plugins, {
  src = utils.exists("~/Sources/nvim/fzf.vim")
      or "https://github.com/junegunn/fzf.vim",
  data = {
    event = { "DeferredUIEnter" },
    before = function()
      if vim.g.loaded_fzf then return end
      local fzf_rtp = { "/usr/share/nvim/runtime", "/opt/homebrew/opt/fzf" }
      for _, p in ipairs(fzf_rtp) do
        local fzf_vim = vim.fs.joinpath(p, "plugin", "fzf.vim")
        if vim.uv.fs_stat(fzf_vim) then
          vim.cmd.source(fzf_vim)
          return
        end
      end
    end,
  },
})

-- render-markdown.nvim
table.insert(plugins, {
  src = "https://github.com/MeanderingProgrammer/render-markdown.nvim",
  data = {
    ft = "markdown",
    after = function()
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
        },
      })
    end,
  },
})

-- quicker.nvim
table.insert(plugins, {
  src = "https://github.com/stevearc/quicker.nvim",
  data = {
    ft = "qf",
    after = function()
      require("quicker").setup({})
    end,
  },
})

return plugins
