local ok, lspconfig = pcall(require, "lspconfig")
if not ok then return end

-- Setup icons & handler helper functions
require("lsp.diag")
require("lsp.icons")
require("lsp.handlers")

-- Enable borders for hover/signature help
vim.lsp.handlers["textDocument/hover"] =
    vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })
vim.lsp.handlers["textDocument/signatureHelp"] =
    vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" })

local __settings = {}

-- Lua settings
local runtime_path = vim.split(package.path, ";")
table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")

__settings["lua_ls"] = {
  -- uncomment to enable trace logging into:
  -- '~/.local/share/nvim/mason/packages/lua-language-server/log'
  -- cmd = { "lua-language-server", "--loglevel=trace" },
  settings = {
    Lua = {
      telemetry = { enable = false },
      -- removes the annoying "Do you need to configure your work environment as"
      -- when opening a lua project that doesn't have a '.luarc.json'
      workspace = { checkThirdParty = false }
    }
  }
}

-- use nightly rustfmt if exists
-- https://github.com/rust-lang/rust-analyzer/issues/3627
-- https://github.com/rust-lang/rust-analyzer/blob/master/docs/user/generated_config.adoc
__settings["rust_analyzer"] = {
  settings = {
    ["rust-analyzer"] = {
      rustfmt = {
        extraArgs = { "+nightly", },
        -- overrideCommand = {
        --   "rustup",
        --   "run",
        --   "nightly",
        --   "--",
        --   "rustfmt",
        --   "--edition",
        --   "2021",
        --   "--",
        -- },
      },
    }
  }
}

__settings["ccls"] = {
  init_options = {
    codeLens = {
      enabled = false,
      renderInline = false,
      localVariables = false,
    }
  }
}


local function make_config()
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  -- enables snippet support
  capabilities.textDocument.completion.completionItem.snippetSupport = true
  -- enables LSP autocomplete
  local cmp_loaded, cmp_lsp = pcall(require, "cmp_nvim_lsp")
  if cmp_loaded then
    capabilities = cmp_lsp.default_capabilities()
  end
  return {
    on_attach = require("lsp.on_attach").on_attach,
    capabilities = capabilities,
  }
end

local servers = {
  "lua_ls",
  "rust_analyzer",
  "gopls",
  "pylsp",
  "clangd",
  -- 'ccls',
  "tsserver",
  "solc"
}

local function is_installed(cfg)
  local cmd = cfg.document_config
      and cfg.document_config.default_config
      and cfg.document_config.default_config.cmd or nil
  -- server globally installed?
  if cmd and cmd[1] and vim.fn.executable(cmd[1]) == 1 then
    return true
  end
  -- otherwise, check if installed via 'mason-lspconfig'
  local mason_installed = false
  local mason_servers = require "mason-lspconfig".get_installed_servers()
  for _, s in ipairs(mason_servers) do
    if s == cfg.name then
      mason_installed = true
    end
  end
  return mason_installed
end

for _, srv in ipairs(servers) do
  local cfg = make_config()
  if __settings[srv] then
    cfg = vim.tbl_deep_extend("force", __settings[srv], cfg)
  end
  if is_installed(lspconfig[srv]) then
    lspconfig[srv].setup(cfg)
  end
end
