if not pcall(require, "lspconfig") or not pcall(require, "lspinstall") then
  return
end

-- 'lspinstall' loads 'lspconfig'
-- local nvim_lsp   = require('lspconfig')
-- requires: 'https://github.com/ray-x/lsp_signature.nvim'
local signature  = require('lsp_signature')

local on_attach = function(client, bufnr)
  if signature then
    signature.on_attach({
      bind         = true,
      hint_enable  = true,
      hint_prefix  = " ",
      hint_scheme  = "String",
      handler_opts = { border = "single" },
      decorator    = {"`", "`"}
    })
  end
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

  -- https://github.com/glepnir/lspsaga.nvim
  if pcall(require, 'lspsaga') then
      vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K',  "<cmd>lua require('lspsaga.hover').render_hover_doc()<CR>", opts)
      vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>K',  "<cmd>lua require('lspsaga.signaturehelp').signature_help()<CR>", opts)
      vim.api.nvim_buf_set_keymap(bufnr, 'n', 'ga',  "<cmd>lua require('lspsaga.codeaction').code_action()<CR>", opts)
      vim.api.nvim_buf_set_keymap(bufnr, 'v', 'ga',  ":<C-U>lua require('lspsaga.codeaction').range_code_action()<CR>", opts)
      vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gR',  "<cmd>lua require('lspsaga.rename').rename()<CR>", opts)
  end
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

  --[[
  if client.name == 'tsserver' then
    null_ls.setup {}
    ts_utils.setup {
      debug                          = false,
      disable_commands               = false,
      enable_import_on_completion    = false,
      import_on_completion_timeout   = 5000,

      eslint_enable_code_actions     = true,
      eslint_bin                     = "eslint",
      eslint_args                    = {"-f", "json", "--stdin", "--stdin-filename", "$FILENAME"},
      eslint_enable_disable_comments = true,
      eslint_enable_diagnostics      = true,
      eslint_diagnostics_debounce    = 250,

      enable_formatting              = true,
      formatter                      = "prettier",
      formatter_args                 = {"--stdin-filepath", "$FILENAME"},
      format_on_save                 = false,
      no_save_after_format           = false,

      complete_parens                = true,
      signature_help_in_parens       = false,

      update_imports_on_move         = false,
      require_confirmation_on_move   = false,
    }

    ts_utils.setup_client(client)

    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>lo', ':TSLspOrganize<CR>',   { silent = true })
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>gf', ':TSLspFixCurrent<CR>', { silent = true })
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>lI', ':TSLspImportAll<CR>',  { silent = true })
  end
  ]]
end


--[[ 'lspinstall' takes care of our nvim_lsp[].setup {}
local servers = { 'clangd', 'rust_analyzer', 'pyls', 'pyright', 'tsserver' }
for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup {
    on_attach = on_attach,
    capabilities = set_snippet_capabilities(),
  }
end
]]

-- Configure lua language server for neovim development
local lua_settings = {
  Lua = {
    runtime = {
      -- LuaJIT in the case of Neovim
      version = 'LuaJIT',
      path = vim.split(package.path, ';'),
    },
    diagnostics = {
      -- Get the language server to recognize the `vim` global
      globals = {'vim'},
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

-- config that activates keymaps and enables snippet support
local function make_config()
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities.textDocument.completion.completionItem.snippetSupport = true
  return {
    -- enable snippet support
    capabilities = capabilities,
    -- map buffer local keybindings when the language server attaches
    on_attach = on_attach,
  }
end

-- lsp-install
local function setup_servers()
  require'lspinstall'.setup()

  -- get all installed servers
  local servers = require'lspinstall'.installed_servers()
  -- ... and add manually installed servers
  if require'utils'.shell_type('ccls') then
    table.insert(servers, "ccls")
  end

  for _, server in pairs(servers) do
    local config = make_config()

    -- language specific config
    if server == "lua" then
      config.settings = lua_settings
    end
    if server == "sourcekit" then
      config.filetypes = {"swift", "objective-c", "objective-cpp"}; -- we don't want c and cpp!
    end
    if server == "clangd" or server == "ccls" then
      config.filetypes = {"c", "cpp"}; -- we don't want objective-c and objective-cpp!
    end

    require'lspconfig'[server].setup(config)
  end
end

setup_servers()

-- Automatically reload after `:LspInstall <server>` so we don't have to restart neovim
require'lspinstall'.post_install_hook = function ()
  setup_servers() -- reload installed servers
  vim.cmd("bufdo e") -- this triggers the FileType autocmd that starts the server
end

-- Setup icons & handler helper functions
require('lsp.icons')
require('lsp.handlers')
