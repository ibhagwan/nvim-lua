return {
  "stevearc/conform.nvim",
  enabled = vim.fn.has("nvim-0.10") == 1,
  event = "BufReadPost",
  config = function()
    require("conform").setup({
      formatters_by_ft = {
        lua        = { "stylua" },
        python     = { "black" },
        css        = { "prettier", "prettierd", stop_after_first = true },
        html       = { "prettier", "prettierd", stop_after_first = true },
        yaml       = { "prettier", "prettierd", stop_after_first = true },
        jsonc      = { "prettier", "prettierd", stop_after_first = true },
        javascript = { "prettier", "prettierd", stop_after_first = true },
      },
    })
  end,
  _set_gq_keymap = function(e)
    -- priortize LSP formatting as `gq`
    local lsp_has_formatting = false
    local lsp_clients = require("utils").lsp_get_clients({ bufnr = e.buf })
    local lsp_keymap_set = function(m, c)
      vim.keymap.set(m, "gq", function()
        vim.lsp.buf.format({ async = true, bufnr = e.buf })
      end, {
        silent = true,
        buffer = e.buf,
        desc = string.format("format document [LSP:%s]", c.name)
      })
    end
    vim.tbl_map(function(c)
      if c:supports_method("textDocument/rangeFormatting", { bufnr = e.buf }) then
        lsp_keymap_set("x", c)
        lsp_has_formatting = true
      end
      if c:supports_method("textDocument/formatting", { bufnr = e.buf }) then
        lsp_keymap_set("n", c)
        lsp_has_formatting = true
      end
    end, lsp_clients)
    -- check conform.nvim for formatters:
    --   (1) if we have no LSP formatter map as `gq`
    --   (2) if LSP formatter exists, map as `gQ`
    local ok, conform = pcall(require, "conform")
    local formatters = ok and conform.list_formatters(e.buf) or {}
    if #formatters > 0 then
      for _, lhs in ipairs({ "gQ", not lsp_has_formatting and "gq" or nil }) do
        vim.keymap.set("n", lhs, function()
          require("conform").format({ async = true, buffer = e.buf, lsp_fallback = false })
        end, {
          silent = true,
          buffer = e.buf,
          desc = string.format("format document [%s]", formatters[1].name)
        })
      end
    end
  end
}
