local api = vim.api
local lsp = vim.lsp

local _winnr
local _prompt_str = "New Name❯ "

local function rename()
  local currName = vim.fn.expand("<cword>")
  local opts = {
    style = "minimal",
    border = "rounded",
    relative = "cursor",
    width = 40,
    height = 1,
    row = 1,
    col = 1,
  }
  local bufnr = api.nvim_create_buf(false, true)
  api.nvim_buf_set_option(bufnr, "bufhidden", "wipe")

  _winnr = api.nvim_open_win(bufnr, true, opts)
  api.nvim_win_set_option(_winnr, "scrolloff", 0)
  api.nvim_win_set_option(_winnr, "sidescrolloff", 0)
  api.nvim_buf_set_option(bufnr, "modifiable", true)
  api.nvim_buf_set_option(bufnr, "buftype", "prompt")

  vim.fn.prompt_setprompt(bufnr, _prompt_str)
  vim.fn.matchaddpos("Conditional", { { 1, 1, #_prompt_str } })

  -- DOES NOT WORK IN 'prompt' BUFFER
  -- api.nvim_buf_set_text(bufnr, 0, 0, 0, 0, {currName})
  -- api.nvim_buf_set_lines(bufnr, -1, -1, 1, {currName})
  -- vim.fn.append(1, currName)

  api.nvim_command("startinsert!")
  api.nvim_feedkeys(currName, "n", true)

  local map_opts = { silent = true, buffer = bufnr }
  vim.keymap.set("i", "<esc>", "<CMD>stopinsert <BAR> q!<CR>", map_opts)
  vim.keymap.set("i", "<C-c>", "<CMD>stopinsert <BAR> q!<CR>", map_opts)
  vim.keymap.set("i", "<CR>",
    "<CMD>stopinsert <BAR> lua require('lsp.rename')._rename()<CR>", map_opts)
end

-- see neovim #15504
-- https://github.com/neovim/neovim/pull/15504#discussion_r698424017
local function handler(...)
  local result
  local method
  local err = select(1, ...)
  local is_new = not select(4, ...) or type(select(4, ...)) ~= "number"
  if is_new then
    method = select(3, ...).method
    result = select(2, ...)
  else
    method = select(2, ...)
    result = select(3, ...)
  end
  if err then
    vim.notify(("Error running LSP query '%s': %s")
      :format(method, err), vim.log.levels.WARN)
    return
  end
  -- echo the resulting changes
  local utils = require "utils"
  if result and (result.changes or result.documentChanges) then
    for f, c in pairs(result.changes or result.documentChanges) do
      utils.info(([["%s", %d change(s)]])
        :format(c.textDocument and c.textDocument.uri or f, #c))
    end
  end
  vim.lsp.handlers[method](...)
end

local function _rename()
  local winnr = vim.api.nvim_get_current_win()
  if winnr ~= _winnr then return end
  local newName = vim.trim(vim.fn.getline("."):sub(#_prompt_str, -1))
  vim.api.nvim_win_close(winnr, true)
  local params = lsp.util.make_position_params()
  local currName = vim.fn.expand("<cword>")
  if not (newName and #newName > 0) or newName == currName then
    return
  end
  params.newName = newName
  lsp.buf_request(0, "textDocument/rename", params, handler)
end

return { rename = rename, _rename = _rename }
