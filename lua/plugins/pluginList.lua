local packer_startup = function(use)

    local function prefer_local(url, path)
      if not path then
        local name = url:match("[^/]*$")
        path = "~/Sources/nvim/" .. name
      end
      return vim.loop.fs_stat(vim.fn.expand(path)) ~= nil and path or url
    end

    -- speed up 'require', must be the first plugin
    use { "lewis6991/impatient.nvim",
      config = "if vim.fn.has('nvim-0.6')==1 then require('impatient') end"
    }

    -- Packer can manage itself as an optional plugin
    use { 'wbthomason/packer.nvim', opt = true }

    -- Analyze startuptime
    -- use { 'tweekmonster/startuptime.vim', cmd = 'StartupTime' }
    use { 'dstein64/vim-startuptime', cmd = 'StartupTime' }

    -- tpope's plugins that should be part of vim
    use { 'tpope/vim-surround' }
    use { 'tpope/vim-repeat' }

    -- "gc" to comment visual regions/lines
    use { 'numToStr/Comment.nvim',
        config = "require('plugins.comment')",
        -- uncomment for lazy loading
        -- slight delay if loading in visual mode
        keys = {'gcc', 'gc', 'gl'}
    }

    -- needs no introduction
    use { 'tpope/vim-fugitive',
        config = "require('plugins.fugitive')",
        event = "VimEnter" }

    -- plenary is required by gitsigns and telescope
    -- lazy load so gitsigns doesn't abuse our startup time
    use { "nvim-lua/plenary.nvim", event = "BufRead" }

    -- Add git related info in the signs columns and popups
    use { 'lewis6991/gitsigns.nvim',
        requires = { 'nvim-lua/plenary.nvim' },
        config = "require('plugins.gitsigns')",
        after = "plenary.nvim" }

    use { 'sindrets/diffview.nvim',
        requires = { 'nvim-lua/plenary.nvim' },
        -- was causing issues when switching between neovim versions
        -- From packer.nvim README:
        -- NOTE: If you use a function value for config or setup keys in any
        -- plugin specifications, it must not have any upvalues (i.e. captures).
        -- We currently use Lua's string.dump to compile config/setup functions
        -- to bytecode, which has this limitation.
        --[[ setup = function()
          require'utils'.command({
            "-nargs=*", "DiffviewOpen", function(args)
              if not pcall(require, 'diffview') then
                require('packer').loader('plenary.nvim')
                require('packer').loader('diffview.nvim')
              end
              require'diffview'.open(#args>0 and args)
            end})
        end, ]]
        config = "require('plugins.diffview')",
        cmd = {'DiffviewOpen'},
        opt = true }

    -- Add indentation guides
    use { 'lukas-reineke/indent-blankline.nvim',
        config = "require('plugins.indent-blankline')",
        event = 'BufRead',
        opt = true,
    }

    -- 'famiu/nvim-reload' has been archived and no longer maintained
    use { vim.fn.stdpath("config") .. "/lua/plugins/nvim-reload",
        config = "require('plugins.nvim-reload')",
        -- skip this since we manually lazy load
        -- in our command / binding
        -- cmd = { 'NvimReload', 'NvimRestart' },
        opt = true,
    }

    -- Neoterm (REPLs)
    use { 'akinsho/toggleterm.nvim',
        config = "require('plugins.neoterm')",
        keys = {'gxx', 'gx', '<C-\\>'},
        cmd = { 'T' },
    }

    -- yank over ssh with ':OCSYank' or ':OSCYankReg +'
    use { 'ojroques/vim-oscyank',
        config = [[vim.g.oscyank_term = 'tmux']],
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
          { 'hrsh7th/cmp-cmdline', after = 'nvim-cmp' },
          { 'hrsh7th/cmp-nvim-lsp', after = 'nvim-cmp' },
          { 'hrsh7th/cmp-nvim-lua', after = 'nvim-cmp' },
          { 'saadparwaiz1/cmp_luasnip', after = 'nvim-cmp' },
        },
        config = "require('plugins.cmp')",
        -- event = "InsertEnter", }
        after = 'LuaSnip', }

    -- nvim-treesitter
    -- verify a compiler exists before installing
    if require'utils'.have_compiler() then
        use { prefer_local('nvim-treesitter/nvim-treesitter'),
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

    -- optional for fzf-lua, telescope, nvim-tree
    use { 'kyazdani42/nvim-web-devicons',
      config = "require('plugins.devicons')",
      event = 'VimEnter'
    }

    -- nvim-tree
    use { 'kyazdani42/nvim-tree.lua',
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
    use {
        prefer_local('ibhagwan/fzf-lua'),
        setup = "require('plugins.fzf-lua.mappings')",
        config = "require('plugins.fzf-lua')",
        opt = true,
    }

   -- better quickfix
   use { 'kevinhwang91/nvim-bqf',
        config = "require'plugins.bqf'",
        ft = { 'qf' } }

    -- LSP
    use { 'neovim/nvim-lspconfig', event = 'BufRead' }
    use { 'williamboman/nvim-lsp-installer',
        config = "require('lsp')",
        after  = { 'nvim-lspconfig' },
      }

    -- DAP
    use { 'mfussenegger/nvim-dap',
        config = "require('plugins.nvim-dap')",
        keys = {'<F5>', '<F9>' }
    }
    use { 'leoluz/nvim-dap-go',
        config = "require('dap-go').setup()",
        after = { 'nvim-dap' }
    }

    -- ethereum solidity '.sol'
    use { 'tomlion/vim-solidity' }

    -- markdown preview using `glow`
    -- use { 'npxbr/glow.nvim', run = ':GlowInstall'}
    use { 'previm/previm',
        config = [[
            vim.g.previm_open_cmd = 'firefox';
            vim.g.previm_enable_realtime = 0
        ]],
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
        config = "require'colorizer'.setup()",
        cmd = {'ColorizerAttachToBuffer', 'ColorizerDetachFromBuffer' },
        opt = true }

    use { 'rebelot/kanagawa.nvim',
        config = [[
          require('kanagawa').setup({
            transparent = false,
            dimInactive = true,
            --  colors = { sumiInk1 = "#0D1014", },
          })
        ]],
        event = "ColorSchemePre" }

    -- fancy statusline
    use { 'nvim-lualine/lualine.nvim',
        config = "require('plugins.statusline')",
        -- after = 'nvim-web-devicons',
        event = 'VimEnter' }

    -- auto-generate vimdoc from GitHub README
    use {
        prefer_local('ibhagwan/babelfish.nvim'),
        setup = "require'plugins.babelfish'",
        opt = true }

end

return packer_startup
