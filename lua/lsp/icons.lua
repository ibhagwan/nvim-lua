-- LSP icons
local icons = {
  Text            = '',    -- 
  Method          = '',
  Function        = '',
  Constructor     = '',    -- 
  Field           = '',    --  
  Variable        = "",    --   
  Class           = '',    --   ﴯ  
  Interface       = '',    --  ﰮ
  Module          = '',
  Property        = '',
  Unit            = 'ﰩ',    --       塞
  Value           = '',
  Enum            = '',    -- ﬧ   練
  EnumMember      = '',
  Keyword         = '',    -- 
  Snippet         = '﬌',    --  
  Color           = '',    --   
  File            = '',
  Folder          = '',
  Reference       = '',    --  
  Constant        = "ﱃ",    -- ﱃ 洞   
  Struct          = "פּ",    -- 
  Event           = '',
  Operator        = '璉',   -- 
  TypeParameter   = '',
}

for kind, symbol in pairs(icons) do
  local kinds = vim.lsp.protocol.CompletionItemKind
  local index = kinds[kind]

  if index ~= nil then
    kinds[index] = symbol
  end
end
