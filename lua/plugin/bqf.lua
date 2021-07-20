-- 'zf' requires fzf
-- since changing fzf.vim for fzf-lua we don't need this anymore
-- use `:lua require('fzf-lua').quickfix()` instead
-- pcall(vim.cmd, [[PackerLoad fzf]])

require('bqf').setup({
    auto_enable = true,
    auto_resize_height = true,
    preview = {
        auto_preview = false,
    },
    func_map = {
        ptoggleauto = '<F2>',
        ptogglemode = '<F3>',
        split       = '<C-s>',
        vsplit      = '<C-v>',
        pscrollup   = '<S-up>',
        pscrolldown = '<S-down>',
    },
    filter = {
        fzf = {
            action_for = {['ctrl-s'] = 'split'},
            extra_opts = {'--bind', 'ctrl-a:toggle-all', '--prompt', '> '}
        }
    }
})
