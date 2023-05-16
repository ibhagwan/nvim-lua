-- LSP icons
local icons = {
  Text          = "󰊄", -- 
  Method        = "󰊕",
  Function      = "",
  Constructor   = "", -- 
  Field         = "", -- 󰆧 
  Variable      = "󰆧", -- 󰆧  󰈜
  Class         = "󰌗", --   󰠱  
  Interface     = "", --  󰜰
  Module        = "󰅩",
  Property      = "",
  Unit          = "󰜫", -- 󰆧      󰑭
  Value         = "󰎠",
  Enum          = "󰘨", -- 󰘨   󰕘
  EnumMember    = "",
  Keyword       = "󰌆", -- 󰌋
  Snippet       = "󰘍", --󰅱 󰈙
  Color         = "󰏘", -- 󰌁 󰏘 
  File          = "",
  Folder        = "",
  Reference     = "󰆑", -- 󰀾 󰈇
  Constant      = "󰏿", -- 󰝅 󰔆    󰐀 󰏿 π
  Struct        = "󰙅", -- 
  Event         = "",
  Operator      = "󰒕", -- 󰆕
  TypeParameter = "",
}

for kind, symbol in pairs(icons) do
  local kinds = vim.lsp.protocol.CompletionItemKind
  local index = kinds[kind]

  if index ~= nil then
    kinds[index] = symbol
  end
end
