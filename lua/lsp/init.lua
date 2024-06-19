local ok, lspconfig = pcall(require, "lspconfig")
if not ok then return end

local lsputil = require("lspconfig.util")

-- Setup icons & handler helper functions
require("lsp.diag")
require("lsp.icons")
require("lsp.handlers")

-- Enable borders for hover/signature help
vim.lsp.handlers["textDocument/hover"] =
    vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })
vim.lsp.handlers["textDocument/signatureHelp"] =
    vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" })

-- Custom root dir function that ignores "$HOME/.git" for lua files in $HOME
-- which will then run the LSP in single file mdoe, otherwise will err with:
--   LSP[lua_ls] Your workspace is set to `$HOME`.
--   Lua language server refused to load this directory.
--   Please check your configuration.
--   [learn more here](https://luals.github.io/wiki/faq#why-is-the-server-scanning-the-wrong-folder)
-- Modified from ".../nvim-lspconfig/lua/lspconfig/server_configurations"
local lua_root_dir = function(fname)
  local root_files = {
    ".luarc.json",
    ".luarc.jsonc",
    ".luacheckrc",
    ".stylua.toml",
    "stylua.toml",
    "selene.toml",
    "selene.yml",
  }
  local root = lsputil.root_pattern(unpack(root_files))(fname)
  if root and root ~= vim.env.HOME then
    return root
  end
  root = lsputil.root_pattern "lua/" (fname)
  if root then
    return root
  end
  root = lsputil.find_git_ancestor(fname)
  return root ~= vim.env.HOME and root or nil
end

local custom_settings = {
  ["lua_ls"] = {
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
  },
  ["rust_analyzer"] = {
    -- use nightly rustfmt if exists
    -- https://github.com/rust-lang/rust-analyzer/issues/3627
    -- https://github.com/rust-lang/rust-analyzer/blob/master/docs/user/generated_config.adoc
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
  },
  ["ccls"] = {
    init_options = {
      codeLens = {
        enabled = false,
        renderInline = false,
        localVariables = false,
      }
    }
  },
}

local manually_installed_servers = {
  -- 'ccls',
  "clangd",
  "solc"
}

local all_servers = (function()
  -- use map for dedup
  local srv_map = {}
  local srv_tbl = {}
  local srv_iter = function(t)
    for _, s in ipairs(t) do
      if not srv_map[s] then
        srv_map[s] = true
        table.insert(srv_tbl, s)
      end
    end
  end
  srv_iter(manually_installed_servers)
  srv_iter(require("mason-lspconfig").get_installed_servers())
  return srv_tbl
end)()

local function is_installed(cfg)
  local cmd = cfg.document_config
      and cfg.document_config.default_config
      and cfg.document_config.default_config.cmd
      or nil
  -- server binary is executable within neovim's PATH
  return cmd and cmd[1] and vim.fn.executable(cmd[1]) == 1
end

local function make_config(srv)
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
    root_dir = srv == "lua_ls" and lua_root_dir or nil,
  }
end

for _, srv in ipairs(all_servers) do
  local cfg = make_config(srv)
  if custom_settings[srv] then
    cfg = vim.tbl_deep_extend("force", custom_settings[srv], cfg)
  end
  if is_installed(lspconfig[srv])
      -- uncomment when using "typescript-tools.nvim"
      -- and srv ~= "tsserver"
      -- jdtls is configured via 'mfussenegger/nvim-jdtls'
      and srv ~= "jdtls"
  then
    lspconfig[srv].setup(cfg)
  end
end
