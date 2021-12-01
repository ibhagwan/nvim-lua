local M = {}

-- https://github.com/neovim/nvim-lspconfig/wiki/UI-Customization

-- The old LSP diagnostics prior to:
-- https://github.com/neovim/neovim/commit/064411ea7ff825aed3d4e01207914ed61d7ee79d
-- local _is_legacy = not vim.tbl_isempty(vim.fn.sign_getdefined('LspDiagnosticsSignInformation'))

local signs = {
  ["Hint"]   = { icon = '', hl = 'Identifier' },
  ["Info"]   = { icon = '', hl = 'Special' },
  ["Warn"]   = { icon = '', hl = 'DiffChange' },
  ["Error"]  = { icon = '', hl = 'ErrorMsg' },
  -- ["Hint"]   = '',
  -- ["Info"]   = '',
  -- ["Info"]   = '',
  -- ["Warn"]   = '',
  -- ["Error"]  = '',
}

local sign_prefix = 'DiagnosticSign'
if not vim.diagnostic then
  sign_prefix = 'LspDiagnosticsSign'
  -- legacy signs:
  -- LspDiagnosticsSign does not have "Info", "Warn"
  -- instead has "Information", "Warning"
  local function tbl_swap(t, old, new)
    t[new] = t[old]
    t[old] = nil
  end
  tbl_swap(signs, "Warn", "Warning")
  tbl_swap(signs, "Info", "Information")
else
  -- virtual text highlights only relevant in non-legacy
  for severity, t in pairs(signs) do
    local hl = 'DiagnosticVirtualText' .. severity
    vim.cmd(('hi link %s %s'):format(hl, t.hl))
  end
end

-- Define the diag signs
for severity, t in pairs(signs) do
  local hl = sign_prefix .. severity
  vim.fn.sign_define(hl, { text = t.icon, texthl = t.hl, linehl = '', numhl = '' })
end

-- Diag config
if vim.diagnostic then
  vim.diagnostic.config({
    underline = true,
    update_in_insert = false,
    virtual_text = {
      spacing = 4,
      source = 'always',
      severity = {
        min = vim.diagnostic.severity.HINT,
      },
      -- format = function(diagnostic)
        -- if diagnostic.severity == vim.diagnostic.severity.ERROR then
        --   return string.format('E: %s', diagnostic.message)
        -- end
        -- return ("%s"):format(diagnostic.message)
      -- end,
    },
    signs = true,
    severity_sort = true,
    float = {
      show_header = false,
      source = 'always',
      border = 'rounded',
    },
  })
end

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
  local method = 'textDocument/publishDiagnostics'
  local pr_15504 = false
  if vim.fn.has('nvim-0.5.1') == 1 then pr_15504 = true end
  for _, lsp_client_id in pairs(vim.tbl_keys(vim.lsp.buf_get_clients())) do
    -- https://github.com/neovim/neovim/pull/15504
    local params = {
      diagnostics = vim.lsp.diagnostic.get(0, lsp_client_id),
      uri = vim.uri_from_bufnr(0)
    }
    if pr_15504 then
      vim.lsp.handlers[method](
        nil, params, { method = method, client_id = lsp_client_id })
    else
      vim.lsp.handlers[method](nil, method, params, lsp_client_id)
    end
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
          return { severity_limit = 'Hint', spacing = 10 }
          -- return "{ severity_limit = 'Hint', spacing = 10 }"
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
end

function M.virtual_text_enable()
  vim.b.lsp_virtual_text_mode = 'SignsVirtualText'
  vim.b.lsp_virtual_text_enabled = true
  M.virtual_text_set()
  M.virtual_text_redraw()
end

function M.virtual_text_only_text()
  vim.b.lsp_virtual_text_mode = 'VirtualText'
  vim.b.lsp_virtual_text_enabled = true
  M.virtual_text_set()
  M.virtual_text_redraw()
end

function M.virtual_text_only_signs()
  vim.b.lsp_virtual_text_mode = 'Signs'
  vim.b.lsp_virtual_text_enabled = true
  M.virtual_text_set()
  M.virtual_text_redraw()
end

function M.virtual_text_toggle()
  if vim.diagnostic then
    if vim.b.lsp_virtual_text_enabled then
      -- vim.diagnostic.hide(0, 0)
      vim.diagnostic.disable()
    else
      -- vim.diagnostic.show(0)
      vim.diagnostic.enable()
    end
    vim.b.lsp_virtual_text_enabled = not vim.b.lsp_virtual_text_enabled
  else
    if vim.b.lsp_virtual_text_enabled == true then
      M.virtual_text_disable()
    else
      M.virtual_text_enable()
    end
  end
end

return M
