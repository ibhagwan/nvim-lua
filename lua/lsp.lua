if not pcall(require, "lspconfig") or not pcall(require, "lspinstall") then
  return
end

-- 'lspinstall' loads 'lspconfig'
-- local nvim_lsp   = require('lspconfig')
-- requires: 'https://github.com/ray-x/lsp_signature.nvim'
local signature  = require('lsp_signature')

local on_attach = function(client, bufnr)
  signature.on_attach({
    bind         = true,
    hint_enable  = true,
    hint_prefix  = " ",
    hint_scheme  = "String",
    handler_opts = { border = "single" },
    decorator    = {"`", "`"}
  })
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
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>k', '<cmd>lua require("lsp").peek_definition()<CR>', opts)

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
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>lt', "<cmd>lua require'lsp'.virtual_text_toggle()<CR>", opts)

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

  --[[
  -- Autocompletion symbols
  -- https://github.com/onsails/lspkind-nvim/blob/master/lua/lspkind/init.lua
  vim.lsp.protocol.CompletionItemKind = {
    -- ' (text)';         -- text
    ' (text)';         -- text
    ' (method)';       -- method
    ' (func)';         -- function
    -- ' (func)';         -- function
    -- '全(ctor)';         -- ctor
    -- '(ctor)';       -- ctor
    ' (ctor)';         -- ctor
    ' (field)';        -- field
    ' (var)';          -- variable
    -- ' (class)';        -- class
    ' (class)';        -- class
    -- ' (interface)   -- interface
    'ﰮ (interface)';    -- interface
    -- ' (module)';       -- module
    ' (module)';       -- module
    ' (property)';     -- property
    -- ' (unit)';         -- unit
    -- ' (unit)';         -- unit
    -- ' (unit)';         -- unit
    -- ' (unit)';         -- unit
    'ﰩ (unit)';         -- unit
    ' (value)';        -- value
    '螺(enum)';         -- enum
    -- ' (keyword)';   -- keyword
    ' (keyword)';      -- keyword
    -- ' (snippet)';   -- snippet
    '﬌ (snippet)';      -- snippet
    -- ' (color)';     -- color
    ' (color)';        -- color
    ' (file)';         -- file
    -- ' (ref)';       -- reference
    ' (ref)';          -- reference
    -- ' (folder)';    -- folder
    ' (folder)';       -- folder
    ' (enum member)';  -- enum member
    -- ' (const)';     -- constant
    -- ' (const)';     -- constant
    -- ' (const)';     -- constant
    '洞(const)';        -- constant
    ' (struct)';       -- struct
    -- ' (event)';     -- event
    ' (event)';        -- event
    '璉(operator)';     -- operator
    ' (type param)';   -- type parameter
  }]]

  local lsp_symbols = {
    Text           = ' (text)',
    Method         = ' (method)',
    Function       = ' (func)',
    Ctor           = ' (ctor)',
    Field          = ' (field)',
    Variable       = ' (var)',
    Class          = ' (class)',
    Interface      = 'ﰮ (interface)',
    Module         = ' (module)',
    Property       = ' (property)',
    Unit           = 'ﰩ (unit)',
    Value          = ' (value)',
    Enum           = '練(enum)',
    Keyword        = ' (keyword)',
    Snippet        = '﬌ (snippet)',
    Color          = ' (color)',
    File           = ' (file)',
    Reference      = ' (ref)',
    Folder         = ' (folder)',
    EnumMember     = ' (enum member)',
    Constant       = 'ﱃ (const)',
    Struct         = ' (struct)',
    Event          = ' (event)',
    Operator       = '璉(operator)',
    TypeParameter  = ' (type param)',
  }

  for kind, symbol in pairs(lsp_symbols) do
    local kinds = vim.lsp.protocol.CompletionItemKind
    local index = kinds[kind]

    if index ~= nil then
        kinds[index] = symbol
    end
  end

  vim.fn.sign_define("LspDiagnosticsSignError", {
    -- text = "",
    text = "",
    texthl = "LspDiagnosticsSignError",
    linehl = "",
    numhl = "",
  })

  vim.fn.sign_define("LspDiagnosticsSignWarning", {
    -- text = "",
    text = "",
    texthl = "LspDiagnosticsSignWarning",
    linehl = "",
    numhl = "",
  })

  vim.fn.sign_define("LspDiagnosticsSignInformation", {
    -- text = "",
    -- text = "",
    text = "",
    texthl = "LspDiagnosticsSignInformation",
    linehl = "",
    numhl = "",
  })

  vim.fn.sign_define("LspDiagnosticsSignHint", {
    -- text = "",
    -- text = "",
    -- text  = "",
    text  = "",
    texthl = "LspDiagnosticsSignHint",
    linehl = "",
    numhl = "",
  })

  -- Per buffer LSP indicators control
  if vim.b.lsp_virtual_text_enabled == nil then
    vim.b.lsp_virtual_text_enabled = true
  end

  if vim.b.lsp_virtual_text_mode == nil then
    vim.b.lsp_virtual_text_mode = 'SignsVirtualText'
  end

  require('lsp').virtual_text_set()
  require('lsp').virtual_text_redraw()

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


-- Taken from https://www.reddit.com/r/neovim/comments/gyb077/nvimlsp_peek_defination_javascript_ttserver/
local M = {}
function M.preview_location(location, context, before_context)
  -- location may be LocationLink or Location (more useful for the former)
  context = context or 10
  before_context = before_context or 5
  local uri = location.targetUri or location.uri
  if uri == nil then
    return
  end
  local bufnr = vim.uri_to_bufnr(uri)
  if not vim.api.nvim_buf_is_loaded(bufnr) then
    vim.fn.bufload(bufnr)
  end
  local range = location.targetRange or location.range
  local contents =
    vim.api.nvim_buf_get_lines(bufnr, range.start.line - before_context, range["end"].line + 1 + context, false)
  local filetype = vim.api.nvim_buf_get_option(bufnr, "filetype")
  local _, winnr = vim.lsp.util.open_floating_preview(contents, filetype)
  vim.api.nvim_win_set_option(winnr, 'cursorline', true)
  vim.api.nvim_win_set_cursor(winnr, {6,1})
  return _, winnr
end

function M.preview_location_callback(_, method, result)
  local context = 10
  if result == nil or vim.tbl_isempty(result) then
    print("No location found: " .. method)
    return nil
  end
  if vim.tbl_islist(result) then
    _G.floating_buf, _G.floating_win = M.preview_location(result[1], context)
  else
    _G.floating_buf, _G.floating_win = M.preview_location(result, context)
  end
end

function M.peek_definition()
  -- workaround for subsequent calls with the popup visuble
  if _G.floating_win ~= nil then
    pcall(vim.api.nvim_win_hide, _G.floating_win)
  end
  if vim.tbl_contains(vim.api.nvim_list_wins(), _G.floating_win) then
    vim.api.nvim_set_current_win(_G.floating_win)
  else
    local params = vim.lsp.util.make_position_params()
    return vim.lsp.buf_request(0, "textDocument/definition", params, M.preview_location_callback)
  end
end

-- Toggle LSP text per buffer (wasn't working well)
--[[
M.virtual_text = {}
M.virtual_text.show = true
M.virtual_text.toggle = function()
    M.virtual_text.show = not M.virtual_text.show
    vim.lsp.diagnostic.display(
        vim.lsp.diagnostic.get(0, 1),
        0,
        1,
        {virtual_text = M.virtual_text.show}
    )
end
]]

-- Taken from and modified:
-- https://github.com/neovim/neovim/issues/14825
function M.virtual_text_none()
  vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(
    vim.lsp.diagnostic.on_publish_diagnostics, {
      signs = false,
      underline = false,
      update_in_insert = false,
      virtual_text = false
    }
  )
end

function M.virtual_text_redraw()
  -- NOTE: This function might become obsolete after the merge of
  -- 'https://github.com/neovim/neovim/pull/13748', who knows !
  for _,lsp_client_id in pairs(vim.tbl_keys(vim.lsp.buf_get_clients())) do
    vim.lsp.handlers['textDocument/publishDiagnostics'](
      nil,
      'textDocument/publishDiagnostics', {
          diagnostics = vim.lsp.diagnostic.get(0, lsp_client_id),
          uri = vim.uri_from_bufnr(0)
      },
      lsp_client_id
    )
  end
end

function M.virtual_text_set()
  vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(
    vim.lsp.diagnostic.on_publish_diagnostics, {
      severity_sort = true,
      signs = function()
        if vim.b.lsp_virtual_text_mode == 'Signs' or vim.b.lsp_virtual_text_mode == 'SignsVirtualText' then
          return true
        else
          return false
        end
      end,
      underline = false,
      update_in_insert = false,
      virtual_text = function()
        if vim.b.lsp_virtual_text_mode == 'VirtualText' or vim.b.lsp_virtual_text_mode == 'SignsVirtualText' then
          return "{ severity_limit = 'Hint', spacing = 10 }"
        else
          return false
        end
      end,
    }
  )
end

function M.virtual_text_clear()
  vim.lsp.diagnostic.clear(0)
end

function M.virtual_text_disable()
  vim.b.lsp_virtual_text_enabled = false
  M.virtual_text_none()
  M.virtual_text_clear()
  return
end

function M.virtual_text_enable()
  vim.b.lsp_virtual_text_mode = 'SignsVirtualText'
  vim.b.lsp_virtual_text_enabled = true
  M.virtual_text_set()
  M.virtual_text_redraw()
  return
end

function M.virtual_text_only_text()
  vim.b.lsp_virtual_text_mode = 'VirtualText'
  vim.b.lsp_virtual_text_enabled = true
  M.virtual_text_set()
  M.virtual_text_redraw()
  return
end

function M.virtual_text_only_signs()
  vim.b.lsp_virtual_text_mode = 'Signs'
  vim.b.lsp_virtual_text_enabled = true
  M.virtual_text_set()
  M.virtual_text_redraw()
  return
end

function M.virtual_text_toggle()
  if vim.b.lsp_virtual_text_enabled == true then
    M.virtual_text_disable()
  else
    M.virtual_text_enable()
  end
end

return M
