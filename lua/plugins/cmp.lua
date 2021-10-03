local remap = vim.api.nvim_set_keymap

local t = function(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local check_back_space = function()
  local col = vim.fn.col('.') - 1
  return col == 0 or vim.fn.getline('.'):sub(col, col):match('%s')
end

local cmp = require('cmp')
local lspkind = require('lsp.icons').map

cmp.setup {
  -- must define this if we aren't using a snippet engine
  snippet = {
    expand = function(args)
      require("luasnip").lsp_expand(args.body)
    end,
  },

  completion = {
    keyword_length = 2,
  },

  sources = {
    { name = 'nvim_lsp' },
    { name = 'path' },
    { name = 'buffer' },
  },

  mapping = {
    ['<Tab>'] = function(fallback)
      if vim.fn.pumvisible() == 1 then
        vim.fn.feedkeys(t('<C-n>'), 'n')
      elseif check_back_space() then
        vim.fn.feedkeys(t('<Tab>'), 'n')
      else
        fallback()
      end
    end,
    ['<S-Tab>'] = function(fallback)
      if vim.fn.pumvisible() == 1 then
        vim.fn.feedkeys(t('<C-p>'), 'n')
      else
        fallback()
      end
    end,
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-n>'] = cmp.mapping.select_next_item(),
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.close(),
    ['<CR>'] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    }),
  },

  -- disabled while bugged (popup doesn't close on '<C-c>'
  documentation = false,
  --[[ documentation = {
    border       = { '╭', '─', '╮', '│', '╯', '─', '╰', '│' },
    winhighlight = 'Normal:Normal,FloatBorder:FloatBorder',
  }, ]]

  formatting = {
    deprecated = false,
    format = function(entry, vim_item)
        -- fancy icons and a name of kind
        local kind = lspkind[vim_item.kind]
        if kind then vim_item.kind = kind end

        -- set a name for each source
        vim_item.menu = ({
          path = "[Path]",
          buffer = "[Buffer]",
          nvim_lsp = "[LSP]",
          luasnip = "[LuaSnip]",
          nvim_lua = "[Lua]",
          latex_symbols = "[Latex]",
        })[entry.source.name]
        return vim_item
    end,
  },
}

-- <cr>:     select item and close the popup menu
-- <esc>:    revert selection (stay in insert mode)
-- <ctrl-c>: revert selection (switch to normal mode)
--remap('i', '<CR>',  '(pumvisible() ? "\\<c-y>" : "\\<CR>")',         { noremap = true, expr = true })
remap('i', '<Esc>', '(pumvisible() ? "\\<c-e>" : "\\<Esc>")',        { noremap = false, expr = true })
remap('i', '<c-c>', '(pumvisible() ? "\\<c-e>\\<Esc>" : "\\<c-c>")', { noremap = true,  expr = true })

-- Make up/down arrows behave in completion popups
-- without this they move up/down but v:completed_item remains empty
remap('i', '<down>', '(pumvisible() ? "\\<C-n>" : "\\<down>")', { noremap = true, expr = true })
remap('i', '<up>',   '(pumvisible() ? "\\<C-p>" : "\\<up>")',   { noremap = true, expr = true })