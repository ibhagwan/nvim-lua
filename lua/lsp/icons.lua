if not pcall(require, "lspconfig") then
  return
end

--[[
-- Autocompletion symbols
-- https://github.com/onsails/lspkind-nvim/blob/master/lua/lspkind/init.lua
vim.lsp.protocol.CompletionItemKind = {
  -- ' (text)';         -- text
  ' (text)';         -- text
  ' (method)';       -- method
  ' (func)';         -- function
  -- ' (func)';         -- function
  -- '全(ctor)';         -- ctor
  -- '(ctor)';       -- ctor
  ' (ctor)';         -- ctor
  ' (field)';        -- field
  ' (var)';          -- variable
  -- ' (class)';        -- class
  ' (class)';        -- class
  -- ' (interface)   -- interface
  'ﰮ (interface)';    -- interface
  -- ' (module)';       -- module
  ' (module)';       -- module
  ' (property)';     -- property
  -- ' (unit)';         -- unit
  -- ' (unit)';         -- unit
  -- ' (unit)';         -- unit
  -- ' (unit)';         -- unit
  'ﰩ (unit)';         -- unit
  ' (value)';        -- value
  '螺(enum)';         -- enum
  -- ' (keyword)';   -- keyword
  ' (keyword)';      -- keyword
  -- ' (snippet)';   -- snippet
  '﬌ (snippet)';      -- snippet
  -- ' (color)';     -- color
  ' (color)';        -- color
  ' (file)';         -- file
  -- ' (ref)';       -- reference
  ' (ref)';          -- reference
  -- ' (folder)';    -- folder
  ' (folder)';       -- folder
  ' (enum member)';  -- enum member
  -- ' (const)';     -- constant
  -- ' (const)';     -- constant
  -- ' (const)';     -- constant
  '洞(const)';        -- constant
  ' (struct)';       -- struct
  -- ' (event)';     -- event
  ' (event)';        -- event
  '璉(operator)';     -- operator
  ' (type param)';   -- type parameter
}]]

local lsp_symbols = {
  Text           = ' (text)',
  Method         = ' (method)',
  Function       = ' (func)',
  Ctor           = ' (ctor)',
  Field          = ' (field)',
  Variable       = ' (var)',
  Class          = ' (class)',
  Interface      = 'ﰮ (interface)',
  Module         = ' (module)',
  Property       = ' (property)',
  Unit           = 'ﰩ (unit)',
  Value          = ' (value)',
  Enum           = '練(enum)',
  Keyword        = ' (keyword)',
  Snippet        = '﬌ (snippet)',
  Color          = ' (color)',
  File           = ' (file)',
  Reference      = ' (ref)',
  Folder         = ' (folder)',
  EnumMember     = ' (enum member)',
  Constant       = 'ﱃ (const)',
  Struct         = ' (struct)',
  Event          = ' (event)',
  Operator       = '璉(operator)',
  TypeParameter  = ' (type param)',
}

for kind, symbol in pairs(lsp_symbols) do
  local kinds = vim.lsp.protocol.CompletionItemKind
  local index = kinds[kind]

  if index ~= nil then
      kinds[index] = symbol
  end
end

vim.fn.sign_define("LspDiagnosticsSignError", {
  -- text = "",
  text = "",
  texthl = "LspDiagnosticsSignError",
  linehl = "",
  numhl = "",
})

vim.fn.sign_define("LspDiagnosticsSignWarning", {
  -- text = "",
  text = "",
  texthl = "LspDiagnosticsSignWarning",
  linehl = "",
  numhl = "",
})

vim.fn.sign_define("LspDiagnosticsSignInformation", {
  -- text = "",
  -- text = "",
  text = "",
  texthl = "LspDiagnosticsSignInformation",
  linehl = "",
  numhl = "",
})

vim.fn.sign_define("LspDiagnosticsSignHint", {
  -- text = "",
  -- text = "",
  -- text  = "",
  text  = "",
  texthl = "LspDiagnosticsSignHint",
  linehl = "",
  numhl = "",
})
