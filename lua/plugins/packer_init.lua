if not require("plugins.bootstrap") then
  return
end

local packer = require'packer'
return packer.startup({
  function(use)

    -- TODO: causes issies with lspconfig
    -- speed up 'require', must be the first plugin
    -- use { "lewis6991/impatient.nvim",
      -- config = 'pcall(require, "impatient")' }

    -- Packer can manage itself as an optional plugin
    use { 'wbthomason/packer.nvim', opt = true }

    -- Analyze startuptime
    use { 'tweekmonster/startuptime.vim', cmd = 'StartupTime' }

    -- tpope's plugins that should be part of vim
    use { 'tpope/vim-surround' }
    use { 'tpope/vim-repeat' }

    -- "gc" to comment visual regions/lines
    use { 'numToStr/Comment.nvim',
        config = "require('plugins.comment')",
        -- uncomment for lazy loading
        -- slight delay if loading in visual mode
        keys = {'gcc', 'gc'}
    }

    -- needs no introduction
    use { 'tpope/vim-fugitive',
        config = "require('plugins.fugitive')",}
        -- event = "VimEnter" }

    -- plenary is required by gitsigns and telescope
    -- lazy load so gitsigns doesn't abuse our startup time
    use { "nvim-lua/plenary.nvim", event = "BufRead" }

    -- Add git related info in the signs columns and popups
    use { 'lewis6991/gitsigns.nvim',
        requires = { 'nvim-lua/plenary.nvim' },
        config = "require('plugins.gitsigns')",
        after = "plenary.nvim" }

    -- Add indentation guides even on blank lines
    use { 'lukas-reineke/indent-blankline.nvim', --branch="lua",
        config = "require('plugins.indent-blankline')",
        opt = true, cmd = { 'IndentBlanklineToggle' } }

    -- 'famiu/nvim-reload' has been archived and no longer maintained
    use { vim.fn.stdpath("config") .. "/lua/plugins/nvim-reload",
        config = "require('plugins.nvim-reload')",
        -- skip this since we manually lazy load
        -- in our command / binding
        -- cmd = { 'NvimReload', 'NvimRestart' },
        opt = true,
    }

    -- Neoterm (REPLs)
    use { 'kassio/neoterm',
        config = "require('plugins.neoterm')",
        keys = {'gxx', 'gx'},
        cmd = { 'T' },
    }

    -- yank over ssh with ':OCSYank' or ':OSCYankReg +'
    use { 'ojroques/vim-oscyank',
        config = function()
            vim.g.oscyank_term = 'tmux'
        end,
        cmd = { 'OSCYank', 'OSCYankReg' },
    }

    -- Autocompletion & snippets
    use { 'L3MON4D3/LuaSnip',
      config = 'require("plugins.luasnip")',
      event = 'InsertEnter' }

    use { 'hrsh7th/nvim-cmp',
        requires = {
          { 'hrsh7th/cmp-path', after = 'nvim-cmp' },
          { 'hrsh7th/cmp-buffer', after = 'nvim-cmp' },
          { 'hrsh7th/cmp-nvim-lsp', after = 'nvim-cmp' },
          { 'saadparwaiz1/cmp_luasnip', after = 'nvim-cmp' },
        },
        config = "require('plugins.cmp')",
        -- event = "InsertEnter", }
        after = 'LuaSnip', }

    -- nvim-treesitter
    -- verify a compiler exists before installing
    if require'utils'.have_compiler() then
        use { 'nvim-treesitter/nvim-treesitter',
            config = "require('plugins.treesitter')",
            run = ':TSUpdate',
            event = 'BufRead' }
        use { 'nvim-treesitter/nvim-treesitter-textobjects',
            after = { 'nvim-treesitter' } }
        -- debuging treesitter
        use { 'nvim-treesitter/playground',
            after = { 'nvim-treesitter' },
            cmd = { 'TSPlaygroundToggle' },
            opt = true }
    end

    -- optional for fzf-lua, telescope, nvim-tree, feline
    use { 'kyazdani42/nvim-web-devicons', event = 'VimEnter' }

    -- nvim-tree
    use { 'kyazdani42/nvim-tree.lua',
        requires = { 'kyazdani42/nvim-web-devicons' },
        config = "require('plugins.nvim-tree')",
        cmd = { 'NvimTreeToggle', 'NvimTreeFindFile' },
        opt = true,
    }

    -- Telescope
    use { 'nvim-telescope/telescope.nvim',
        requires = {
            {'nvim-lua/popup.nvim'},
            {'nvim-lua/plenary.nvim'},
            {'nvim-telescope/telescope-fzy-native.nvim'},
        },
        setup = "require('plugins.telescope.mappings')",
        config = "require('plugins.telescope')",
        opt = true
    }

    -- only required if you do not have fzf binary
    -- use = { 'junegunn/fzf', run = './install --bin', }
    -- use { '~/Sources/nvim/fzf-lua',
    use { 'ibhagwan/fzf-lua',
        requires = {
          -- { '~/Sources/nvim/nvim-fzf' },
          { 'vijaymarupudi/nvim-fzf' },
          { 'kyazdani42/nvim-web-devicons' },
        },
        setup = "require('plugins.fzf-lua.mappings')",
        config = "require('plugins.fzf-lua')",
        opt = true,
    }

   -- better quickfix
   use { 'kevinhwang91/nvim-bqf',
        config = "require'plugins.bqf'",
        ft = { 'qf' } }

    -- LSP
    use { 'neovim/nvim-lspconfig',    event = 'BufRead' }
    use { 'kabouzeid/nvim-lspinstall',
        config = function()
          require('lsp')
          -- ':command LspStart'
          require'lspconfig'._root.commands.LspStart[1]()
        end,
        after  = { 'nvim-lspconfig' },
      }

    -- ethereum solidity '.sol'
    use { 'tomlion/vim-solidity' }

    -- markdown preview using `glow`
    -- use { 'npxbr/glow.nvim', run = ':GlowInstall'}
    use { 'previm/previm',
        config = function()
            vim.g.previm_open_cmd = 'firefox'
            vim.g.previm_enable_realtime = 0
        end,
        opt = true, cmd = { 'PrevimOpen' } }

    -- key bindings cheatsheet
    use { 'folke/which-key.nvim',
        config = "require('plugins.which_key')",
        event = "VimEnter" }

    -- Color scheme, requires nvim-treesitter
    vim.g.nvcode_termcolors = 256
    use {"christianchiarulli/nvcode-color-schemes.vim", opt = true}

    -- Colorizer
    use { 'norcalli/nvim-colorizer.lua',
        config = function() require'colorizer'.setup() end,
        cmd = {'ColorizerAttachToBuffer', 'ColorizerDetachFromBuffer' },
        opt = true }

    -- fancy statusline
    use { 'famiu/feline.nvim',
        requires = { 'kyazdani42/nvim-web-devicons' },
        config = "require('plugins.feline')",
        after = 'nvim-web-devicons',
        event = 'VimEnter' }

    -- auto-generate vimdoc from GitHub README
    -- use { 'mjlbach/babelfish.nvim',
    -- use { '~/Sources/nvim/babelfish.nvim',
    use { 'ibhagwan/babelfish.nvim',
        setup = "require'plugins.babelfish'",
        opt = true }
  end
})
