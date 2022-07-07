-- https://github.com/neovim/nvim-lspconfig/wiki/UI-Customization
local signs = {
  {
    name = "DiagnosticSignHint",
    text = ''
  },
  {
    name = "DiagnosticSignInfo",
    text = ''
    -- text = '',
    -- text = '',
  },
  {
    name = "DiagnosticSignWarn",
    text = '',
    -- text = ''
  },
  {
    name = "DiagnosticSignError",
    text = ''
    -- text = ''
  },
}

-- set sign highlights to same name as sign
-- i.e. 'DiagnosticWarn' gets highlighted with hl-DiagnosticWarn
for i=1,#signs do
  signs[i].texthl = signs[i].name
end

-- define all signs at once
vim.fn.sign_define(signs)

-- Diag config
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

return {
  toggle = function()
    if not vim.g.diag_is_hidden then
      require'utils'.info("Diagnostic virtual text is now hidden.")
      vim.diagnostic.hide()
      -- vim.diagnostic.disable()
    else
      require'utils'.info("Diagnostic virtual text is now visible.")
      vim.diagnostic.show()
      -- vim.diagnostic.enable()
    end
    vim.g.diag_is_hidden = not vim.g.diag_is_hidden
  end
}
