-- If we do not wish to wait for timeoutlen
vim.api.nvim_set_keymap('n', '<Leader>?', "<Esc>:WhichKey '' n<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<Leader>?', "<Esc>:WhichKey '' v<CR>", { noremap = true, silent = true })

-- https://github.com/folke/which-key.nvim#colors
vim.cmd([[highlight default link WhichKey          htmlH1]])
vim.cmd([[highlight default link WhichKeySeperator String]])
vim.cmd([[highlight default link WhichKeyGroup     Keyword]])
vim.cmd([[highlight default link WhichKeyDesc      Include]])
vim.cmd([[highlight default link WhichKeyFloat     CursorLine]])
vim.cmd([[highlight default link WhichKeyValue     Comment]])

require("which-key").setup {
    plugins = {
        marks = true, -- shows a list of your marks on ' and `
        registers = true, -- shows your registers on " in NORMAL or <C-r> in INSERT mode
        -- the presets plugin, adds help for a bunch of default keybindings in Neovim
        -- No actual key bindings are created
        spelling = {
            enabled = true, -- enabling this will show WhichKey when pressing z= to select spelling suggestions
            suggestions = 20 -- how many suggestions should be shown in the list?
        },
        presets = {
            operators = true, -- adds help for operators like d, y, ... and registers them for motion / text object completion
            motions = true, -- adds help for motions
            text_objects = true, -- help for text objects triggered after entering an operator
            windows = true, -- default bindings on <c-w>
            nav = true, -- misc bindings to work with windows
            z = true, -- bindings for folds, spelling and others prefixed with z
            g = true -- bindings for prefixed with g
        }
    },
    -- add operators that will trigger motion and text object completion
    -- to enable all native operators, set the preset / operators plugin above
    operators = {gc = "Comments"},
    key_labels = {
        -- override the label used to display some keys. It doesn't effect WK in any other way.
        -- For example:
        ["<space>"] = "SPC",
        ["<cr>"] = "RET",
        ["<tab>"] = "TAB"
    },
    icons = {
        breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
        separator = "➜", -- symbol used between a key and it's label
        group = "+" -- symbol prepended to a group
    },
    window = {
        border = "none", -- none, single, double, shadow
        position = "bottom", -- bottom, top
        margin = {1, 0, 1, 0}, -- extra window margin [top, right, bottom, left]
        padding = {1, 1, 1, 1} -- extra window padding [top, right, bottom, left]
    },
    layout = {
        height = {min = 4, max = 25}, -- min and max height of the columns
        width = {min = 20, max = 50}, -- min and max width of the columns
        spacing = 5 -- spacing between columns
    },
    hidden = {"<silent>", "<cmd>", "<Cmd>", "<CR>", "call", "lua", "^:", "^ "}, -- hide mapping boilerplate
    show_help = true, -- show help message on the command line when the popup is visible
    triggers = "auto" -- automatically setup triggers
    -- triggers = {"<leader>"} -- or specifiy a list manually
}

local opts = {
    mode = "n", -- NORMAL mode
    buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
    silent = true, -- use `silent` when creating keymaps
    noremap = true, -- use `noremap` when creating keymaps
    nowait = false -- use `nowait` when creating keymaps
}

local keymaps = {
  ["<F1>"]      = 'Fuzzy find help tags',
  ["<C-P>"]     = 'Fuzzy find project files',
  ["<C-S>"]     = 'Save',
  ["<C-R>"]     = 'Redo',
  ["u"]         = 'Undo',
  ["U"]         = 'Undo line',
  ["."]         = 'Repeat last edit',
  ['c.']        = 'search and replace word under cursor',
  ["<up>"]      = 'Go up visual line',
  ["<down>"]    = 'Go down visual line',
  ["K"]         = 'LSP hover info under cursor',
  ["<leader>"]  = {
    ['?']       = 'Which key help',
    ['"']       = { [[:lua require('utils').ensure_loaded_fnc(]] ..
                    [[{'indent-blankline.nvim'}, function()]] ..
                    [[ require('indent_blankline.commands').toggle('<bang>' == '!')]] ..
                    [[ end)<CR> ]], 'toggle IndentBlankline on/off' },
    ['<F1>']    = 'Fuzzy find help tags',
    ['<Up>']    = 'horizontal split increase',
    ['<Down>']  = 'horizontal split decrease',
    ['<Left>']  = 'vertical split decrease',
    ['<Right>'] = 'vertical split increase',
    ['%']       = "change pwd to current file's parent",
    ['=']       = 'normalize split layout',
    [';']       = 'fzy buffers',
    [',']       = 'fzf buffers',
    ['|']       = 'toggle color column on/off',
    ['\'']      = "toggle 'listchars' on/off",
    ['c.']      = 'search and replace WORD under cursor',
    C = 'blackhole \'C\'',
    c = 'blackhole \'c\'',
    D = 'blackhole \'D\'',
    d = 'blackhole \'d\'',
    M = 'open markdown preview in firefox',
    O = 'newline above (no insert-mode)',
    o = 'newline below (no insert-mode)',
    R = 'reload nvim configuration',
    S = 'paste before from secondary',
    s = 'paste after  from secondary',
    V = 'paste before from primary',
    v = 'paste after  from primary',
    q = "toggle quickfix list on/off",
    Q = "toggle location list on/off",
    k = 'peek definition  (LSP)',
    K = 'signature help   (LSP)',
    e = {
        name = '+explore/edit',
        e = { ':NvimTreeToggle<CR>', 'nvim-tree on/off' },
        f = { ':NvimTreeFindFile<CR>', 'nvim-tree current file' },
        d = 'fzy ~/dots',
        n = 'fzy ~/.config/nvim',
        z = 'fzy ~/.config/zsh',
        i = "edit 'nvim/init.lua'",
        k = "edit 'nvim/keymaps.lua'",
        p = 'fzy nvim plugins',
    },
    g = {
        name = '+git',
        g = 'Gedit',
        s = 'git status',
        r = 'Gread (checkout)',
        w = 'Gwrite (stage)',
        a = 'git add (current file)',
        A = 'git add (all)',
        b = 'git blame',
        c = 'git commit',
        d = 'git diff (buffer)',
        D = 'git diff (project)',
        S = 'git stash (current file)',
        ['-'] = 'git stash (global)',
        ['+'] = 'git stash pop',
        p = 'git push',
        f = 'git fetch --all',
        F = 'git fetch origin',
        l = 'git log (current file)',
        L = 'git log (global)',
        e = 'Gedit HEAD~n (vertical)',
        E = 'Gedit HEAD~n (horizontal)',
        v = 'DiffviewOpen',
        V = 'DiffviewClose',
    },
    h = {
        name = '+gitsigns',
        b = 'git blame',
        p = 'preview hunk',
        r = 'reset hunk',
        R = 'reset buffer',
        s = 'stage hunk',
        u = 'undo stage hunk',
    },
    t = {
        name = '+tab',
        N = 'open a new tab',
        c = 'close current tab',
        f = 'jump to first tab',
        l = 'jump to last tab',
        n = 'jump to next tab',
        p = 'jump to previous tab',
        o = 'jump to first tab and close all others',
        -- s = 'tag search word under cursor',
    },
    f = {
        name = '+find (fzf)',
        ['?'] = 'fzf-lua builtin commands',
        -- c = 'nvim commands',
        -- C = 'git commits',
        p = 'files',
        g = 'git files',
        -- G = 'git grep',
        h = 'file history',
        b = 'live grep (buffer)',
        l = 'live grep (project)',
        R = 'live grep (project)',
        f = 'grep last search term',
        r = 'grep prompt',
        v = 'grep visual selection',
        w = 'grep word under cursor',
        W = 'grep WORD under cursor',
        M = 'man pages',
        -- m = 'marks',
        o = 'color schemes',
        q = 'quickfix list',
        Q = 'location list',
        -- s = 'fzy search history',
        -- t = 'tags (buffer)',
        -- T = 'tags (project)',
        -- x = 'executed commands',
        B = 'git branches',
        c = 'git commits (project)',
        C = 'git commits (buffer)',
    },
    z = {
        name = '+find (telescope)',
        -- ['/'] = 'grep last search',
        ["/"] = 'fzy search history',
        ['?'] = 'telescope builtin commands',
        [':'] = 'fzy nvim commands',
        ['"'] = 'fzy registers',
        b = 'fzy current buffer',
        d = 'fzy fd',
        B = 'git branches',
        c = 'git commits (project)',
        C = 'git commits (buffer)',
        f = 'fzy files',
        g = 'fzy git files',
        h = 'fzy file history',
        r = 'regex grep',
        R = 'live grep',
        w = 'grep word under cursor',
        W = 'grep WORD under cursor',
        v = 'grep visual selection',
        x = 'fzy executed commands',
        k = 'fzy keymaps',
        o = 'fzy vim.options',
        m = 'fzy marks',
        M = 'fzy man pages',
        t = 'fzy tags (buffer)',
        T = 'fzy tags (project)',
        q = 'fzy quickfix list',
        Q = 'fzy location list',
        z = 'fzy spell suggestions under cursor',
        l = {
            name = '+lsp',
            a = 'code actions (cursor)',
            A = 'code actions (range)',
            d = 'definitions',
            g = 'diagnostics (buffer)',
            G = 'diagnostics (project)',
            m = 'implemtations',
            s = 'symbols (buffer)',
            S = 'symbols (project)',
            r = 'references',
        },
        e = {
            name = '+edit',
            d = 'fzy ~/dots',
            n = 'fzy ~/.config/nvim',
            z = 'fzy ~/.config/zsh',
            p = 'fzy nvim plugins',
        },
    },
    l = {
        name = '+lsp',
        a = 'code actions',
        d = 'definitions',
        D = 'declarations',
        y = 'type definitions',
        c = 'clear diagnostics',
        g = 'diagnostics (buffer)',
        G = 'diagnostics (project)',
        m = 'implemtations',
        s = 'symbols (buffer)',
        S = 'symbols (project)',
        r = 'references',
        R = 'rename',
        l = 'line diagnostics',
        t = 'toggle diagnostics',
        L = 'code lense',
        Q = 'send diagnostics to loclist',
    },
    -- nvim-treesitter-textobjects
    [' '] = {
        name = '+treesitter-textobjects',
        a = {
            name = '+outer',
            o = 'object|class',
            b = 'block',
            f = 'function',
            c = 'condition',
            C = 'call',
            l = 'loop',
            p = 'parameter',
            s = 'statement',
        },
        i = {
            name = '+inner',
            o = 'object|class',
            b = 'block',
            f = 'function',
            c = 'condition',
            C = 'call',
            l = 'loop',
            p = 'parameter',
            s = 'scopename',
        },
    }
  },
  ['g'] = {
        ['<C-V>'] = 'visually select last yanked/pasted text',
        a = 'code action (LSP)',
        c = 'comment (motion)',
        cc = 'comment (line)',
        d = 'goto definition (LSP)',
        D = 'goto declaration (LSP)',
        m = 'goto implementation (LSP)',
        y = 'goto type definition (LSP)',
        r = 'references to quickfix (LSP)',
        R = 'rename (LSP)',
        x = 'REPL send to terminal (motion)',
        xx = 'REPL send to terminal (line)',
        -- builtin commands
        -- workaround for words being highlighted
        ['*'] = { 'g*:nohl<cr>', 'goto next word under cursor' },
        ['#'] = { 'g#:nohl<cr>', 'goto prev word under cursor' },
        ['<C-G>'] = 'show current curosr pos info',
        ['%'] = 'goto previous matching group',
        ['<'] = 'display last !command output',
        ['0'] = 'goto line start (nowrap)',
        ['$'] = 'goto line end  (nowrap)',
        ['8'] = 'print hex value under cursor',
        _ = 'goto last non-EOL char',
        E = 'Previous end of WORD',
        I = 'insert at first column',
        t = 'goto next tab',
        T = 'goto prev tab',
        -- m = { 'gm', 'goto middle of screen line' },
        M = 'goto middle of text line',
        F = 'Goto file:line under cursor',
  },
  ['['] = {
        -- ['%'] = 'matching group prev',
        ['-'] = 'goto older error list',
        c = 'diff (change) prev',
        D = 'diagnostics prev (nowrap)',
        d = 'diagnostics prev (wrap)',
        p = 'preview tag prev',
        t = 'tag prev',
        T = 'tag first',
        l = 'location prev',
        L = 'location first',
        b = 'buffer prev',
        B = 'buffer first',
        q = 'quickfix prev',
        Q = 'quickfix first',
  },
  [']'] = {
        -- ['%'] = 'matching group next',
        ['+'] = 'goto newer error list',
        c = 'diff (change) next',
        D = 'diagnostics next (nowrap)',
        d = 'diagnostics next (wrap)',
        p = 'preview tag next',
        t = 'tag next',
        T = 'tag last',
        l = 'location next',
        L = 'location last',
        b = 'buffer next',
        B = 'buffer last',
        q = 'quickfix next',
        Q = 'quickfix last',
  },
}

local wk = require("which-key")
wk.register(keymaps, opts)
