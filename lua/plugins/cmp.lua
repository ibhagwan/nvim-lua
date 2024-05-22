local M = {
  "hrsh7th/nvim-cmp",
  event = { "InsertEnter", "CmdLineEnter" },
  dependencies = {
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-cmdline",
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-nvim-lua",
    not vim.snippet and "saadparwaiz1/cmp_luasnip" or nil,
  },
}

local winopts = {
  -- NOT REQUIRED
  -- Set left|right border chars to invisible spaces for scollbar
  -- border = { "", "", "", "\xc2\xa0", "", "", "", "\xc2\xa0" },
  winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,CursorLine:PmenuSel,Search:None",
}

M.config = function()
  local cmp = require("cmp")

  cmp.setup {
    snippet = {
      -- must use a snippet engine
      expand = function(args)
        if vim.snippet then
          vim.snippet.expand(args.body)
        else
          -- Only installed with neovim < 0.10
          require("luasnip").lsp_expand(args.body)
        end
      end,
    },

    window = {
      completion = winopts,
      documentation = winopts,
      -- completion = cmp.config.window.bordered(),
      -- documentation = cmp.config.window.bordered(),
    },

    completion = {
      -- start completion immediately
      keyword_length = 1,
    },

    sources = {
      { name = "nvim_lsp" },
      { name = "nvim_lua" },
      { name = "path" },
      { name = "buffer" },
      not vim.snippet and { name = "luasnip" } or nil,
    },

    ---@diagnostic disable-next-line: missing-fields
    view = { entries = { follow_cursor = true } },

    -- we use 'comleteopt=...,noselect' but we still want cmp to autoselect
    -- an item if recommended by the LSP server (try with gopls, rust_analyzer)
    -- uncomment to disable
    -- preselect = cmp.PreselectMode.None,

    mapping = {
      ["<Up>"] = cmp.mapping(cmp.mapping.select_prev_item(), { "i" }),
      ["<Down>"] = cmp.mapping(cmp.mapping.select_next_item(), { "i" }),
      ["<S-Tab>"] = cmp.mapping(cmp.mapping.select_prev_item(), { "i", "c" }),
      ["<Tab>"] = cmp.mapping(cmp.mapping.select_next_item(), { "i", "c" }),
      ["<C-p>"] = cmp.mapping(cmp.mapping.select_prev_item(), { "i", "c" }),
      ["<C-n>"] = cmp.mapping(cmp.mapping.select_next_item(), { "i", "c" }),
      ["<C-k>"] = cmp.mapping(cmp.mapping.select_prev_item(), { "i", "c" }),
      ["<C-j>"] = cmp.mapping(cmp.mapping.select_next_item(), { "i", "c" }),
      ["<S-up>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "c" }),
      ["<S-down>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "c" }),
      ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i" }),
      ["<C-b>"] = cmp.mapping(
        cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select, count = 20 }),
        { "i", "c" }
      ),
      ["<C-f>"] = cmp.mapping(
        cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select, count = 20 }),
        { "i", "c" }
      ),
      ["<C-e>"] = cmp.mapping({
        i = cmp.mapping.abort(),
        c = cmp.mapping.close(),
      }),
      ["<C-y>"] = cmp.mapping.confirm({ select = true, behavior = cmp.ConfirmBehavior.Replace }),
      -- ['<CR>'] = cmp.mapping.confirm({ select = false, behavior = cmp.ConfirmBehavior.Insert })
      -- close the cmp interface if no item is selected, I find it more
      -- intuitive when using LSP autoselect (instead of sending <CR>)
      ["<CR>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          if cmp.get_selected_entry() then
            cmp.confirm({ select = false, cmp.ConfirmBehavior.Insert })
          else
            cmp.close()
          end
        else
          fallback()
        end
      end),
    },

    formatting = {
      expandable_indicator = true,
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

        -- set max width of the LSP item or we can't see the docs
        local max_width = math.floor(vim.o.columns * 0.40)
        vim_item.abbr = vim_item.abbr:sub(1, max_width)

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
  cmp.setup.cmdline("/", {
    sources = {
      { name = "buffer" }
    }
  })

  -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline(":", {
    sources = cmp.config.sources({
      { name = "path" }
    }, {
      { name = "cmdline" }
    })
  })
end

return M
