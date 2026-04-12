local utils = require("utils")

local map = function(mode, lhs, rhs, opts)
  opts = vim.tbl_extend("keep", opts, { silent = true, buffer = 0 })
  vim.keymap.set(mode, lhs, rhs, opts)
end

return {
  setup = function()
    for _, k in ipairs({ "<leader>l?", "<leader>k" }) do
      map("n", k, function()
        vim.diagnostic.open_float({ buffer = 0, scope = "line", border = "rounded" })
      end, { desc = "show line diagnostic [LSP]" })
    end

    map("n", "<leader>lh", function()
      local enabled = not vim.lsp.inlay_hint.is_enabled({})
      vim.lsp.inlay_hint.enable(enabled)
      utils.info("LSP inlay hints %s.", enabled and "enabled" or "disabled")
    end, { desc = "toggle inlay hints [LSP]" })

    map("n", "<leader>lv", function()
      if not vim.b._diag_is_hidden then
        utils.info("Diagnostic virtual text is now hidden.")
        vim.diagnostic.hide()
      else
        utils.info("Diagnostic virtual text is now visible.")
        vim.diagnostic.show()
      end
      vim.b._diag_is_hidden = not vim.b._diag_is_hidden
    end, { desc = "toggle virtual text [LSP]" })
  end,

  setup_gq = function(e)
    -- Prioritize LSP formatting as `gq`
    local lsp_has_formatting = false
    local lsp_clients = vim.lsp.get_clients({ bufnr = e.buf })
    local lsp_keymap_set = function(m, c)
      vim.keymap.set(m, "gq", function()
        vim.lsp.buf.format({ async = true, bufnr = e.buf })
      end, {
        silent = true,
        buffer = e.buf,
        desc = string.format("format document [LSP:%s]", c.name),
      })
    end
    vim.tbl_map(function(c)
      if c:supports_method("textDocument/rangeFormatting", { bufnr = e.buf } --[[@as integer]]) then
        lsp_keymap_set("x", c)
        lsp_has_formatting = true
      end
      if c:supports_method("textDocument/formatting", { bufnr = e.buf } --[[@as integer]]) then
        lsp_keymap_set("n", c)
        lsp_has_formatting = true
      end
    end, lsp_clients)

    -- Check conform.nvim for formatters
    local ok, conform = pcall(require, "conform")
    ---@diagnostic disable-next-line: need-check-nil
    local formatters = ok and conform.list_formatters(e.buf) or {}
    if #formatters == 0 then return end
    -- If LSP isn't attached/does not support formatting also map gq to conform
    for _, lhs in ipairs({ "gQ", not lsp_has_formatting and "gq" or nil }) do
      vim.keymap.set("n", lhs, function()
        require("conform").format({ async = true, buffer = e.buf, lsp_fallback = false })
      end, {
        silent = true,
        buffer = e.buf,
        desc = string.format("format document [%s]", formatters[1].name),
      })
    end
  end
}
