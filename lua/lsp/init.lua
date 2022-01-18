if not pcall(require, "lspconfig") or not pcall(require, "nvim-lsp-installer") then
  return
end

-- Setup icons & handler helper functions
require('lsp.diag')
require('lsp.icons')
require('lsp.handlers')

-- default 'on_attach' function
local on_attach = require('lsp.on_attach').on_attach

-- Enable borders for hover/signature help
vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, { border = 'rounded' })
vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = 'rounded' })

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

local ccls_settings = {
  init_options = {
    codeLens = {
      enabled = false,
      renderInline = false,
      localVariables = false,
    }
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
-- local servers = { 'ccls', 'rust_analyzer' }
local servers = { 'clangd', 'rust_analyzer' }
for _, srv in ipairs(servers) do
  local cfg = make_config()
  if srv == 'ccls' then
    cfg = vim.tbl_deep_extend("force", ccls_settings, cfg)
  end
  require("lspconfig")[srv].setup(cfg)
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
