if not pcall(require, "lspconfig") then
  return
end

-- Taken from https://www.reddit.com/r/neovim/comments/gyb077/nvimlsp_peek_defination_javascript_ttserver/
local M = {}

local _winopts = {
    border = { '╭', '─', '╮', '│', '╯', '─', '╰', '│' },
}

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
  vim.api.nvim_win_set_config(winnr, _winopts)
  vim.api.nvim_win_set_option(winnr, 'winhighlight', 'Normal:Normal,FloatBorder:FloatBorder')
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
