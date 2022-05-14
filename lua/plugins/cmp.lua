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
    ['<Up>'] = cmp.mapping(cmp.mapping.select_prev_item(), { 'i' }),
    ['<Down>'] = cmp.mapping(cmp.mapping.select_next_item(), { 'i' }),
    ['<S-Tab>'] = cmp.mapping(cmp.mapping.select_prev_item(), { 'i', 'c' }),
    ['<Tab>'] = cmp.mapping(cmp.mapping.select_next_item(), { 'i', 'c' }),
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
    ['<CR>'] = cmp.mapping.confirm({ select = false, behavior = cmp.ConfirmBehavior.Insert })
  },

  formatting = {
    deprecated = false,
    fields = { "kind", "abbr", "menu" },
    format = function(entry, vim_item)

        local source_names = {
          path = "Path",
          buffer = "Buffer",
          cmdline = "Cmdline",
          luasnip = "LuaSnip",
          nvim_lua = "Lua",
          nvim_lsp = "LSP",
        }

        vim_item.menu = ("%-10s [%s]"):format(
          vim_item.kind,
          source_names[entry.source.name] or entry.source.name)

        -- get the item kind icon from our LSP settings
        local kind_idx = vim.lsp.protocol.CompletionItemKind[vim_item.kind]
        if tonumber(kind_idx) > 0 then
          vim_item.kind = vim.lsp.protocol.CompletionItemKind[kind_idx]
        end

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
