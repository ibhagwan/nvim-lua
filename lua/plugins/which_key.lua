if not pcall(require, "which-key") then
  return
end

-- If we do not wish to wait for timeoutlen
vim.api.nvim_set_keymap('n', '<Leader>?', "<Esc>:WhichKey '' n<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<Leader>?', "<Esc>:WhichKey '' v<CR>", { noremap = true, silent = true })

-- https://github.com/folke/which-key.nvim#colors
vim.cmd([[highlight default link WhichKey          Label]])
vim.cmd([[highlight default link WhichKeySeperator String]])
vim.cmd([[highlight default link WhichKeyGroup     Include]])
vim.cmd([[highlight default link WhichKeyDesc      Function]])
vim.cmd([[highlight default link WhichKeyFloat     CursorLine]])
vim.cmd([[highlight default link WhichKeyValue     Comment]])

require("which-key").setup {
    plugins = {
        marks = true, -- shows a list of your marks on ' and `
        registers = false, -- shows your registers on " in NORMAL or <C-r> in INSERT mode
        -- the presets plugin, adds help for a bunch of default keybindings in Neovim
        -- No actual key bindings are created
        spelling = {
            enabled = true, -- enabling this will show WhichKey when pressing z= to select spelling suggestions
            suggestions = 20 -- how many suggestions should be shown in the list?
        },
        presets = {
            operators = false, -- adds help for operators like d, y, ... and registers them for motion / text object completion
            motions = false, -- adds help for motions
            text_objects = false, -- help for text objects triggered after entering an operator
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
  ["<F5>"]      = 'DAP launch or continue',
  ["<F9>"]      = 'DAP toggle breakpoint',
  ["<F10>"]     = 'DAP step over',
  ["<F11>"]     = 'DAP step into',
  ["<F12>"]     = 'DAP step out',
  ["<C-\\>"]    = 'Launch scratch terminal',
  ["<C-L>"]     = 'Clear and redraw screen',
  ["<C-K>"]     = 'Fuzzy find project dirs',
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
    ['"']       = 'toggle IndentBlankline on/off',
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
    -- d = 'blackhole \'d\'',
    m = 'open :messages',
    M = 'clear :messages',
    r = 'open markdown p(r)eview',
    R = 'reload nvim configuration',
    O = 'newline above (no insert-mode)',
    o = 'newline below (no insert-mode)',
    S = 'paste before from secondary',
    s = 'paste after  from secondary',
    V = 'paste before from primary',
    v = 'paste after  from primary',
    P = 'paste before from yank register',
    p = 'paste after  from yank register',
    y = 'ANSI OSC52 yank register(0)',
    q = "toggle quickfix list on/off",
    Q = "toggle location list on/off",
    k = 'peek definition  (LSP)',
    K = 'signature help   (LSP)',
    e = {
        name = '+explore/edit',
        e = { ':NvimTreeToggle<CR>', 'nvim-tree on/off' },
        f = { ':NvimTreeFindFileToggle<CR>', 'nvim-tree current file' },
        n = 'fzf ~/.config/nvim',
        z = 'fzf ~/.config/zsh',
        i = "edit 'nvim/init.lua'",
        k = "edit 'nvim/keymaps.lua'",
        p = 'fzf nvim plugins',
        d = 'yadm ls-files',
        b = 'yadm branches',
        c = 'yadm commits (buffer)',
        C = 'yadm commits (repo)',
        s = 'yadm status',
        S = 'yadm status (fullscreen)',
    },
    g = {
        name = '+git',
        g = 'Gedit',
        s = 'git status',
        r = 'Gread (reset)',
        w = 'Gwrite (stage)',
        a = 'git add (current file)',
        A = 'git add (all)',
        b = 'git blame',
        B = 'git branches',
        c = 'git commit',
        C = 'git commits',
        d = 'git diff (buffer)',
        D = 'git diff (project)',
        S = 'git stash (current file)',
        ['-'] = 'git stash (global)',
        ['+'] = 'git stash pop',
        p = 'git push',
        P = 'git pull',
        f = 'git fetch --all',
        F = 'git fetch origin',
        l = 'git log (current file)',
        L = 'git log (global)',
        e = 'Gedit HEAD~n (vertical)',
        E = 'Gedit HEAD~n (horizontal)',
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
        n = 'open a new tab',
        c = 'close current tab',
        o = 'close all other tabs (:tabonly)',
        O = 'jump to first tab and close all others',
        z = 'zoom current tab (tmux-z)',
    },
    f = {
        name = '+find (fzf)',
        ['?'] = 'fzf-lua builtin commands',
        ["/"] = 'search history',
        [':'] = 'commands history',
        ['"'] = 'registers',
        ['3'] = 'blines <word>',
        ['8'] = 'grep <word> (buffer)',
        ['*'] = 'grep <WORD> (buffer)',
        p = 'files',
        g = 'git files',
        s = 'git status',
        S = 'git status (fullscreen)',
        C = 'git commits (project)',
        c = 'git commits (buffer)',
        H = 'file history (all)',
        h = 'file history (cwd)',
        B = 'buffer lines',
        b = 'live grep (buffer)',
        l = 'live grep (project)',
        R = 'live grep (repeat)',
        f = 'grep last search term',
        r = 'grep prompt',
        v = 'grep visual selection',
        w = 'grep word under cursor',
        W = 'grep WORD under cursor',
        M = 'man pages',
        m = 'marks',
        o = 'color schemes',
        O = 'highlight groups',
        q = 'quickfix list',
        Q = 'location list',
        x = 'neovim commands',
        k = 'neovim keymaps',
        z = 'spell suggestions under cursor',
        t = 'tags (buffer)',
        T = 'tags (project)',
    },
    z = {
        name = '+find (telescope)',
        ['?'] = 'telescope builtin commands',
        ["/"] = 'search history',
        [':'] = 'commands history',
        ['"'] = 'registers',
        b = 'fzy current buffer',
        B = 'git branches',
        s = 'git status',
        C = 'git commits (project)',
        c = 'git commits (buffer)',
        f = 'files',
        g = 'git files',
        H = 'file history (all)',
        h = 'file history (cwd)',
        r = 'regex grep',
        R = 'live grep',
        w = 'grep word under cursor',
        W = 'grep WORD under cursor',
        v = 'grep visual selection',
        x = 'neovim commands',
        k = 'keymaps',
        o = 'vim.options',
        O = 'highlight groups',
        m = 'marks',
        M = 'man pages',
        t = 'tags (buffer)',
        T = 'tags (project)',
        q = 'quickfix list',
        Q = 'location list',
        z = 'spell suggestions under cursor',
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
    d = {
        name = '+dap',
        ['?'] = 'fuzzy nvim-dap builtin commands',
        b     = 'fuzzy breakpoint list',
        x     = 'fuzzy debugger configs',
        f     = 'fuzzy frames',
        v     = 'fuzzy variables',
        c     = 'set breakpoint with condition',
        p     = 'set breakpoint with log point message',
        r     = 'toggle debugger REPL',
    },
  },
  ['g'] = {
        ['<C-V>'] = 'visually select last yanked/pasted text',
        A = 'code action (LSP)',
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
        t = 'tab prev',
        T = 'tab first',
        l = 'location prev',
        L = 'location first',
        b = 'buffer prev',
        B = 'buffer first',
        q = 'quickfix prev',
        Q = 'quickfix first',
        [']'] = 'Previous class/object start',
        ['['] = 'Previous class/object end',
  },
  [']'] = {
        -- ['%'] = 'matching group next',
        ['+'] = 'goto newer error list',
        c = 'diff (change) next',
        D = 'diagnostics next (nowrap)',
        d = 'diagnostics next (wrap)',
        t = 'tab next',
        T = 'tab last',
        l = 'location next',
        L = 'location last',
        b = 'buffer next',
        B = 'buffer last',
        q = 'quickfix next',
        Q = 'quickfix last',
        [']'] = 'Next class/object start',
        ['['] = 'Next class/object end',
  },
}

local wk = require("which-key")
wk.register(keymaps, opts)
