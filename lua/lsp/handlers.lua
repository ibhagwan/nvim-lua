if not pcall(require, "lspconfig") then
  return
end

local M = {}

local _winopts = { border = 'rounded' }
local _float_win = nil

function M.preview_location(loc, _, _)
  -- location may be LocationLink or Location
  local uri = loc.targetUri or loc.uri
  if uri == nil then return end
  local bufnr = vim.uri_to_bufnr(uri)
  if not vim.api.nvim_buf_is_loaded(bufnr) then
    vim.fn.bufload(bufnr)
  end
  local range = loc.targetRange or loc.range
  local before, after = math.min(5, range.start.line), 10
  local lines = vim.api.nvim_buf_get_lines(bufnr,
    (range.start.line - before),
    -- end is reserved, can't use 'range.end'
    (range['end'].line + after + 1),
    false)
  -- empty lines at the start don't count
  for _, l in ipairs(lines) do
    if #l>0 then break end
    before = before-1
  end
  local ft = vim.api.nvim_buf_get_option(bufnr, "filetype")
  local buf, win = vim.lsp.util.open_floating_preview(lines, ft)
  vim.api.nvim_win_set_config(win, _winopts)
  vim.api.nvim_buf_set_option(buf, 'bufhidden', 'wipe')
  vim.api.nvim_buf_set_option(buf, 'modifiable', false)
  vim.api.nvim_buf_set_option(buf, 'filetype', ft)
  vim.api.nvim_win_set_option(win, 'winhighlight', 'Normal:Normal,FloatBorder:FloatBorder')
  vim.api.nvim_win_set_option(win, 'cursorline', true)
  -- partial data, numbers make no sense
  vim.api.nvim_win_set_option(win, 'number', false)
  vim.api.nvim_win_set_cursor(win, {before+1,1})
  local pos = range.start.line == range["end"].line and
    { before+1, range.start.character+1, range["end"].character-range.start.character } or
    { before+1 }
  vim.api.nvim_win_call(win, function()
    vim.fn.matchaddpos('Cursor', {pos})
  end)
  return buf, win
end

function M.preview_location_callback(err, res, ctx, cfg)
  if err then
    vim.notify(("Error running LSP query '%s'"):format(cfg.method), vim.log.levels.ERROR)
    return nil
  end
  if res == nil or vim.tbl_isempty(res) then
    vim.notify("Unable to find code location.", vim.log.levels.WARN)
    return nil
  end
  if vim.tbl_islist(res) then
    _, _float_win = M.preview_location(res[1], ctx, cfg)
  else
    _, _float_win = M.preview_location(res, ctx, cfg)
  end
end

-- see neovim #15504
-- https://github.com/neovim/neovim/pull/15504#discussion_r698424017
M.mk_handler = function(fn)
  return function(...)
    local is_new = not select(4, ...) or type(select(4, ...)) ~= 'number'
    if is_new then
      -- function(err, result, context, config)
      fn(...)
    else
      -- function(err, method, params, client_id, bufnr, config)
      local err = select(1, ...)
      local method = select(2, ...)
      local result = select(3, ...)
      local client_id = select(4, ...)
      local bufnr = select(5, ...)
      local lspcfg = select(6, ...)
      fn(err, result, { method = method, client_id = client_id, bufnr = bufnr }, lspcfg)
    end
  end
end

function M.peek_definition()
  -- workaround for subsequent calls with the popup visuble
  if _float_win ~= nil then
    pcall(vim.api.nvim_win_hide, _float_win)
  end
  if vim.tbl_contains(vim.api.nvim_list_wins(), _float_win) then
    vim.api.nvim_set_current_win(_float_win)
  else
    local params = vim.lsp.util.make_position_params()
    return vim.lsp.buf_request(0, "textDocument/definition", params,
      M.mk_handler(M.preview_location_callback))
  end
end

return M
