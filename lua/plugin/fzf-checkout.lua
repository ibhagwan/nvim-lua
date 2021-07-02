-- Define fzf-checkout only actions as branch, checkout, diff, delete
-- we use <ctrl-x> to maintain confirmity with our zsh map
-- let g:fzf_branch_actions = {
--       \ 'delete': {'keymap': 'ctrl-x'},
--       \ 'diff': {
--       \   'prompt': 'Diff> ',
--       \   'execute': 'Git diff {branch}',
--       \   'multiple': v:false,
--       \   'keymap': 'ctrl-f',
--       \   'required': ['branch'],
--       \   'confirm': v:false,
--       \ },
--       \ 'checkout': {
--       \   'prompt': 'Checkout> ',
--       \   'execute': 'echo system("{git} checkout {branch}")',
--       \   'multiple': v:false,
--       \   'keymap': 'enter',
--       \   'required': ['branch'],
--       \   'confirm': v:false,
--       \ },
--       \}

vim.g.fzf_branch_actions = {
  ['delete'] = { ['keymap'] = 'ctrl-x'},
  ['diff'] = {
    ['prompt'] = 'Diff> ',
    ['execute'] = 'Git diff {branch}',
    ['multiple'] = false,
    ['keymap'] = 'ctrl-v',
    ['required'] = {'branch'},
    ['confirm'] = false,
  },
  ['checkout'] = {
    ['prompt'] = 'Checkout> ',
    ['execute'] = 'echo system("{git} checkout {branch}")',
    ['multiple'] = false,
    ['keymap'] = 'enter',
    ['required'] = {'branch'},
    ['confirm'] = false,
  },
}


vim.api.nvim_set_keymap('n', '<Leader>zB',
    [[:lua require('utils').ensure_loaded_cmd({'fzf.vim', 'fzf-checkout.vim'}, {'FzfGBranches'})<CR>]],
    { noremap = true, silent = true })
