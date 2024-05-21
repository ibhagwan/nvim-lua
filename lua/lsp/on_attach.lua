-- backward compat
-- local client_has_capability = function(client, capability)
--   local resolved_capabilities = {
--     codeLensProvider = "code_len",
--     documentFormattingProvider = "document_formatting",
--     documentRangeFormattingProvider = "document_range_formatting",
--   }
--   if vim.fn.has("nvim-0.8") == 1 then
--     return client.server_capabilities[capability]
--   else
--     assert(resolved_capabilities[capability])
--     capability = resolved_capabilities[capability]
--     return client.resolved_capabilities[capability]
--   end
-- end

local map = function(mode, lhs, rhs, opts)
  opts = vim.tbl_extend("keep", opts, { silent = true, buffer = true })
  vim.keymap.set(mode, lhs, rhs, opts)
end

local on_attach = function(client, bufnr)
  vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

  if client.config.flags then
    client.config.flags.allow_incremental_sync = true
    client.config.flags.debounce_text_changes  = 100
  end


  map("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>",
    { desc = "hover information [LSP]" })
  map("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>",
    { desc = "goto definition [LSP]" })
  map("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>",
    { desc = "goto declaration [LSP]" })
  map("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>",
    { desc = "goto reference [LSP]" })
  map("n", "gm", "<cmd>lua vim.lsp.buf.implementation()<CR>",
    { desc = "goto implementation [LSP]" })
  map("n", "gy", "<cmd>lua vim.lsp.buf.type_definition()<CR>",
    { desc = "goto type definition [LSP]" })
  map("n", "gA", "<cmd>lua vim.lsp.buf.code_action()<CR>",
    { desc = "code actions [LSP]" })
  map("v", "gA", "<cmd>lua vim.lsp.buf.range_code_action()<CR>",
    { desc = "range code actions [LSP]" })
  -- use our own rename popup implementation
  map("n", "gR", [[<cmd>lua require("lsp.rename").rename()<CR>]],
    { desc = "rename [LSP]" })
  map("n", "<leader>lR", [[<cmd>lua require("lsp.rename").rename()<CR>]],
    { desc = "rename [LSP]" })
  map("n", "<leader>K", "<cmd>lua vim.lsp.buf.signature_help()<CR>",
    { desc = "signature help [LSP]" })
  map("n", "<leader>k", [[<cmd>lua require("lsp.handlers").peek_definition()<CR>]],
    { desc = "peek definition [LSP]" })
  map("n", "<leader>lh", function()
    vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({}))
  end, { desc = "toggle inlay hints [LSP]" })

  -- using fzf-lua instead
  --map('n', '<leader>ls', '<cmd>lua vim.lsp.buf.document_symbol()<CR>')
  --map('n', '<leader>lS', '<cmd>lua vim.lsp.buf.workspace_symbol()<CR>')

  map("n", "<leader>lt", "<cmd>lua require'lsp.diag'.toggle()<CR>",
    { desc = "toggle virtual text [LSP]" })

  -- neovim PR #16057
  -- https://github.com/neovim/neovim/pull/16057
  local winopts = "{ float =  { border = 'rounded' } }"
  map("n", "[d", ("<cmd>lua vim.diagnostic.goto_prev(%s)<CR>"):format(winopts),
    { desc = "previous diagnostic [LSP]" })
  map("n", "]d", ("<cmd>lua vim.diagnostic.goto_next(%s)<CR>"):format(winopts),
    { desc = "next diagnostic [LSP]" })
  map("n", "<leader>lc", "<cmd>lua vim.diagnostic.reset()<CR>",
    { desc = "clear diagnostics [LSP]" })
  map("n", "<leader>l?",
    [[<cmd>lua vim.diagnostic.open_float(0, { scope = "line", border = "rounded" })<CR>]],
    { desc = "show line diagnostic [LSP]" })
  map("n", "<leader>lq", "<cmd>lua vim.diagnostic.setqflist()<CR>",
    { desc = "send diagnostics to quickfix [LSP]" })
  map("n", "<leader>lQ", "<cmd>lua vim.diagnostic.setloclist()<CR>",
    { desc = "send diagnostics to loclist [LSP]" })

  -- if client_has_capability(client, "codeLensProvider") then
  --   map("n", "<leader>lL", "<cmd>lua vim.lsp.codelens.run()<CR>",
  --     { desc = "[LSP] code lens" })
  --   vim.api.nvim_command
  --     [[autocmd CursorHold,CursorHoldI,InsertLeave <buffer> lua vim.lsp.codelens.refresh()]]
  -- end
end

return { on_attach = on_attach }
