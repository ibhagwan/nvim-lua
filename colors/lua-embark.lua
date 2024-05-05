local C       = {
  space0      = { gui = "#100E23", cterm = 232, cterm16 = 0 },
  space1      = { gui = "#1e1c31", cterm = 233, cterm16 = "NONE" },
  space2      = { gui = "#2D2B40", cterm = 233, cterm16 = "NONE" },
  space3      = { gui = "#3E3869", cterm = 236, cterm16 = 8 },
  space4      = { gui = "#585273", cterm = 236, cterm16 = 8 },
  astral0     = { gui = "#8A889D", cterm = 252, cterm16 = 15 },
  astral1     = { gui = "#cbe3e7", cterm = 253, cterm16 = 7 },
  red         = { gui = "#F48FB1", cterm = 204, cterm16 = 1 },
  dark_red    = { gui = "#F02E6E", cterm = 203, cterm16 = 9 },
  green       = { gui = "#A1EFD3", cterm = 120, cterm16 = 2 },
  dark_green  = { gui = "#7fe9c3", cterm = 119, cterm16 = 10 },
  yellow      = { gui = "#ffe6b3", cterm = 228, cterm16 = 3 },
  dark_yellow = { gui = "#F2B482", cterm = 215, cterm16 = 11 },
  blue        = { gui = "#91ddff", cterm = 159, cterm16 = 4 },
  dark_blue   = { gui = "#78a8ff", cterm = 135, cterm16 = 13 },
  purple      = { gui = "#d4bfff", cterm = 141, cterm16 = 5 },
  dark_purple = { gui = "#7676ff", cterm = 75, cterm16 = 12 },
  cyan        = { gui = "#ABF8F7", cterm = 122, cterm16 = 6 },
  dark_cyan   = { gui = "#63f2f1", cterm = 121, cterm16 = 14 },
  diff_del    = { gui = "#411E35", cterm = 203, cterm16 = 9 },
  diff_add    = { gui = "#133246", cterm = 119, cterm16 = 10 },
  diff_change = { gui = "#22244C", cterm = 215, cterm16 = 11 },
  -- addded to orignal embark
  NONE        = { gui = "NONE", cterm = "NONE", cterm16 = "NONE" },
  white       = { gui = "#E4E4E4", cterm = 145, cterm16 = 7 },
  statusline  = { gui = "#7E9CD8", cterm = 236, cterm16 = 8 },
  grey0       = { gui = "#656A7c", cterm = 238, cterm16 = 15 },
  grey1       = { gui = "#56687E", cterm = 237, cterm16 = 15 },
}

C.bg          = C.space1
C.bg_dark     = C.space0
C.bg_bright   = C.space4
C.norm        = C.astral1
C.norm_subtle = C.astral0
C.visual      = C.space3
C.head_a      = C.dark_blue
C.head_b      = C.blue
C.head_c      = C.dark_cyan

if vim.g.embark_transparent == true then
  C.bg     = C.NONE
  C.space3 = C.grey1
  C.space4 = C.grey0
  C.visual = C.space3
  -- C.norm_subtle = C.grey0
end

local HLS = {
  -- Common groups, generated with `:help E669`
  { "Comment",                       { fg = C.norm_subtle, italic = true } },
  { "Constant",                      { fg = C.purple } },
  { "String",                        { fg = C.yellow } },
  -- { "Character",                  { fg = C.yellow } },
  { "Number",                        { fg = C.dark_yellow } },
  { "Boolean",                       { fg = C.dark_yellow } },
  { "Float",                         { fg = C.dark_yellow } },
  -- { "Identifier",                    { fg = C.norm } },
  { "Identifier",                    { fg = C.blue } },
  { "Function",                      { fg = C.red } },
  { "Statement",                     { fg = C.green } },
  -- { "Conditional",                { link = "Statement" } },
  -- { "Repeat",                     { link = "Statement" } },
  { "Label",                         { fg = C.dark_blue } },
  { "Operator",                      { fg = C.dark_cyan } },
  { "Keyword",                       { fg = C.green } },
  -- { "Exception",                  { link = "Statement" } },
  { "PreProc",                       { fg = C.green } },
  -- { "Include",                    { link = "PreProc" } },
  -- { "Define",                     { link = "PreProc" } },
  -- { "Macro",                      { link = "PreProc" } },
  -- { "PreCondit",                  { link = "PreProc" } },
  { "Type",                          { fg = C.purple } },
  -- { "StorageClass",               { link = "Type" } },
  -- { "Structure",                  { link = "Type" } },
  -- { "Typedef",                    { link = "Type" } },
  { "Special",                       { fg = C.cyan } },
  -- { "SpecialChar",                { link = "Special" } },
  -- { "Tag",                        { link = "Special" } },
  -- { "Delimiter",                  { link = "Special" } },
  -- { "SpecialComment",             { link = "Special" } },
  -- { "Debug",                      { link = "Special" } },
  { "Underlined",                    { fg = C.dark_cyan, underline = true } },
  { "Ignore",                        { fg = C.bg } },
  { "Error",                         { fg = C.dark_red, bg = C.bg_dark, bold = true } },
  { "Todo",                          { fg = C.dark_yellow, bg = C.bg, bold = true } },
  -- Generated with `:help highlight-default`
  { "ColorColumn",                   { bg = C.space2 } },
  { "Conceal",                       { fg = C.norm } },
  { "Cursor",                        { bg = C.blue, fg = C.bg_bright } },
  { "CursorColumn",                  { bg = C.bg_dark } },
  { "CursorLine",                    { bg = C.bg_dark } },
  { "Directory",                     { fg = C.purple } },
  { "DiffAdd",                       { bg = C.diff_add } },
  -- { "DiffChange",                 { fg = C.diff_change, underline = true } },
  { "DiffChange",                    { bg = C.space2 } },
  { "DiffDelete",                    { fg = C.visual, bg = C.diff_del } },
  -- { "DiffText",                   { fg = C.bg, bg = C.diff_change, bold = true } },
  { "DiffText",                      { bg = C.diff_change } },
  { "ErrorMsg",                      { fg = C.dark_red } },
  { "WinSeparator",                  { fg = C.space3 } },
  -- Links on Linux to  `NormalFloat` since 0.1.10
  { "FloatBorder",                   { link = "WinSeparator" } },
  { "Folded",                        { fg = C.dark_purple } },
  { "FoldColumn",                    { fg = C.dark_purple } },
  { "SignColumn",                    { fg = C.green } },
  { "IncSearch",                     { fg = C.bg, bg = C.yellow } },
  { "LineNr",                        { fg = C.space4 } },
  { "CursorLineNr",                  { bg = C.bg_dark, fg = C.blue, bold = true } },
  { "MatchParen",                    { bg = C.bg_dark, fg = C.purple, bold = true, underline = true } },
  { "ModeMsg",                       { fg = C.norm_subtle, bold = true } },
  { "MoreMsg",                       { link = "ModeMsg" } },
  { "NonText",                       { fg = C.bg_bright } },
  -- { "EndOfBuffer",                { link = "NonText" } },
  -- { "Whitespace",                 { link = "NonText" } },
  { "Normal",                        { bg = C.bg, fg = C.norm } },
  -- { "VertSplit",                  { link = "Normal" } },
  { "Pmenu",                         { fg = C.norm, bg = C.space2 } },
  -- { "NormalFloat",                { link = "Pmenu" } },
  { "PmenuSel",                      { fg = C.purple, bg = C.bg } },
  { "PmenuSbar",                     { fg = C.norm, bg = C.bg_dark } },
  -- { "PmenuThumb",                    { fg = C.norm, bg = C.bg_dark } },
  { "PmenuThumb",                    { fg = C.norm, bg = C.statusline } },
  { "Question",                      { fg = C.green } },
  { "Search",                        { bg = C.dark_yellow, fg = C.bg } },
  -- { "Substitute",                 { link = "Search" } },
  -- { "QuickFixLine",               { link = "Search" } },
  { "SpecialKey",                    { fg = C.blue } },
  { "SpellBad",                      { fg = C.dark_red, underline = true } },
  { "SpellCap",                      { fg = C.green, underline = true } },
  { "SpellLocal",                    { fg = C.dark_green, underline = true } },
  { "SpellRare",                     { fg = C.red, underline = true } },
  -- { "StatusLine",                    { bg = C.bg_dark, fg = C.norm } },
  -- { "StatusLineNC",                  { bg = C.bg_dark, fg = C.norm_subtle } },
  { "StatusLine",                    { bg = C.statusline, fg = C.bg_dark } },
  { "StatusLineNC",                  { bg = C.bg_dark, fg = C.norm_subtle } },
  { "TabLine",                       { fg = C.norm_subtle, bg = C.bg } },
  { "TabLineFill",                   { fg = C.norm_subtle, bg = C.bg } },
  { "TabLineSel",                    { fg = C.norm, bg = C.visual, bold = true } },
  { "Title",                         { fg = C.dark_blue } },
  { "Visual",                        { bg = C.visual } },
  -- { "VisualNOS",                  { link = "visual" } },
  { "WarningMsg",                    { fg = C.yellow } },
  { "WildMenu",                      { fg = C.bg_dark, bg = C.cyan } },
  -- { "WinBar",                     { bold = true } },
  -- { "WinBarNC",                   { link = "WinBar" } },

  -- Added to original Embark
  { "Terminal",                      { fg = C.norm, bg = C.bg_dark } },

  -- Diagnostics
  { "DiagnosticHint",                { fg = C.purple, bg = C.bg_dark } },
  { "DiagnosticInfo",                { fg = C.blue, bg = C.bg_dark } },
  { "DiagnosticWarn",                { fg = C.yellow, bg = C.bg_dark } },
  { "DiagnosticError",               { fg = C.red, bg = C.bg_dark } },
  -- For signs and floating menus drop the dark background
  { "DiagnosticSignHint",            { fg = C.purple } },
  { "DiagnosticSignInfo",            { fg = C.blue } },
  { "DiagnosticSignWarn",            { fg = C.yellow } },
  { "DiagnosticSignError",           { fg = C.red } },
  { "DiagnosticFloatingHint",        { link = "DiagnosticSignHint" } },
  { "DiagnosticFloatingInfo",        { link = "DiagnosticSignInfo" } },
  { "DiagnosticFloatingWarn",        { link = "DiagnosticSignWarn" } },
  { "DiagnosticFloatingError",       { link = "DiagnosticSignError" } },
  { "DiagnosticVirtualTextHint",     { link = "DiagnosticHint" } },
  { "DiagnosticVirtualTextInfo",     { link = "DiagnosticInfo" } },
  { "DiagnosticVirtualTextWarn",     { link = "DiagnosticWarn" } },
  { "DiagnosticVirtualTextError",    { link = "DiagnosticError" } },
  { "DiagnosticUnderlineHint",       { undercurl = true } }, --, fg = C.purple } },
  { "DiagnosticUnderlineInfo",       { undercurl = true } }, --, fg = C.blue } },
  { "DiagnosticUnderlineWarn",       { undercurl = true } }, --, fg = C.yellow } },
  { "DiagnosticUnderlineError",      { undercurl = true } }, --, fg = C.red } },

  -- Treesitter
  { "@keyword.operator",             { fg = C.cyan } },
  { "@constant.builtin",             { link = "Special" } },
  { "@punctuation.bracket",          { fg = C.cyan } },
  { "@variable.builtin",             { fg = C.cyan } },
  { "@string.special",               { fg = C.dark_blue } },
  { "@string.escape",                { fg = C.cyan } },
  { "@string.special.symbol",        { fg = C.yellow } },
  { "@module",                       { fg = C.purple } },
  { "@function",                     { fg = C.red } },
  { "@function.call",                { fg = C.blue } },
  { "@constructor",                  { fg = C.purple } },
  { "@markup",                       { link = "Title" } },
  { "@markup.raw",                   { fg = C.cyan } },
  { "@markup.link.uri",              { fg = C.blue } },
  { "@markup.link",                  { fg = C.purple } },
  { "@markup.strong",                { bold = true } },
  { "@markup.emphasis",              { italic = true } },
  { "@markup.list.unchecked",        { fg = C.dark_cyan, bold = true } },
  { "@markup.list.checked",          { fg = C.norm_subtle } },
  { "@tag",                          { link = "Keyword" } },
  { "@tag.delimiter",                { link = "Special" } },
  { "@tag.attribute",                { link = "Constant" } },
  -- Deprecated nvim-treesitter highlights
  { "@symbol",                       { fg = C.yellow } },
  { "@text.literal",                 { fg = C.cyan } },
  { "@text.uri",                     { fg = C.blue } },
  { "@text.reference",               { fg = C.purple } },
  { "@text.strong",                  { bold = true } },
  { "@text.emphasis",                { italic = true } },
  { "@text.todo.unchecked",          { fg = C.dark_cyan, bold = true } },
  { "@text.todo.checked",            { fg = C.norm_subtle } },

  -- HTML
  { "htmlTag",                       { link = "Special" } },
  { "htmlEndTag",                    { link = "htmlTag" } },
  { "htmlTagName",                   { link = "Keyword" } },
  { "htmlTagN",                      { link = "Keyword" } },
  { "htmlH1",                        { fg = C.head_a, bold = true } },
  { "htmlH2",                        { fg = C.head_a, bold = true } },
  { "htmlH3",                        { fg = C.head_b, italic = true } },
  { "htmlH4",                        { fg = C.head_b, italic = true } },
  { "htmlH5",                        { fg = C.head_c } },
  { "htmlH6",                        { fg = C.head_c } },
  { "htmlLink",                      { fg = C.blue, underline = true } },
  { "htmlItalic",                    { italic = true } },
  { "htmlBold",                      { bold = true } },
  { "htmlBoldItalic",                { bold = true, italic = true } },

  -- JavaScript
  -- http//github.com/pangloss/vim-javascript
  { "jsAsyncKeyword",                { link = "PreProc" } },
  { "jsForAwait",                    { link = "PreProc" } },
  { "jsClassKeyword",                { fg = C.purple } },
  { "jsClassDefinition",             { link = "Type" } },
  { "jsConditional",                 { link = "PreProc" } },
  { "jsExtendsKeyword",              { link = "PreProc" } },
  { "jsReturn",                      { link = "PreProc" } },
  { "jsRepeat",                      { link = "PreProc" } },
  { "jsxOpenPunct",                  { fg = C.norm_subtle } },
  { "jsxClosePunct",                 { link = "jsxOpenPunct" } },

  -- Elixir
  { "elixirVariable",                { fg = C.purple } },
  { "elixirAtom",                    { fg = C.yellow } },

  -- Markdown
  -- tpope/vim-markdown
  { "markdownBlockquote",            { fg = C.norm_subtle } },
  { "markdownBold",                  { fg = C.norm, bold = true } },
  { "markdownBoldItalic",            { fg = C.norm, bold = true, italic = true } },
  { "markdownEscape",                { fg = C.norm } },
  { "markdownH1",                    { fg = C.head_a, bold = true } },
  { "markdownH2",                    { fg = C.head_a, bold = true } },
  { "markdownH3",                    { fg = C.head_a, bold = true, italic = true } },
  { "markdownH4",                    { fg = C.head_a, bold = true, italic = true } },
  { "markdownH5",                    { fg = C.dark_cyan } },
  { "markdownH6",                    { fg = C.dark_cyan } },
  { "markdownHeadingDelimiter",      { fg = C.norm } },
  { "markdownHeadingRule",           { fg = C.norm } },
  { "markdownId",                    { fg = C.norm_subtle } },
  { "markdownIdDeclaration",         { fg = C.norm_subtle } },
  { "markdownItalic",                { fg = C.norm, italic = true } },
  { "markdownLinkDelimiter",         { fg = C.norm_subtle } },
  { "markdownLinkText",              { fg = C.norm } },
  { "markdownLinkTextDelimiter",     { fg = C.norm_subtle } },
  { "markdownListMarker",            { fg = C.red } },
  { "markdownOrderedListMarker",     { fg = C.red } },
  { "markdownRule",                  { fg = C.norm } },
  { "markdownUrl",                   { fg = C.dark_blue, underline = true } },
  { "markdownUrlDelimiter",          { fg = C.norm_subtle } },
  { "markdownUrlTitle",              { fg = C.norm } },
  { "markdownUrlTitleDelimiter",     { fg = C.norm_subtle } },
  { "markdownCode",                  { fg = C.green } },
  { "markdownCodeDelimiter",         { fg = C.norm_subtle } },

  -- XML
  { "xmlTag",                        { link = "htmlTag" } },
  { "xmlEndTag",                     { link = "xmlTag" } },
  { "xmlTagName",                    { link = "htmlTagName" } },

  -- tpope/vim-fugitive
  -- diffOnly       xxx links to Constant
  -- diffIdentical  xxx links to Constant
  -- diffDiffer     xxx links to Constant
  -- diffBDiffer    xxx links to Constant
  -- diffIsA        xxx links to Constant
  -- diffCommon     xxx links to Constant
  -- diffChanged    xxx links to PreProc
  -- diffComment    xxx links to Comment
  { "diffAdded",                     { fg = C.green } },
  { "diffRemoved",                   { fg = C.red } },
  { "diffFile",                      { fg = C.white, bold = true } },
  { "diffFileId",                    { fg = C.blue, bold = true, reverse = true } },
  { "diffNewFile",                   { fg = C.white, bold = true } },
  { "diffOldFile",                   { fg = C.white, bold = true } },
  { "diffIndexLine",                 { fg = C.white, bold = true } },
  { "diffLine",                      { fg = C.purple } },
  { "diffNoEOL",                     { fg = C.purple } },
  { "diffSubname",                   { fg = C.white } },

  -- Git Highlighting
  { "gitcommitComment",              { fg = C.norm_subtle } },
  { "gitcommitUnmerged",             { fg = C.green } },
  { "gitcommitOnBranch",             {} },
  { "gitcommitBranch",               { fg = C.purple } },
  { "gitcommitDiscardedType",        { fg = C.red } },
  { "gitcommitSelectedType",         { fg = C.green } },
  { "gitcommitHeader",               {} },
  { "gitcommitUntrackedFile",        { fg = C.cyan } },
  { "gitcommitDiscardedFile",        { fg = C.red } },
  { "gitcommitSelectedFile",         { fg = C.green } },
  { "gitcommitUnmergedFile",         { fg = C.yellow } },
  { "gitcommitFile",                 {} },
  { "gitcommitSummary",              { fg = C.white } },
  { "gitcommitOverflow",             { fg = C.red } },
  { "gitcommitNoBranch",             { link = "gitcommitBranch" } },
  { "gitcommitUntracked",            { link = "gitcommitComment" } },
  { "gitcommitDiscarded",            { link = "gitcommitComment" } },
  { "gitcommitSelected",             { link = "gitcommitComment" } },
  { "gitcommitDiscardedArrow",       { link = "gitcommitDiscardedFile" } },
  { "gitcommitSelectedArrow",        { link = "gitcommitSelectedFile" } },
  { "gitcommitUnmergedArrow",        { link = "gitcommitUnmergedFile" } },

  -- gitsigns.nvim
  --   sign column
  { "GitSignsAdd",                   { fg = C.green } },
  { "GitSignsChange",                { fg = C.yellow } },
  { "GitSignsChangeDelete",          { fg = C.dark_yellow } },
  { "GitSignsDelete",                { fg = C.red } },
  { "GitSignsUntracked",             { fg = C.blue } },
  --   line highlights
  { "GitSignsAddLn",                 { fg = C.dark_green } },
  { "GitSignsChangeLn",              { fg = C.yellow } },
  { "GitSignsChangeNr",              { fg = C.dark_yellow } },
  --   word diff in preview
  { "GitSignsAddInline",             { fg = C.bg_dark, bg = C.green } },
  { "GitSignsChangeInline",          { fg = C.bg_dark, bg = C.yellow } },
  { "GitSignsDeleteInline",          { fg = C.bg_dark, bg = C.red } },
  --   word diff in buffer
  { "GitSignsAddLnInline",           { fg = C.bg_dark, bg = C.green } },
  { "GitSignsChangeLnInline",        { fg = C.bg_dark, bg = C.yellow } },
  { "GitSignsDeleteLnInline",        { fg = C.bg_dark, bg = C.red } },
  -- used by hunk preview (float/inline)
  { "GitSignsAddPreview",            { bg = C.space2, fg = C.green } },
  -- used by hunk preview (float)
  { "GitSignsDeletePreview",         { bg = C.space2, fg = C.red } },
  -- used by hunk preview (inline)
  { "GitSignsDeleteVirtLn",          { bg = C.space2, fg = C.red } },

  -- nvim-cmp
  { "CmpItemMenu",                   { link = "Comment" } },
  -- { "CmpItemKindDefault",            { fg = C.purple } },
  -- { "CmpItemAbbrMatch",              { link = "Pmenu" } },
  { "CmpItemAbbrMatch",              { fg = C.purple } },
  { "CmpItemAbbrMatchFuzzy",         { fg = C.yellow } },
  { "CmpItemKindDefault",            { link = "Pmenu" } },
  { "CmpItemKindFunction",           { link = "Function" } },
  { "CmpItemKindMethod",             { link = "CmpItemKindFunction" } },
  { "CmpItemKindModule",             { link = "PreProc" } },
  { "CmpItemKindStruct",             { link = "CmpItemKindModule" } },
  { "CmpItemKindText",               { link = "Comment" } },
  { "CmpItemKindSnippet",            { link = "Constant" } },
  { "CmpItemKindReference",          { link = "CmpItemKindDefault" } },
  { "CmpItemKindInterface",          { link = "CmpItemKindDefault" } },
  -- { "CmpItemAbbr",                   { fg = C.blue } },
  -- { "CmpItemAbbrDeprecated",         { fg = C.norm_subtle } },
  -- { "CmpItemAbbrMatch",              { link = "Pmenu" } },
  -- { "CmpItemKindDefault",            { link = "Identifier" } },
  -- { "CmpItemKindText",               { fg = C.white } },
  -- { "CmpItemKindMethod",             { fg = C.red } },
  -- { "CmpItemKindFunction",           { fg = C.red } },
  -- { "CmpItemKindConstructor",        { fg = C.dark_blue } },
  -- { "CmpItemKindField",              { fg = C.purple } },
  -- { "CmpItemKindVariable",           { fg = C.green } },
  -- { "CmpItemKindClass",              { fg = C.blue } },
  -- { "CmpItemKindInterface",          { fg = C.blue } },
  -- { "CmpItemKindModule",             { fg = C.blue } },
  -- { "CmpItemKindProperty",           { fg = C.norm } },
  -- { "CmpItemKindUnit",               { fg = C.norm } },
  -- { "CmpItemKindValue",              { fg = C.yellow } },
  -- { "CmpItemKindEnum",               { fg = C.dark_yellow } },
  -- { "CmpItemKindKeyword",            { fg = C.yellow } },
  -- { "CmpItemKindSnippet",            { fg = C.dark_yellow } },
  -- { "CmpItemKindColor",              { fg = C.white } },
  -- { "CmpItemKindFile",               { fg = C.norm } },
  -- { "CmpItemKindReference",          { fg = C.purple } },
  -- { "CmpItemKindFolder",             { fg = C.norm } },
  -- { "CmpItemKindEnumMember",         { fg = C.yellow } },
  -- { "CmpItemKindConstant",           { fg = C.yellow } },
  -- { "CmpItemKindStruct",             { fg = C.blue } },
  -- { "CmpItemKindEvent",              { fg = C.green } },
  -- { "CmpItemKindOperator",           { fg = C.dark_cyan } },
  -- { "CmpItemKindTypeParameter",      { fg = C.dark_blue } },

  -- Nvim-tree
  { "NvimTreeFolderIcon",            { fg = C.purple } },
  { "NvimTreeFolderName",            { fg = C.blue } },
  { "NvimTreeRootFolder",            { fg = C.green } },

  -- Nvim-telescope
  -- Doesn't look good with `path_display.filename_first`
  -- { "TelescopeNormal",               { fg = C.astral0 } },
  { "TelescopeBorder",               { link = "LineNr" } },
  { "TelescopeSelection",            { fg = C.astral1, bg = C.visual } },
  { "TelescopeMatching",             { link = "String" } },
  { "TelescopePreviewTitle",         { fg = C.space0, bg = C.purple } },
  { "TelescopePromptTitle",          { fg = C.space0, bg = C.green } },
  { "TelescopePromptNormal",         { link = "Normal" } },
  { "TelescopeResultsTitle",         { fg = C.space0, bg = C.blue } },
  { "TelescopePromptPrefix",         { link = "Type" } },
  { "TelescopeResultsDiffAdd",       { fg = C.green } },
  { "TelescopeResultsDiffChange",    { fg = C.yellow } },
  { "TelescopeResultsDiffDelete",    { fg = C.red } },
  { "TelescopeResultsDiffUntracked", { link = "Title" } },

  -- fzf-lua
  -- { "FzfLuaTitle",                   { fg = C.white } },
  { "FzfLuaTitle",                   { fg = C.space0, bg = C.green } },
  { "FzfLuaPreviewTitle",            { fg = C.space0, bg = C.purple } },
  { "FzfLuaScrollFloatFull",         { bg = C.dark_blue } },
  { "FzfLuaScrollFloatEmpty",        { bg = C.space4 } },

  -- mini.indentscope
  -- `MiniIndentscopeSymbol` - symbol showing on every line of scope.
  -- `MiniIndentscopePrefix` - space before symbol. By default made so as to
  { "MiniIndentscopeSymbol",         { fg = C.white } },
}

local function h(group, style)
  if style.link then
    vim.api.nvim_set_hl(0, group, { default = false, link = style.link })
    return
  end

  local style2hl = {
    fg      = { "fg", "gui" },
    bg      = { "bg", "gui" },
    sp      = { "sp", "gui" },
    ctermfg = { "fg", "cterm" },
    ctermbg = { "bg", "cterm" },
  }

  local hl_opts = {}
  for k, v in pairs(style2hl) do
    hl_opts[k] = style[v[1]] and style[v[1]][v[2]] or "NONE"
  end

  -- ':help highlight-cterm
  hl_opts.default = false
  hl_opts.bold = style.bold
  hl_opts.underline = style.underline
  hl_opts.underlineline = style.underlineline -- double underline
  hl_opts.undercurl = style.undercurl         -- curly underline
  hl_opts.underdot = style.underdot           -- dotted underline
  hl_opts.underdash = style.underdash         -- dashed underline
  hl_opts.strikethrough = style.strikethrough
  hl_opts.reverse = style.reverse or style.inverse
  hl_opts.italic = style.italic
  hl_opts.standout = style.standout
  -- override attributes instead of combining them
  hl_opts.nocombine = style.nocombine

  vim.api.nvim_set_hl(0, group, hl_opts)
end

do
  vim.cmd("highlight clear")

  if vim.g.syntax_on ~= nil then
    vim.cmd("syntax reset")
  end

  vim.o.background           = "dark"
  vim.g.colors_name          = "lua-embark"

  -- 256-color terminal colors
  vim.g.terminal_ansi_colors = {
    C.bg_bright.gui,
    C.red.gui,
    C.green.gui,
    C.yellow.gui,
    C.blue.gui,
    C.purple.gui,
    C.cyan.gui,
    C.bg.gui,
    C.bg_bright.gui,
    C.dark_red.gui,
    C.dark_green.gui,
    C.dark_yellow.gui,
    C.dark_blue.gui,
    C.dark_purple.gui,
    C.dark_cyan.gui,
    C.norm_subtle.gui,
  }

  -- Neovim terminal colors
  vim.g.terminal_color_0     = C.bg_bright.gui
  vim.g.terminal_color_1     = C.red.gui
  vim.g.terminal_color_2     = C.green.gui
  vim.g.terminal_color_3     = C.yellow.gui
  vim.g.terminal_color_4     = C.blue.gui
  vim.g.terminal_color_5     = C.purple.gui
  vim.g.terminal_color_6     = C.cyan.gui
  vim.g.terminal_color_7     = C.bg.gui
  vim.g.terminal_color_8     = C.bg_bright.gui
  vim.g.terminal_color_9     = C.dark_red.gui
  vim.g.terminal_color_10    = C.dark_green.gui
  vim.g.terminal_color_11    = C.dark_yellow.gui
  vim.g.terminal_color_12    = C.dark_blue.gui
  vim.g.terminal_color_13    = C.dark_purple.gui
  vim.g.terminal_color_14    = C.dark_cyan.gui
  vim.g.terminal_color_15    = C.norm_subtle.gui
  -- vim.g.terminal_color_background = vim.g.terminal_color_0
  -- vim.g.terminal_color_foreground = vim.g.terminal_color_7

  for _, def in ipairs(HLS) do
    h(def[1], def[2])
  end
end
