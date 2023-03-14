local hl = {}

local NONE = "NONE"

local colors = {
  bg             = { gui = "#323F4E", cterm = 233, cterm16 = NONE },
  fg             = { gui = "#cbe3e7", cterm = 253, cterm16 = 7 },
  red            = { gui = "#F48FB1", cterm = 204, cterm16 = 1 },
  dark_red       = { gui = "#F02E6E", cterm = 203, cterm16 = 9 },
  green          = { gui = "#A1EFD3", cterm = 120, cterm16 = 2 },
  dark_green     = { gui = "#7fe9c3", cterm = 119, cterm16 = 10 },
  yellow         = { gui = "#ffe6b3", cterm = 228, cterm16 = 3 },
  dark_yellow    = { gui = "#F2B482", cterm = 215, cterm16 = 11 },
  blue           = { gui = "#91ddff", cterm = 159, cterm16 = 4 },
  dark_blue      = { gui = "#78a8ff", cterm = 135, cterm16 = 13 },
  purple         = { gui = "#d4bfff", cterm = 141, cterm16 = 5 },
  dark_purple    = { gui = "#7676ff", cterm = 75, cterm16 = 12 },
  cyan           = { gui = "#ABF8F7", cterm = 122, cterm16 = 6 },
  dark_cyan      = { gui = "#63f2f1", cterm = 121, cterm16 = 14 },
  white          = { gui = "#E4E4E4", cterm = 145, cterm16 = 7 },
  black          = { gui = "#100E23", cterm = 232, cterm16 = 0 },
  visual_black   = { gui = NONE, cterm = NONE, cterm16 = 0 },
  comment_grey   = { gui = "#8A889D", cterm = 252, cterm16 = 15 },
  gutter_fg_grey = { gui = "#656A7c", cterm = 238, cterm16 = 15 },
  cursor_grey    = { gui = "#100E23", cterm = 236, cterm16 = 8 },
  visual_grey    = { gui = "#56687E", cterm = 237, cterm16 = 15 },
  menu_grey      = { gui = "#56687E", cterm = 237, cterm16 = 8 },
  special_grey   = { gui = "#656A7c", cterm = 238, cterm16 = 15 },
  vertsplit      = { gui = "#181A1F", cterm = 59, cterm16 = 15 },
  statusline     = { gui = "#7E9CD8", cterm = 236, cterm16 = 8 },
  space1         = { gui = "#1e1c31", cterm = 233, cterm16 = NONE },
  space2         = { gui = "#2D2B40", cterm = 233, cterm16 = NONE },
  space3         = { gui = "#3E3869", cterm = 236, cterm16 = 8 },
  space4         = { gui = "#585273", cterm = 236, cterm16 = 8 },
  diff_del       = { gui = "#411E35", cterm = 203, cterm16 = 9 },
  diff_add       = { gui = "#133246", cterm = 119, cterm16 = 10 },
  diff_change    = { gui = "#22244C", cterm = 215, cterm16 = 11 },
}

if not vim.g.lua_embark_transparent then
  colors.bg = colors.space1
end

hl.common = {
  Normal = { fg = colors.fg, bg = colors.bg },
  -- NormalNC =          { fg = colors.fg, bg = colors.black },
  NormalFloat = { fg = colors.fg, bg = colors.bg },
  Conceal = { fg = colors.fg },
  Cursor = { fg = colors.special_grey, bg = colors.blue },
  CursorIM = {},
  CursorLine = { bg = colors.cursor_grey },
  CursorColumn = { bg = colors.cursor_grey },
  ColorColumn = { bg = colors.cursor_grey },
  Directory = { fg = colors.purple },
  DiffAdd = { fg = colors.bg, bg = colors.diff_add },
  DiffDelete = { fg = colors.bg, bg = colors.diff_del },
  DiffChange = { fg = colors.diff_change, underline = true },
  DiffText = { fg = colors.bg, bg = colors.diff_change, bold = true },
  EndOfBuffer = { fg = colors.gutter_fg_grey },
  ErrorMsg = { fg = colors.dark_red },
  VertSplit = { fg = colors.vertsplit },
  WinSeparator = { fg = colors.statusline },
  Folded = { fg = colors.comment_grey },
  FoldColumn = { fg = colors.dark_purple },
  SignColumn = { fg = colors.green },
  Search = { fg = colors.black, bg = colors.dark_yellow },
  IncSearch = { fg = colors.black, bg = colors.yellow },
  LineNr = { fg = colors.gutter_fg_grey },
  CursorLineNr = { fg = colors.blue, bg = colors.black, bold = true },
  MatchParen = { fg = colors.purple, bg = colors.black, bold = true, underline = true },
  ModeMsg = { fg = colors.comment_grey, bold = true },
  MoreMsg = { fg = colors.comment_grey, bold = true },
  NonText = { fg = colors.special_grey },
  Pmenu = { fg = colors.fg, bg = colors.space2 },
  PmenuSel = { fg = colors.purple, bg = colors.black },
  PmenuSbar = { bg = colors.special_grey },
  PmenuThumb = { bg = colors.fg },
  Question = { fg = colors.red },
  QuickFixLine = { fg = colors.black, bg = colors.yellow },
  SpecialKey = { fg = colors.blue },
  -- if vim.fn.has("gui_running") then
  SpellBad = { fg = colors.dark_red, underline = true },
  SpellCap = { fg = colors.green, underline = true },
  SpellLocal = { fg = colors.dark_green, underline = true },
  SpellRare = { fg = colors.red, underline = true },
  -- end
  -- StatusLine =        { fg = colors.fg,           bg = colors.cursor_grey },
  -- StatusLineNC =      { fg = colors.visual_grey,  bg = colors.cursor_grey },
  StatusLine = { fg = colors.black, bg = colors.statusline },
  StatusLineNC = { fg = colors.comment_grey, bg = colors.cursor_grey },
  TabLine = { fg = colors.comment_grey, bg = colors.black },
  TabLineFill = {},
  TabLineSel = { fg = colors.black, bg = colors.dark_blue, bold = true },
  Terminal = { fg = colors.fg, bg = colors.black },
  Title = { fg = colors.dark_blue },
  Visual = { fg = colors.visual_black, bg = colors.visual_grey },
  VisualNOS = { bg = colors.visual_grey },
  WarningMsg = { fg = colors.yellow },
  WildMenu = { fg = colors.black, bg = colors.blue },
  FloatBorder = { fg = colors.comment_grey },
  Underlined = { fg = colors.dark_cyan, underline = true },
  Ignore = {},
  Error = { fg = colors.dark_red, bg = colors.black, bold = true },
  Todo = { fg = colors.dark_yellow, bg = colors.bg, bold = true },
  Debug = { fg = colors.yellow },
  debugPC = { bg = hl.cspecial_grey },
  debugBreakpoint = { fg = colors.black, bg = colors.red },
}

hl.syntax = {
  Constant = { fg = colors.purple },
  String = { fg = colors.yellow },
  Character = { fg = colors.yellow },
  Number = { fg = colors.dark_yellow },
  Boolean = { fg = colors.dark_yellow },
  Float = { fg = colors.dark_yellow },
  Identifier = { fg = colors.fg },
  Function = { fg = colors.red },
  Label = { fg = colors.dark_blue },
  Conditional = { fg = colors.green },
  Exception = { fg = colors.green },
  Operator = { fg = colors.dark_cyan },
  Repeat = { fg = colors.dark_cyan },
  PreProc = { fg = colors.green },
  Include = { fg = colors.green },
  Define = { fg = colors.green },
  Macro = { fg = colors.green },
  PreCondit = { fg = colors.green },
  Keyword = { fg = colors.green },
  Statement = { fg = colors.green },
  Type = { fg = colors.purple },
  StorageClass = { fg = colors.blue },
  Structure = { fg = colors.blue },
  Typedef = { fg = colors.blue },
  Special = { fg = colors.cyan },
  SpecialChar = { fg = colors.cyan },
  Tag = { fg = colors.cyan },
  Delimiter = { fg = colors.cyan },
  Comment = { fg = colors.comment_grey, italic = true },
  SpecialComment = { fg = colors.comment_grey },
}

-- TS highlights
hl.treesitter = {
  ["@punctuation.bracket"] = { fg = colors.fg },
  ["@string.special"]      = { fg = colors.dark_blue },
  ["@string.escape"]       = { fg = colors.cyan },
  ["@function"]            = { fg = colors.red },
  ["@function.call"]       = { fg = colors.blue },
  ["@constructor"]         = { fg = colors.purple },
  ["@keyword.operator"]    = { fg = colors.cyan },
  ["@constant.builtin"]    = { fg = colors.cyan },
  ["@variable.builtin"]    = { fg = colors.cyan },
  ["@symbol"]              = { fg = colors.yellow },
  ["@text.literal"]        = { fg = colors.cyan },
  ["@text.uri"]            = { fg = colors.blue },
  ["@text.reference"]      = { fg = colors.purple },
  ["@text.strong"]         = { bold = true },
  ["@text.emphasis"]       = { italic = true },
  ["@text.todo.unchecked"] = { fg = colors.dark_cyan, bold = true },
  ["@text.todo.checked"]   = { fg = colors.comment_grey },
  ["@tag"]                 = { fg = colors.green },
  ["@tag.delimiter"]       = { fg = colors.cyan },
  ["@tag.attribute"]       = { fg = colors.purple },
}

-- vim.diagnostic
hl.diagnostic = {
  DiagnosticError            = { fg = colors.red },
  DiagnosticWarn             = { fg = colors.yellow },
  DiagnosticInfo             = { fg = colors.blue },
  DiagnosticHint             = { fg = colors.purple },
  DiagnosticSignError        = { fg = colors.red },
  DiagnosticSignWarn         = { fg = colors.yellow },
  DiagnosticSignInfo         = { fg = colors.blue },
  DiagnosticSignHint         = { fg = colors.purple },
  DiagnosticFloatingError    = { link = "DiagnosticSignError" },
  DiagnosticFloatingWarn     = { link = "DiagnosticSignWarning" },
  DiagnosticFloatingInfo     = { link = "DiagnosticSignInformation" },
  DiagnosticFloatingHint     = { link = "DiagnosticSignHint" },
  DiagnosticUnderlineError   = { undercurl = true, fg = colors.red },
  DiagnosticUnderlineWarn    = { undercurl = true, fg = colors.yellow },
  DiagnosticUnderlineInfo    = { undercurl = true, fg = colors.blue },
  DiagnosticUnderlineHint    = { undercurl = true, fg = colors.purple },
  DiagnosticVirtualTextError = { fg = colors.red },
  DiagnosticVirtualTextWarn  = { fg = colors.yellow },
  DiagnosticVirtualTextInfo  = { fg = colors.blue },
  DiagnosticVirtualTextHint  = { fg = colors.purple },
}

-- XML
hl.xml = {
  xmlAttrib  = { fg = colors.green },
  xmlEndTag  = { fg = colors.red },
  xmlTag     = { fg = colors.blue },
  xmlTagName = { fg = colors.red },
}

-- CSS
hl.css = {
  cssAttrComma = { fg = colors.purple },
  cssAttributeSelector = { fg = colors.green },
  cssBraces = { fg = colors.white },
  cssClassName = { fg = colors.dark_yellow },
  cssClassNameDot = { fg = colors.dark_yellow },
  cssDefinition = { fg = colors.purple },
  cssFontAttr = { fg = colors.dark_yellow },
  cssFontDescriptor = { fg = colors.purple },
  cssFunctionName = { fg = colors.blue },
  cssIdentifier = { fg = colors.blue },
  cssImportant = { fg = colors.purple },
  cssInclude = { fg = colors.white },
  cssIncludeKeyword = { fg = colors.purple },
  cssMediaType = { fg = colors.dark_yellow },
  cssProp = { fg = colors.white },
  cssPseudoClassId = { fg = colors.dark_yellow },
  cssSelectorOp = { fg = colors.purple },
  cssSelectorOp2 = { fg = colors.purple },
  cssTagName = { fg = colors.red },
}

-- Fish Shell
hl.fish = {
  fishKeyword = { fg = colors.purple },
  fishConditional = { fg = colors.purple },
}

-- Go
hl.go = {
  goDeclaration = { fg = colors.purple },
  goBuiltins = { fg = colors.cyan },
  goFunctionCall = { fg = colors.blue },
  goVarDefs = { fg = colors.red },
  goVarAssign = { fg = colors.red },
  goVar = { fg = colors.purple },
  goConst = { fg = colors.purple },
  goType = { fg = colors.yellow },
  goTypeName = { fg = colors.yellow },
  goDeclType = { fg = colors.cyan },
  goTypeDecl = { fg = colors.purple },
}

-- HTML (keep consistent with Markdown, below)
hl.html = {
  htmlArg = { fg = colors.dark_yellow },
  htmlBold = { fg = colors.dark_yellow, bold = true },
  htmlEndTag = { fg = colors.white },
  htmlH1 = { fg = colors.dark_blue, bold = true },
  htmlH2 = { fg = colors.dark_blue, bold = true },
  htmlH3 = { fg = colors.blue },
  htmlH4 = { fg = colors.blue },
  htmlH5 = { fg = colors.dark_cyan },
  htmlH6 = { fg = colors.dark_cyan },
  htmlItalic = { fg = colors.purple, italic = true },
  htmlLink = { fg = colors.dark_cyan, underline = true },
  htmlSpecialChar = { fg = colors.dark_yellow },
  htmlSpecialTagName = { fg = colors.red },
  htmlTag = { fg = colors.white },
  htmlTagN = { fg = colors.red },
  htmlTagName = { fg = colors.red },
  htmlTitle = { fg = colors.white },
}

-- JavaScript
hl.javascript = {
  javaScriptBraces = { fg = colors.white },
  javaScriptFunction = { fg = colors.purple },
  javaScriptIdentifier = { fg = colors.purple },
  javaScriptNull = { fg = colors.dark_yellow },
  javaScriptNumber = { fg = colors.dark_yellow },
  javaScriptRequire = { fg = colors.cyan },
  javaScriptReserved = { fg = colors.purple },
  -- http//github.com/pangloss/vim-javascript
  jsArrowFunction = { fg = colors.purple },
  jsClassKeyword = { fg = colors.purple },
  jsClassMethodType = { fg = colors.purple },
  jsDocParam = { fg = colors.blue },
  jsDocTags = { fg = colors.purple },
  jsExport = { fg = colors.purple },
  jsExportDefault = { fg = colors.purple },
  jsExtendsKeyword = { fg = colors.purple },
  jsFrom = { fg = colors.purple },
  jsFuncCall = { fg = colors.blue },
  jsFunction = { fg = colors.purple },
  jsGenerator = { fg = colors.yellow },
  jsGlobalObjects = { fg = colors.yellow },
  jsImport = { fg = colors.purple },
  jsModuleAs = { fg = colors.purple },
  jsModuleWords = { fg = colors.purple },
  jsModules = { fg = colors.purple },
  jsNull = { fg = colors.dark_yellow },
  jsOperator = { fg = colors.purple },
  jsStorageClass = { fg = colors.purple },
  jsSuper = { fg = colors.red },
  jsTemplateBraces = { fg = colors.dark_red },
  jsTemplateVar = { fg = colors.green },
  jsThis = { fg = colors.red },
  jsUndefined = { fg = colors.dark_yellow },
  -- http//github.com/othree/yajs.vim
  javascriptArrowFunc = { fg = colors.purple },
  javascriptClassExtends = { fg = colors.purple },
  javascriptClassKeyword = { fg = colors.purple },
  javascriptDocNotation = { fg = colors.purple },
  javascriptDocParamName = { fg = colors.blue },
  javascriptDocTags = { fg = colors.purple },
  javascriptEndColons = { fg = colors.white },
  javascriptExport = { fg = colors.purple },
  javascriptFuncArg = { fg = colors.white },
  javascriptFuncKeyword = { fg = colors.purple },
  javascriptIdentifier = { fg = colors.red },
  javascriptImport = { fg = colors.purple },
  javascriptMethodName = { fg = colors.white },
  javascriptObjectLabel = { fg = colors.white },
  javascriptOpSymbol = { fg = colors.cyan },
  javascriptOpSymbols = { fg = colors.cyan },
  javascriptPropertyName = { fg = colors.green },
  javascriptTemplateSB = { fg = colors.dark_red },
  javascriptVariable = { fg = colors.purple },
}

-- JSON
hl.json = {
  jsonCommentError = { fg = colors.white },
  jsonKeyword = { fg = colors.red },
  jsonBoolean = { fg = colors.dark_yellow },
  jsonNumber = { fg = colors.dark_yellow },
  jsonQuote = { fg = colors.white },
  jsonMissingCommaError = { fg = colors.red, reverse = true },
  jsonNoQuotesError = { fg = colors.red, reverse = true },
  jsonNumError = { fg = colors.red, reverse = true },
  jsonString = { fg = colors.green },
  jsonStringSQError = { fg = colors.red, reverse = true },
  jsonSemicolonError = { fg = colors.red, reverse = true },
}

-- LESS
hl.less = {
  lessVariable = { fg = colors.purple },
  lessAmpersandChar = { fg = colors.white },
  lessClass = { fg = colors.dark_yellow },
}

-- Markdown (keep consistent with HTML, above)
hl.test = {
  markdownBlockquote = { fg = colors.comment_grey },
  markdownBold = { fg = colors.dark_yellow, bold = true },
  markdownCode = { fg = colors.green },
  markdownCodeBlock = { fg = colors.green },
  markdownCodeDelimiter = { fg = colors.green },
  markdownH1 = { fg = colors.dark_blue, bold = true },
  markdownH2 = { fg = colors.dark_blue, bold = true },
  markdownH3 = { fg = colors.dark_blue },
  markdownH4 = { fg = colors.dark_blue },
  markdownH5 = { fg = colors.dark_cyan },
  markdownH6 = { fg = colors.dark_cyan },
  markdownHeadingDelimiter = { fg = colors.red },
  markdownHeadingRule = { fg = colors.comment_grey },
  markdownId = { fg = colors.purple },
  markdownIdDeclaration = { fg = colors.blue },
  markdownIdDelimiter = { fg = colors.purple },
  markdownItalic = { fg = colors.purple, italic = true },
  markdownLinkDelimiter = { fg = colors.purple },
  markdownLinkText = { fg = colors.dark_blue },
  markdownListMarker = { fg = colors.red },
  markdownOrderedListMarker = { fg = colors.red },
  markdownRule = { fg = colors.comment_grey },
  markdownUrl = { fg = colors.dark_cyan, underline = true },
}

-- Perl
hl.perl = {
  perlFiledescRead = { fg = colors.green },
  perlFunction = { fg = colors.purple },
  perlMatchStartEnd = { fg = colors.blue },
  perlMethod = { fg = colors.purple },
  perlPOD = { fg = colors.comment_grey },
  perlSharpBang = { fg = colors.comment_grey },
  perlSpecialString = { fg = colors.dark_yellow },
  perlStatementFiledesc = { fg = colors.red },
  perlStatementFlow = { fg = colors.red },
  perlStatementInclude = { fg = colors.purple },
  perlStatementScalar = { fg = colors.purple },
  perlStatementStorage = { fg = colors.purple },
  perlSubName = { fg = colors.yellow },
  perlVarPlain = { fg = colors.blue },
}

-- PHP
hl.php = {
  phpVarSelector = { fg = colors.red },
  phpOperator = { fg = colors.white },
  phpParent = { fg = colors.white },
  phpMemberSelector = { fg = colors.white },
  phpType = { fg = colors.purple },
  phpKeyword = { fg = colors.purple },
  phpClass = { fg = colors.yellow },
  phpUseClass = { fg = colors.white },
  phpUseAlias = { fg = colors.white },
  phpInclude = { fg = colors.purple },
  phpClassExtends = { fg = colors.green },
  phpDocTags = { fg = colors.white },
  phpFunction = { fg = colors.blue },
  phpFunctions = { fg = colors.cyan },
  phpMethodsVar = { fg = colors.dark_yellow },
  phpMagicConstants = { fg = colors.dark_yellow },
  phpSuperglobals = { fg = colors.red },
  phpConstants = { fg = colors.dark_yellow },
}

-- Ruby
hl.ruby = {
  rubyBlockParameter = { fg = colors.red },
  rubyBlockParameterList = { fg = colors.red },
  rubyClass = { fg = colors.purple },
  rubyConstant = { fg = colors.yellow },
  rubyControl = { fg = colors.purple },
  rubyEscape = { fg = colors.red },
  rubyFunction = { fg = colors.blue },
  rubyGlobalVariable = { fg = colors.red },
  rubyInclude = { fg = colors.blue },
  rubyIncluderubyGlobalVariable = { fg = colors.red },
  rubyInstanceVariable = { fg = colors.red },
  rubyInterpolation = { fg = colors.cyan },
  rubyInterpolationDelimiter = { fg = colors.red },
  rubyRegexp = { fg = colors.cyan },
  rubyRegexpDelimiter = { fg = colors.cyan },
  rubyStringDelimiter = { fg = colors.green },
  rubySymbol = { fg = colors.cyan },
}

-- Sass
-- http//github.com/tpope/vim-haml
hl.saas = {
  sassAmpersand = { fg = colors.red },
  sassClass = { fg = colors.dark_yellow },
  sassControl = { fg = colors.purple },
  sassExtend = { fg = colors.purple },
  sassFor = { fg = colors.white },
  sassFunction = { fg = colors.cyan },
  sassId = { fg = colors.blue },
  sassInclude = { fg = colors.purple },
  sassMedia = { fg = colors.purple },
  sassMediaOperators = { fg = colors.white },
  sassMixin = { fg = colors.purple },
  sassMixinName = { fg = colors.blue },
  sassMixing = { fg = colors.purple },
  sassVariable = { fg = colors.purple },
  -- http//github.com/cakebaker/scss-syntax.vim
  scssExtend = { fg = colors.purple },
  scssImport = { fg = colors.purple },
  scssInclude = { fg = colors.purple },
  scssMixin = { fg = colors.purple },
  scssSelectorName = { fg = colors.dark_yellow },
  scssVariable = { fg = colors.purple },
}

-- TeX
hl.tex = {
  texStatement = { fg = colors.purple },
  texSubscripts = { fg = colors.dark_yellow },
  texSuperscripts = { fg = colors.dark_yellow },
  texTodo = { fg = colors.dark_red },
  texBeginEnd = { fg = colors.purple },
  texBeginEndName = { fg = colors.blue },
  texMathMatcher = { fg = colors.blue },
  texMathDelim = { fg = colors.blue },
  texDelimiter = { fg = colors.dark_yellow },
  texSpecialChar = { fg = colors.dark_yellow },
  texCite = { fg = colors.blue },
  texRefZone = { fg = colors.blue },
}

-- TypeScript
hl.typescript = {
  typescriptReserved = { fg = colors.purple },
  typescriptEndColons = { fg = colors.white },
  typescriptBraces = { fg = colors.white },
}


hl.gitsigns = {
  GitSignsAdd = { fg = colors.green },
  GitSignsAddLn = { fg = colors.dark_green },
  GitSignsChange = { fg = colors.yellow },
  GitSignsChangeDelete = { fg = colors.dark_yellow },
  GitSignsChangeLn = { fg = colors.yellow },
  GitSignsChangeNr = { fg = colors.dark_yellow },
  GitSignsDelete = { fg = colors.red },
  GitSignsDeleteLn = { fg = colors.dark_red },
  GitSignsAddInline = { fg = colors.black, bg = colors.green },
  GitSignsChangeInline = { fg = colors.black, bg = colors.yellow },
  GitSignsDeleteInline = { fg = colors.black, bg = colors.red },
}

-- mhinz/vim-signify
hl.test = {
  SignifySignAdd = { fg = colors.green },
  SignifySignChange = { fg = colors.yellow },
  SignifySignDelete = { fg = colors.red },
}

-- airblade/vim-gitgutter
hl.gitgutter = {
  GitGutterAdd = { link = "SignifySignAdd" },
  GitGutterChange = { link = "SignifySignChange" },
  GitGutterDelete = { link = "SignifySignDelete" },
}

-- dense-analysis/ale
hl.ale = {
  ALEError = { fg = colors.red, underline = true },
  ALEWarning = { fg = colors.yellow, underline = true },
  ALEInfo = { underline = true },
}

-- easymotion/vim-easymotion
hl.easymotion = {
  EasyMotionTarget = { fg = colors.red, bold = true },
  EasyMotionTarget2First = { fg = colors.yellow, bold = true },
  EasyMotionTarget2Second = { fg = colors.dark_yellow, bold = true },
  EasyMotionShade = { fg = colors.comment_grey },
}

-- neomake/neomake
hl.neomake = {
  NeomakeWarningSign = { fg = colors.yellow },
  NeomakeErrorSign = { fg = colors.red },
  NeomakeInfoSign = { fg = colors.blue },
}

-- plasticboy/vim-markdown (keep consistent with Markdown, above)
hl.vim_markdown = {
  mkdDelimiter = { fg = colors.purple },
  mkdHeading = { fg = colors.red },
  mkdLink = { fg = colors.blue },
  mkdURL = { fg = colors.cyan, underline = true },
}

-- tpope/vim-fugitive
-- diffOnly       xxx links to Constant
-- diffIdentical  xxx links to Constant
-- diffDiffer     xxx links to Constant
-- diffBDiffer    xxx links to Constant
-- diffIsA        xxx links to Constant
-- diffCommon     xxx links to Constant
-- diffChanged    xxx links to PreProc
-- diffComment    xxx links to Comment
hl.fugitive = {
  diffAdded = { fg = colors.green },
  diffRemoved = { fg = colors.red },
  diffFile = { fg = colors.white, bold = true },
  diffFileId = { fg = colors.blue, bold = true, reverse = true },
  diffNewFile = { fg = colors.white, bold = true },
  diffOldFile = { fg = colors.white, bold = true },
  diffIndexLine = { fg = colors.white, bold = true },
  diffLine = { fg = colors.purple },
  diffNoEOL = { fg = colors.purple },
  diffSubname = { fg = colors.white },
}

-- Git Highlighting
hl.git = {
  gitcommitComment = { fg = colors.comment_grey },
  gitcommitUnmerged = { fg = colors.green },
  gitcommitOnBranch = {},
  gitcommitBranch = { fg = colors.purple },
  gitcommitDiscardedType = { fg = colors.red },
  gitcommitSelectedType = { fg = colors.green },
  gitcommitHeader = {},
  gitcommitUntrackedFile = { fg = colors.cyan },
  gitcommitDiscardedFile = { fg = colors.red },
  gitcommitSelectedFile = { fg = colors.green },
  gitcommitUnmergedFile = { fg = colors.yellow },
  gitcommitFile = {},
  gitcommitSummary = { fg = colors.white },
  gitcommitOverflow = { fg = colors.red },
  gitcommitNoBranch = { link = "gitcommitBranch" },
  gitcommitUntracked = { link = "gitcommitComment" },
  gitcommitDiscarded = { link = "gitcommitComment" },
  gitcommitSelected = { link = "gitcommitComment" },
  gitcommitDiscardedArrow = { link = "gitcommitDiscardedFile" },
  gitcommitSelectedArrow = { link = "gitcommitSelectedFile" },
  gitcommitUnmergedArrow = { link = "gitcommitUnmergedFile" },
}

-- Nvim-tree support
hl.nvim_tree = {
  NvimTreeFolderIcon = { fg = colors.purple },
  NvimTreeFolderName = { fg = colors.blue },
  NvimTreeRootFolder = { fg = colors.green },
}


-- Nvim-telescope
hl.telescope = {
  TelescopeSelection            = { fg = colors.fg, bg = colors.space3 },
  TelescopeBorder               = { fg = colors.comment_grey },
  TelescopeMatching             = { fg = colors.yellow },
  TelescopeNormal               = { fg = colors.comment_grey },
  TelescopeResultsDiffAdd       = { link = "GitGutterAdd" },
  TelescopeResultsDiffChange    = { link = "GitGutterChange" },
  TelescopeResultsDiffDelete    = { link = "GitGutterDelete" },
  TelescopeResultsDiffUntracked = { link = "Title" },
}

-- fzf-lua
hl.fzf_lua = {
  FzfLuaTitle           = { fg = colors.white },
  FzfLuaScrollFloatFull = { bg = colors.dark_blue },
}

-- nvim-cmp
hl.nvim_cmp = {
  CmpItemMenu = { link = "Comment" },
  CmpItemAbbr = { fg = colors.blue },
  CmpItemAbbrDeprecated = { fg = colors.comment_grey },
  CmpItemAbbrMatch = { link = "Pmenu" },
  CmpItemAbbrMatchFuzzy = { fg = colors.purple },
  CmpItemKindDefault = { link = "Identifier" },
  CmpItemKindText = { fg = colors.white },
  CmpItemKindMethod = { fg = colors.red },
  CmpItemKindFunction = { fg = colors.red },
  CmpItemKindConstructor = { fg = colors.dark_blue },
  CmpItemKindField = { fg = colors.purple },
  CmpItemKindVariable = { fg = colors.green },
  CmpItemKindClass = { fg = colors.blue },
  CmpItemKindInterface = { fg = colors.blue },
  CmpItemKindModule = { fg = colors.blue },
  CmpItemKindProperty = { fg = colors.fg },
  CmpItemKindUnit = { fg = colors.fg },
  CmpItemKindValue = { fg = colors.yellow },
  CmpItemKindEnum = { fg = colors.dark_yellow },
  CmpItemKindKeyword = { fg = colors.yellow },
  CmpItemKindSnippet = { fg = colors.dark_yellow },
  CmpItemKindColor = { fg = colors.white },
  CmpItemKindFile = { fg = colors.fg },
  CmpItemKindReference = { fg = colors.purple },
  CmpItemKindFolder = { fg = colors.fg },
  CmpItemKindEnumMember = { fg = colors.yellow },
  CmpItemKindConstant = { fg = colors.yellow },
  CmpItemKindStruct = { fg = colors.blue },
  CmpItemKindEvent = { fg = colors.green },
  CmpItemKindOperator = { fg = colors.dark_cyan },
  CmpItemKindTypeParameter = { fg = colors.dark_blue },
}

-- mini.indentscope
-- `MiniIndentscopeSymbol` - symbol showing on every line of scope.
-- `MiniIndentscopePrefix` - space before symbol. By default made so as to
hl.mini_indent = {
  MiniIndentscopeSymbol = { fg = colors.white },
}

local function h(group, style)
  if style.link then
    vim.api.nvim_set_hl(0, group, { link = style.link })
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

  vim.o.background                = "dark"
  vim.g.colors_name               = "lua-embark"

  -- 256-color terminal colors
  vim.g.terminal_ansi_colors      = {
    colors.special_grey.gui, colors.red.gui, colors.green.gui,
    colors.yellow.gui, colors.blue.gui, colors.purple.gui,
    colors.cyan.gui, colors.white.gui, colors.visual_grey.gui,
    colors.dark_red.gui, colors.dark_green.gui, colors.dark_yellow.gui,
    colors.dark_blue.gui, colors.dark_purple.gui, colors.dark_cyan.gui,
    colors.comment_grey.gui,
  }

  -- Neovim terminal colors
  vim.g.terminal_color_0          = colors.black.gui
  vim.g.terminal_color_1          = colors.red.gui
  vim.g.terminal_color_2          = colors.green.gui
  vim.g.terminal_color_3          = colors.yellow.gui
  vim.g.terminal_color_4          = colors.blue.gui
  vim.g.terminal_color_5          = colors.purple.gui
  vim.g.terminal_color_6          = colors.cyan.gui
  vim.g.terminal_color_7          = colors.white.gui
  vim.g.terminal_color_8          = colors.visual_grey.gui
  vim.g.terminal_color_9          = colors.dark_red.gui
  vim.g.terminal_color_10         = colors.dark_green.gui
  vim.g.terminal_color_11         = colors.dark_yellow.gui
  vim.g.terminal_color_12         = colors.dark_blue.gui
  vim.g.terminal_color_13         = colors.dark_purple.gui
  vim.g.terminal_color_14         = colors.dark_cyan.gui
  vim.g.terminal_color_15         = colors.comment_grey.gui
  vim.g.terminal_color_background = vim.g.terminal_color_0
  vim.g.terminal_color_foreground = vim.g.terminal_color_7

  for _, hlgroup in pairs(hl) do
    for hlname, style in pairs(hlgroup) do
      -- for _, hlgroup in ipairs({ 'common', 'syntax', 'treesitter' }) do
      --   for hlname, style in pairs(hl[hlgroup]) do
      h(hlname, style)
    end
  end
end
