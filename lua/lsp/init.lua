if not pcall(require, "lspconfig") or not pcall(require, "nvim-lsp-installer") then
  return
end

local on_attach = function(client, bufnr)

  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  if client.config.flags then
    client.config.flags.allow_incremental_sync = true
    client.config.flags.debounce_text_changes  = 100
  end

  local opts = { noremap=true, silent=true }

  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K',  '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'ga', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'v', 'ga', ':<C-U>lua vim.lsp.buf.range_code_action()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gm', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gy', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gR', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>lR', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>K',  '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>k', '<cmd>lua require("lsp.handlers").peek_definition()<CR>', opts)

  -- already defined in our telescope mappings
  --vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>ls', '<cmd>lua vim.lsp.buf.document_symbol()<CR>', opts)
  --vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>lS', '<cmd>lua vim.lsp.buf.workspace_symbol()<CR>', opts)

  vim.api.nvim_buf_set_keymap(bufnr, 'n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '[D', '<cmd>lua vim.lsp.diagnostic.goto_prev { wrap = false }<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', ']D', '<cmd>lua vim.lsp.diagnostic.goto_next { wrap = false }<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>lc', '<cmd>lua vim.lsp.diagnostic.clear(0)<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>lQ', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>ll', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>lt', "<cmd>lua require'lsp.handlers'.virtual_text_toggle()<CR>", opts)

  if client.resolved_capabilities.document_formatting then
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gq', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
  end
  if client.resolved_capabilities.document_range_formatting then
    vim.api.nvim_buf_set_keymap(bufnr, 'v', 'gq', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
  end

  if client.resolved_capabilities.code_lens then
    vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>lL", "<cmd>lua vim.lsp.codelens.run()<CR>", opts)
    vim.api.nvim_command [[autocmd CursorHold,CursorHoldI,InsertLeave <buffer> lua vim.lsp.codelens.refresh()]]
  end

  -- Per buffer LSP indicators control
  if vim.b.lsp_virtual_text_enabled == nil then
    vim.b.lsp_virtual_text_enabled = true
  end

  if vim.b.lsp_virtual_text_mode == nil then
    vim.b.lsp_virtual_text_mode = 'SignsVirtualText'
  end

  require('lsp.handlers').virtual_text_set()
  require('lsp.handlers').virtual_text_redraw()

end

-- Lua settings
local lua_settings = {
  Lua = {
    runtime = {
      -- LuaJIT in the case of Neovim
      version = 'LuaJIT',
      path = vim.split(package.path, ';'),
    },
    diagnostics = {
      -- Get the language server to recognize the `vim` global
      globals = {
        'vim',
        'root',         -- awesomeWM
        'awesome',      -- awesomeWM
        'screen',       -- awesomeWM
        'client',       -- awesomeWM
        'clientkeys',   -- awesomeWM
        'clientbuttons',-- awesomeWM
      },
    },
    workspace = {
      -- Make the server aware of Neovim runtime files
      library = {
        [vim.fn.expand('$VIMRUNTIME/lua')] = true,
        [vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true,
      },
    },
  }
}

-- enables snippet support
local function make_config()
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities.textDocument.completion.completionItem.snippetSupport = true
  if pcall(require, 'cmp_nvim_lsp') then
    capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)
  end
  return {
    on_attach = on_attach,
    capabilities = capabilities,
  }
end

-- manually installed LSP servers
local servers = { 'ccls', 'rust_analyzer' }
for _, lsp in ipairs(servers) do
  require("lspconfig")[lsp].setup(make_config())
end

local lsp_installer = require("nvim-lsp-installer")

lsp_installer.settings {
  ui = {
    icons = {
      server_installed = "✓",
      server_pending = "➜",
      server_uninstalled = "✗"
    }
  }
}

lsp_installer.on_server_ready(function(server)
    local opts = make_config()

    if server.name == "sumneko_lua" then
      opts.settings = lua_settings
    end

    -- This setup() function is exactly the same as
    -- lspconfig's setup function (:help lspconfig-quickstart)
    server:setup(opts)
    vim.cmd [[ do User LspAttachBuffers ]]
end)

-- Setup icons & handler helper functions
require('lsp.icons')
require('lsp.handlers')
