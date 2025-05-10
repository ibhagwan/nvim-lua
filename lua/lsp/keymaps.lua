local utils = require("utils")

local map = function(mode, lhs, rhs, opts)
  opts = vim.tbl_extend("keep", opts, { silent = true, buffer = 0 })
  vim.keymap.set(mode, lhs, rhs, opts)
end

local setup = function()
  map("n", "<leader>ll", function()
    vim.diagnostic.open_float({ buffer = 0, scope = "line", border = "rounded" })
  end, { desc = "show line diagnostic [LSP]" })

  map("n", "<leader>lh", function()
    local enabled = not vim.lsp.inlay_hint.is_enabled({})
    vim.lsp.inlay_hint.enable(enabled)
    utils.info(string.format("LSP inlay hints %s.", enabled and "enabled" or "disabled"))
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

  local wk = package.loaded["which-key"]
  if wk then
    wk.add({
      "<leader>lh",
      desc = function()
        local enabled = vim.lsp.inlay_hint.is_enabled({})
        return string.format("%s inlay hints [LSP]", enabled and "hide" or "show")
      end,
      buffer = 0,
      nowait = false,
      remap = false
    })
    wk.add({
      "<leader>lv",
      desc = function()
        return string.format("%s virtual text [LSP]", vim.b._diag_is_hidden and "show" or "hide")
      end,
      buffer = 0,
      nowait = false,
      remap = false
    })
  end
end

return { setup = setup }
