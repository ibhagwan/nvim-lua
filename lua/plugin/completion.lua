local remap = vim.api.nvim_set_keymap

require'compe'.setup {
  enabled              = true;
  autocomplete         = true;
  debug                = false;
  min_length           = 2;
  preselect            = 'enable';
  throttle_time        = 80;
  source_timeout       = 200;
  incomplete_delay     = 400;
  documentation        = true;

  source = {
    path          = true;
    buffer = {
      enable = true,
      priority = 1,     -- last priority
    },
    nvim_lsp = {
      enable = true,
      priority = 10001, -- takes precedence over file completion
    },
    nvim_lua      = true;
    calc          = true;
    omni          = false;
    spell         = false;
    tags          = true;
    treesitter    = true;
    snippets_nvim = false;
    vsnip         = false;
  };
}

-- Tab completion
local t = function(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local check_back_space = function()
    local col = vim.fn.col('.') - 1
    if col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
        return true
    else
        return false
    end
end

-- Use (s-)tab to:
--- move to prev/next item in completion menuone
--- <s-tab> to force open completion menu
_G.tab_complete = function()
  if vim.fn.pumvisible() == 1 then
    return t "<C-n>"
  elseif check_back_space() then
    return t "<Tab>"
  else
    --return vim.fn['compe#complete']()
    return t "<Tab>"
  end
end
_G.s_tab_complete = function()
  if vim.fn.pumvisible() == 1 then
    return t "<C-p>"
  else
    -- If <S-Tab> is not working in your terminal, change it to <C-h>
    --return t "<S-Tab>"
    --return t "<C-n>"
    return vim.fn['compe#complete']()
  end
end

remap('i', '<Tab>', 'v:lua.tab_complete()', {expr = true})
remap('s', '<Tab>', 'v:lua.tab_complete()', {expr = true})
remap('i', '<S-Tab>', 'v:lua.s_tab_complete()', {expr = true})
remap('s', '<S-Tab>', 'v:lua.s_tab_complete()', {expr = true})

-- We use <s-tab> to reopen the completion popup instead of <c-space>
--remap('i', '<C-Space>', 'compe#complete()',         { silent = true, expr = true })
remap('i', '<CR>',      'compe#confirm(\'<CR>\')',  { silent = true, expr = true })
remap('i', '<C-e>',     'compe#close(\'<C-e>\')',   { silent = true, expr = true })
remap('i', '<C-f>',     "compe#scroll({ 'delta': +4 })", { silent = true, expr = true })
remap('i', '<C-b>',     "compe#scroll({ 'delta': -4 })", { silent = true, expr = true })

-- <cr>:     select item and close the popup menu
-- <esc>:    revert selection (stay in insert mode)
-- <ctrl-c>: revert selection (switch to normal mode)
--remap('i', '<CR>',  '(pumvisible() ? "\\<c-y>" : "\\<CR>")',         { noremap = true, expr = true })
remap('i', '<Esc>', '(pumvisible() ? "\\<c-e>" : "\\<Esc>")',        { noremap = false, expr = true })
remap('i', '<c-c>', '(pumvisible() ? "\\<c-e>\\<c-c>" : "\\<c-c>")', { noremap = true,  expr = true })

-- Make up/down arrows behave in completion popups
-- without this they move up/down but v:completed_item remains empty
remap('i', '<down>', '(pumvisible() ? "\\<C-n>" : "\\<down>")', { noremap = true, expr = true })
remap('i', '<up>',   '(pumvisible() ? "\\<C-p>" : "\\<up>")',   { noremap = true, expr = true })
