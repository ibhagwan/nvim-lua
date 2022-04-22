local res, cmp = pcall(require, "cmp")
if not res then
  return
end

local luasnip = require("luasnip")

cmp.setup {
  snippet = {
    -- must use a snippet engine
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },

  window = {
    -- completion = { border = 'single' },
    -- documentation = { border = 'single' },
  },

  completion = {
    -- start completion immediately
    keyword_length = 1,
  },

  sources = {
    { name = 'nvim_lsp' },
    { name = 'nvim_lua' },
    { name = 'luasnip' },
    { name = 'path' },
    { name = 'buffer' },
  },

  mapping = {
    ['<S-Tab>'] = cmp.mapping(cmp.mapping.select_prev_item(), { 'i', 'c' }),
    ['<Tab>'] = cmp.mapping(cmp.mapping.select_next_item(), { 'i', 'c' }),
    ['<Up>'] = cmp.mapping(cmp.mapping.select_prev_item(), { 'i', 'c' }),
    ['<Down>'] = cmp.mapping(cmp.mapping.select_next_item(), { 'i', 'c' }),
    ['<C-p>'] = cmp.mapping(cmp.mapping.select_prev_item(), { 'i', 'c' }),
    ['<C-n>'] = cmp.mapping(cmp.mapping.select_next_item(), { 'i', 'c' }),
    ['<S-up>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
    ['<S-down>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
    ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i' }),
    ['<C-e>'] = cmp.mapping({
      i = cmp.mapping.abort(),
      c = cmp.mapping.close(),
    }),
    ['<C-y>'] = cmp.mapping.confirm({ select = true, behavior = cmp.ConfirmBehavior.Replace }),
    ['<CR>'] = cmp.mapping.confirm({ select = true, behavior = cmp.ConfirmBehavior.Insert })
  },

  formatting = {
    deprecated = false,
    format = function(entry, vim_item)
        -- fancy icons and a name of kind
        local idx = vim.lsp.protocol.CompletionItemKind[vim_item.kind] or nil
        if tonumber(idx)>0 then
          vim_item.kind = vim.lsp.protocol.CompletionItemKind[idx]
        end

        -- set a name for each source
        vim_item.menu = ({
          path = "[Path]",
          buffer = "[Buffer]",
          luasnip = "[LuaSnip]",
          nvim_lua = "[Lua]",
          nvim_lsp = "[LSP]",
        })[entry.source.name]
        return vim_item
    end,
  },

  -- DO NOT ENABLE
  -- just for testing with nvim native completion menu
  experimental = {
    native_menu = false,
    ghost_text = true,
  },
}

-- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline('/', {
  sources = {
    { name = 'buffer' }
  }
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
  sources = cmp.config.sources({
    { name = 'path' }
  }, {
    { name = 'cmdline' }
  })
})
