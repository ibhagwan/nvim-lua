-- Diag config
vim.diagnostic.config({
  underline = true,
  update_in_insert = false,
  virtual_text = {
    spacing = 4,
    source = "if_many",
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
  signs = {
    -- nvim 0.10.0 uses `nvim_buf_set_extmark`
    text = {
      [vim.diagnostic.severity.ERROR] = "", -- index:0
      [vim.diagnostic.severity.WARN]  = "", -- index:1
      [vim.diagnostic.severity.INFO]  = "", -- index:2
      [vim.diagnostic.severity.HINT]  = "󰌵", -- index:3
    },
  },
  severity_sort = true,
  float = {
    show_header = false,
    source = "if_many",
    border = "rounded",
  },
})

return {
  toggle = function()
    if not vim.b._diag_is_hidden then
      require "utils".info("Diagnostic virtual text is now hidden.")
      vim.diagnostic.hide()
      -- vim.diagnostic.disable()
    else
      require "utils".info("Diagnostic virtual text is now visible.")
      vim.diagnostic.show()
      -- vim.diagnostic.enable()
    end
    vim.b._diag_is_hidden = not vim.b._diag_is_hidden
  end
}
