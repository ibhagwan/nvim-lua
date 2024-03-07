-- https://github.com/neovim/nvim-lspconfig/wiki/UI-Customization
local sign_defs = {
  {
    name = "DiagnosticSignError",
    text = ""
    -- text = '󰅚'
  },
  {
    name = "DiagnosticSignWarn",
    text = "",
    -- text = ''
  },
  {
    name = "DiagnosticSignInfo",
    text = ""
    -- text = '',
    -- text = '',
  },
  {
    name = "DiagnosticSignHint",
    text = "󰌵"
  },
}

local sign_opt -- changes depending on nvim version

if require("utils").__HAS_NVIM_010 then
  -- nvim 0.10.0 uses `nvim_buf_set_extmark`
  -- https://github.com/ibhagwan/fzf-lua/pull/1074
  -- vim.diagnostic.config({
  --   signs = {
  --     text = {
  --       [vim.diagnostic.severity.ERROR]  = "E",  -- index:0
  --       [vim.diagnostic.severity.WARN]   = "W",  -- index:1
  --       [vim.diagnostic.severity.INFO]   = "I",  -- index:2
  --       [vim.diagnostic.severity.HINT]   = "H",  -- index:3
  --     },
  --   },
  -- })
  sign_opt = { text = {} }
  for i, def in ipairs(sign_defs) do
    table.insert(sign_opt.text, def.text)
  end
else
  -- set sign highlights to same name as sign
  -- i.e. 'DiagnosticWarn' gets highlighted with hl-DiagnosticWarn
  sign_opt = true
  for i = 1, #sign_defs do
    sign_defs[i].texthl = sign_defs[i].name
  end
  vim.fn.sign_define(sign_defs)
end

-- Diag config
vim.diagnostic.config({
  underline = true,
  update_in_insert = false,
  virtual_text = {
    spacing = 4,
    source = "always",
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
  signs = sign_opt,
  severity_sort = true,
  float = {
    show_header = false,
    source = "always",
    border = "rounded",
  },
})

return {
  toggle = function()
    if not vim.g.diag_is_hidden then
      require "utils".info("Diagnostic virtual text is now hidden.")
      vim.diagnostic.hide()
      -- vim.diagnostic.disable()
    else
      require "utils".info("Diagnostic virtual text is now visible.")
      vim.diagnostic.show()
      -- vim.diagnostic.enable()
    end
    vim.g.diag_is_hidden = not vim.g.diag_is_hidden
  end
}
