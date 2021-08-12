-- Do not use plugins when running as root or neovim < 0.5
if require'utils'.is_root() or not require'utils'.has_neovim_v05() then
  return { sync_if_not_compiled = function() return end }
end

local execute = vim.api.nvim_command

local compile_suffix = "/plugin/packer_compiled.lua"
local install_suffix = "/site/pack/packer/%s/packer.nvim"
local install_path = vim.fn.stdpath("data") .. string.format(install_suffix, "opt")
local compile_path = vim.fn.stdpath("data") .. compile_suffix

-- Do we need to migrate from previous nvim-lua setup?
local old_install_path = vim.fn.stdpath("data") .. string.format(install_suffix, "start")
local old_is_installed = vim.fn.empty(vim.fn.glob(old_install_path)) == 0
if old_is_installed then
  -- delete 'package_compiled.lua'
  -- forces sync in 'sync_if_not_compiled'
  vim.fn.delete(old_install_path .. "/plugin", 'rf')
  local success, msg = os.rename(old_install_path, install_path)
  if not success then print("failed to moved packer.nvim: " .. msg)
  else print("packer.nvim successfully moved to " .. install_path) end
end

-- check if packer is installed (~/.local/share/nvim/site/pack)
local is_installed = vim.fn.empty(vim.fn.glob(install_path)) == 0
local is_compiled = vim.fn.empty(vim.fn.glob(compile_path)) == 0
if not is_installed then
    if vim.fn.input("Install packer.nvim? (y for yes) ") == "y" then
        execute("!git clone https://github.com/wbthomason/packer.nvim " .. install_path)
        execute("packadd packer.nvim")
        print("Installed packer.nvim.")
        is_installed = 1
    end
end

-- Packer commands
vim.cmd [[command! PackerInstall packadd packer.nvim | lua require('plugins').install()]]
vim.cmd [[command! PackerUpdate packadd packer.nvim | lua require('plugins').update()]]
vim.cmd [[command! PackerSync packadd packer.nvim | lua require('plugins').sync()]]
vim.cmd [[command! PackerClean packadd packer.nvim | lua require('plugins').clean()]]
vim.cmd [[command! PackerCompile packadd packer.nvim | lua require('plugins').compile()]]
vim.cmd [[command! PC PackerCompile]]
vim.cmd [[command! PS PackerStatus]]
vim.cmd [[command! PU PackerSync]]

-- Since we are lazy loading packer itself
-- and also changed the compiled lazy loading file
vim.cmd [[packadd packer.nvim]]
if is_compiled then vim.cmd("luafile " .. compile_path) end

local packer = nil
local function init()
    if not is_installed then return end
    if packer == nil then
        packer = require('packer')
        packer.init({
            -- we don't want the compilation file in '~/.config/nvim'
            compile_path = compile_path
        })
    end

    local use = packer.use

    -- Packer can manage itself as an optional plugin
    use { 'wbthomason/packer.nvim', opt = true }

    -- Analyze startuptime
    use { 'tweekmonster/startuptime.vim', cmd = 'StartupTime' }

    -- tpope's plugins that should be part of vim
    use { 'tpope/vim-surround' }
    use { 'tpope/vim-repeat' }

    -- "gc" to comment visual regions/lines
    vim.g.kommentary_create_default_mappings = false
    use { 'b3nj5m1n/kommentary',
        -- uncomment for lazy loading
        -- causes delay with visual mapping
        -- keys = {'gcc', 'gc'}
    }

    -- needs no introduction
    use { 'tpope/vim-fugitive',
        config = "require('plugin.fugitive')",}
        -- event = "VimEnter" }

    -- :DiffViewOpen :DiffViewClose
    use { 'sindrets/diffview.nvim', opt = true,
        cmd = { 'DiffviewOpen', 'DiffviewClose' }}

    -- plenary is required by gitsigns and telescope
    -- lazy load so gitsigns doesn't abuse our startup time
    use { "nvim-lua/plenary.nvim", event = "BufRead" }

    -- Add git related info in the signs columns and popups
    use { 'lewis6991/gitsigns.nvim',
        requires = { 'nvim-lua/plenary.nvim' },
        config = "require('plugin.gitsigns')",
        after = "plenary.nvim" }

    -- Add indentation guides even on blank lines
    use { 'lukas-reineke/indent-blankline.nvim', --branch="lua",
        config = "require('plugin.indent-blankline')",
        opt = true, cmd = { 'IndentBlanklineToggle' } }

    -- 'famiu/nvim-reload' has been archived and no longer maintained
    use { vim.fn.stdpath("config") .. "/lua/plugin/nvim-reload",
        config = "require('plugin.nvim-reload')",
        -- skip this since we manually lazy load
        -- in our command / binding
        -- cmd = { 'NvimReload', 'NvimRestart' },
        after = 'plenary.nvim', opt = true,
    }

    -- Neoterm (REPLs)
    use { 'kassio/neoterm',
        config = "require('plugin.neoterm')",
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

    -- Autocompletion
    use { 'hrsh7th/nvim-compe',
        event = "InsertEnter",
        config = "require('plugin.completion')" }

    -- nvim-treesitter
    -- verify a compiler exists before installing
    if require'utils'.have_compiler() then
        use { 'nvim-treesitter/nvim-treesitter',
            config = "require('plugin.treesitter')",
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
        config = "require('plugin.nvim-tree')",
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
        setup = "require('plugin.telescope.mappings')",
        config = "require('plugin.telescope')",
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
        setup = "require('plugin.fzf-lua.mappings')",
        config = "require('plugin.fzf-lua')",
        opt = true,
    }

   -- better quickfix
   use { 'kevinhwang91/nvim-bqf',
        config = "require'plugin.bqf'",
        ft = { 'qf' } }

    -- LSP
    use { 'neovim/nvim-lspconfig',    event = 'BufRead' }
    use { 'ray-x/lsp_signature.nvim', event = 'BufRead' }
    use { 'kabouzeid/nvim-lspinstall',
        config = function()
          require('lsp')
          -- ':command LspStart'
          require'lspconfig'._root.commands.LspStart[1]()
        end,
        after  = { 'nvim-lspconfig', 'lsp_signature.nvim' },
      }

    --[[ use { 'glepnir/lspsaga.nvim',
        config = function()
          require'lspsaga'.init_lsp_saga({
            rename_prompt_prefix = 'New name ➤',
          })
        end } ]]

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
        config = "require('plugin.which_key')",
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
    use { 'ibhagwan/feline.nvim',
        requires = { 'kyazdani42/nvim-web-devicons' },
        config = "require'plugin.feline'",
        after = 'nvim-web-devicons',
        event = 'VimEnter' }

end

-- called from 'lua/autocmd.lua' at `VimEnter`
local function sync_if_not_compiled()
    if packer == nil then return end
    if not is_compiled then
        packer.sync()
        --execute("luafile $MYVIMRC")
    end
end

local plugins = setmetatable({}, {
    __index = function(_, key)
        init()
        -- workaround for error when packer not installed
        if packer == nil then return function() end end
        if key == "sync_if_not_compiled" then
            return sync_if_not_compiled
        else
            return packer[key]
        end
    end
})

return plugins
