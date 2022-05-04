local map = vim.api.nvim_buf_set_keymap

-- backward compat
local client_has_capability = function(client, capability)
  local resolved_capabilities = {
    codeLensProvider = 'code_len',
    documentFormattingProvider = 'document_formatting',
    documentRangeFormattingProvider = 'document_range_formatting',
  }
  if vim.fn.has("nvim-0.8") == 1 then
    return client.server_capabilities[capability]
  else
    assert(resolved_capabilities[capability])
    capability = resolved_capabilities[capability]
    return client.resolved_capabilities[capability]
  end
end

local on_attach = function(client, bufnr)

  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  if client.config.flags then
    client.config.flags.allow_incremental_sync = true
    client.config.flags.debounce_text_changes  = 100
  end

  local opts = { noremap=true, silent=true }

  map(bufnr, 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  map(bufnr, 'n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  map(bufnr, 'n', 'K',  '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  map(bufnr, 'n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  map(bufnr, 'n', 'gA', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  map(bufnr, 'v', 'gA', '<cmd>lua vim.lsp.buf.range_code_action()<CR>', opts)
  map(bufnr, 'n', 'gm', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  map(bufnr, 'n', 'gy', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  -- map(bufnr, 'n', 'gR', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  -- map(bufnr, 'n', '<leader>lR', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  -- use our own rename popup implementation
  map(bufnr, 'n', 'gR', '<cmd>lua require("lsp.rename").rename()<CR>', opts)
  map(bufnr, 'n', '<leader>lR', '<cmd>lua require("lsp.rename").rename()<CR>', opts)
  map(bufnr, 'n', '<leader>K',  '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  map(bufnr, 'n', '<leader>k', '<cmd>lua require("lsp.handlers").peek_definition()<CR>', opts)

  -- using fzf-lua instead
  --map(bufnr, 'n', '<leader>ls', '<cmd>lua vim.lsp.buf.document_symbol()<CR>', opts)
  --map(bufnr, 'n', '<leader>lS', '<cmd>lua vim.lsp.buf.workspace_symbol()<CR>', opts)

  map(bufnr, 'n', '<leader>lt', "<cmd>lua require'lsp.diag'.virtual_text_toggle()<CR>", opts)

  -- neovim PR #16057
  -- https://github.com/neovim/neovim/pull/16057
  if not vim.diagnostic then
    local winopts = "{ popup_opts =  { border = 'rounded' } }"
    map(bufnr, 'n', '[d', ('<cmd>lua vim.lsp.diagnostic.goto_prev(%s)<CR>'):format(winopts), opts)
    map(bufnr, 'n', ']d', ('<cmd>lua vim.lsp.diagnostic.goto_next(%s)<CR>'):format(winopts), opts)
    map(bufnr, 'n', '<leader>lc', '<cmd>lua vim.lsp.diagnostic.clear(0)<CR>', opts)
    map(bufnr, 'n', '<leader>ll', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
    map(bufnr, 'n', '<leader>lq', '<cmd>lua vim.lsp.diagnostic.set_qflist()<CR>', opts)
    map(bufnr, 'n', '<leader>lQ', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
  else
    local winopts = "{ float =  { border = 'rounded' } }"
    map(bufnr, 'n', '[d', ('<cmd>lua vim.diagnostic.goto_prev(%s)<CR>'):format(winopts), opts)
    map(bufnr, 'n', ']d', ('<cmd>lua vim.diagnostic.goto_next(%s)<CR>'):format(winopts), opts)
    map(bufnr, 'n', '<leader>lc', '<cmd>lua vim.diagnostic.reset()<CR>', opts)
    map(bufnr, 'n', '<leader>ll', '<cmd>lua vim.diagnostic.open_float(0, { scope = "line", border = "rounded" })<CR>', opts)
    map(bufnr, 'n', '<leader>lq', '<cmd>lua vim.diagnostic.setqflist()<CR>', opts)
    map(bufnr, 'n', '<leader>lQ', '<cmd>lua vim.diagnostic.setloclist()<CR>', opts)
  end

  if client_has_capability(client, 'documentFormattingProvider') then
    map(bufnr, 'n', 'gq', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
  end
  if client_has_capability(client, 'documentRangeFormattingProvider') then
    map(bufnr, 'v', 'gq', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
  end

  if client_has_capability(client, 'codeLensProvider') then
    map(bufnr, "n", "<leader>lL", "<cmd>lua vim.lsp.codelens.run()<CR>", opts)
    vim.api.nvim_command [[autocmd CursorHold,CursorHoldI,InsertLeave <buffer> lua vim.lsp.codelens.refresh()]]
  end

  -- Per buffer LSP indicators control
  if vim.b.lsp_virtual_text_enabled == nil then
    vim.b.lsp_virtual_text_enabled = true
  end

  if vim.b.lsp_virtual_text_mode == nil then
    vim.b.lsp_virtual_text_mode = 'SignsVirtualText'
  end

  if not vim.diagnostic then
    require('lsp.diag').virtual_text_set()
    require('lsp.diag').virtual_text_redraw()
  end

end

return { on_attach = on_attach }
