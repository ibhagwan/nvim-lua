-- LSP icons
local icons = {
  -- Text           = '',
  Text           = '',
  Method         = '',
  Function       = '',
  -- Constructor   = '',
  Constructor    = '',
  Field          = '',
  Variable       = '',
  -- Class          = '',
  -- Class          = '',
  Class          = '',
  -- Interface      = '',
  Interface      = 'ﰮ',
  Module         = '',
  Property       = '',
  -- Unit           = '',
  -- Unit           = '',
  -- Unit           = '',
  Unit           = 'ﰩ',
  Value          = '',
  -- Enum           = '',
  Enum           = 'ﬧ',
  EnumMember     = '',
  -- Keyword        = '',
  Keyword        = '',
  -- Snippet        = '',
  Snippet        = '﬌',
  -- Color          = '',
  Color          = '',
  File           = '',
  Folder         = '',
  -- Reference      = '',
  Reference      = '',
  -- Constant       = '',
  -- Constant       = '',
  -- Constant       = '',
  -- Constant       = '',
  Constant       = 'ﱃ',
  Struct         = '',
  Event          = '',
  Operator       = '',
  TypeParameter  = '',
}

for kind, symbol in pairs(icons) do
  local kinds = vim.lsp.protocol.CompletionItemKind
  local index = kinds[kind]

  if index ~= nil then
    kinds[index] = symbol
  end
end
