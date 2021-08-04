local M = {}

M.set = function(theme)
  -- search for the theme colors
  local success, colors = pcall(require, string.format("colors.%s", theme))
  if success then
    M.set_colorscheme(colors, theme)
  end
end

M.set_colorscheme = function(hl, theme)
  if not hl or not hl.c then return end
  vim.cmd('highlight clear')

  if vim.g.syntax_on ~= nil then
    vim.cmd('syntax reset')
  end

  vim.cmd('set t_Co=256')
  vim.o.background = 'dark'
  vim.g.colors_name = "lua-" .. theme

  local colors = hl.c
  local bg = colors.bg or colors.black
  local fg = colors.fg or colors.white
  local red = colors.red
  local dark_red = colors.dark_red
  local green = colors.green
  local dark_green = colors.dark_green or colors.green
  local yellow = colors.yellow
  local dark_yellow = colors.dark_yellow
  local blue = colors.blue
  local dark_blue = colors.dark_blue or colors.blue
  local purple = colors.purple
  local dark_purple = colors.dark_purple or colors.purple
  local cyan = colors.cyan
  local dark_cyan = colors.dark_cyan or colors.cyan
  local white = colors.white or colors.fg
  local black = colors.black or colors.bg
  local comment_grey = colors.comment_grey
  local visual_grey = colors.visual_grey
  local special_grey = colors.special_grey

  local terminal_italics = vim.g.nvimlua_terminal_italics or false

  if (vim.g.nvimlua_termcolors or 256) == 16 then
    for _, color in pairs(colors) do
      color.cterm = color.cterm16
      color.cterm16 = nil
    end
  end

  -- 256-color terminal colors
  vim.g.terminal_ansi_colors = {
    special_grey.gui, red.gui, green.gui, yellow.gui,
    blue.gui, purple.gui, cyan.gui, white.gui,
    visual_grey.gui, dark_red.gui, dark_green.gui, dark_yellow.gui,
    dark_blue.gui, dark_purple.gui, dark_cyan.gui, comment_grey.gui,
  }

  local function h(group, style)
    if not terminal_italics then
      if style.cterm == 'italic' then
        style.cterm = nil
      end
      if style.gui == 'italic' then
        style.gui = nil
      end
    end

    local guifg, guibg, guisp, ctermfg, ctermbg

    if style.fg then
      guifg = style.fg.gui
      ctermfg = style.fg.cterm
    else
      guifg = 'NONE'
      ctermfg = 'NONE'
    end

    if style.bg then
      guibg = style.bg.gui
      ctermbg = style.bg.cterm
    else
      guibg = 'NONE'
      ctermbg = 'NONE'
    end

    if style.sp then
      guisp = style.sp.gui
    else
      guisp = 'NONE'
    end

    local gui = style.gui or 'NONE'
    local cterm = style.cterm or 'NONE'

    local hi = 'highlight ' .. group
      .. ' guifg='   .. guifg
      .. ' guibg='   .. guibg
      .. ' guisp='   .. guisp
      .. ' gui='     .. gui
      .. ' ctermfg=' .. ctermfg
      .. ' ctermbg=' .. ctermbg
      .. ' cterm='   .. cterm

    vim.api.nvim_command(hi)
  end

  for _, t in ipairs({
    hl.common,
    hl.syntax,
    hl.ts,
    hl.lsp,
  }) do
    for k, v in pairs(t) do h(k, v) end
  end


  -- CSS
  h('cssAttrComma',         { fg = purple })
  h('cssAttributeSelector', { fg = green })
  h('cssBraces',            { fg = white })
  h('cssClassName',         { fg = dark_yellow })
  h('cssClassNameDot',      { fg = dark_yellow })
  h('cssDefinition',        { fg = purple })
  h('cssFontAttr',          { fg = dark_yellow })
  h('cssFontDescriptor',    { fg = purple })
  h('cssFunctionName',      { fg = blue })
  h('cssIdentifier',        { fg = blue })
  h('cssImportant',         { fg = purple })
  h('cssInclude',           { fg = white })
  h('cssIncludeKeyword',    { fg = purple })
  h('cssMediaType',         { fg = dark_yellow })
  h('cssProp',              { fg = white })
  h('cssPseudoClassId',     { fg = dark_yellow })
  h('cssSelectorOp',        { fg = purple })
  h('cssSelectorOp2',       { fg = purple })
  h('cssTagName',           { fg = red })

  -- Fish Shell
  h('fishKeyword',     { fg = purple })
  h('fishConditional', { fg = purple })

  -- Go
  h('goDeclaration',  { fg = purple })
  h('goBuiltins',     { fg = cyan })
  h('goFunctionCall', { fg = blue })
  h('goVarDefs',      { fg = red })
  h('goVarAssign',    { fg = red })
  h('goVar',          { fg = purple })
  h('goConst',        { fg = purple })
  h('goType',         { fg = yellow })
  h('goTypeName',     { fg = yellow })
  h('goDeclType',     { fg = cyan })
  h('goTypeDecl',     { fg = purple })

  -- HTML (keep consistent with Markdown, below)
  h('htmlArg',            { fg = dark_yellow })
  h('htmlBold',           { fg = dark_yellow, gui = 'bold', cterm = 'bold' })
  h('htmlEndTag',         { fg = white })
  h('htmlH1',             { fg = red })
  h('htmlH2',             { fg = red })
  h('htmlH3',             { fg = red })
  h('htmlH4',             { fg = red })
  h('htmlH5',             { fg = red })
  h('htmlH6',             { fg = red })
  h('htmlItalic',         { fg = purple, gui = 'italic', cterm = 'italic' })
  h('htmlLink',           { fg = dark_cyan, gui = 'underline', cterm = 'underline' })
  h('htmlSpecialChar',    { fg = dark_yellow })
  h('htmlSpecialTagName', { fg = red })
  h('htmlTag',            { fg = white })
  h('htmlTagN',           { fg = red })
  h('htmlTagName',        { fg = red })
  h('htmlTitle',          { fg = white })

  -- JavaScript
  h('javaScriptBraces',       { fg = white })
  h('javaScriptFunction',     { fg = purple })
  h('javaScriptIdentifier',   { fg = purple })
  h('javaScriptNull',         { fg = dark_yellow })
  h('javaScriptNumber',       { fg = dark_yellow })
  h('javaScriptRequire',      { fg = cyan })
  h('javaScriptReserved',     { fg = purple })
  -- http//github.com/pangloss/vim-javascript
  h('jsArrowFunction',        { fg = purple })
  h('jsClassKeyword',         { fg = purple })
  h('jsClassMethodType',      { fg = purple })
  h('jsDocParam',             { fg = blue })
  h('jsDocTags',              { fg = purple })
  h('jsExport',               { fg = purple })
  h('jsExportDefault',        { fg = purple })
  h('jsExtendsKeyword',       { fg = purple })
  h('jsFrom',                 { fg = purple })
  h('jsFuncCall',             { fg = blue })
  h('jsFunction',             { fg = purple })
  h('jsGenerator',            { fg = yellow })
  h('jsGlobalObjects',        { fg = yellow })
  h('jsImport',               { fg = purple })
  h('jsModuleAs',             { fg = purple })
  h('jsModuleWords',          { fg = purple })
  h('jsModules',              { fg = purple })
  h('jsNull',                 { fg = dark_yellow })
  h('jsOperator',             { fg = purple })
  h('jsStorageClass',         { fg = purple })
  h('jsSuper',                { fg = red })
  h('jsTemplateBraces',       { fg = dark_red })
  h('jsTemplateVar',          { fg = green })
  h('jsThis',                 { fg = red })
  h('jsUndefined',            { fg = dark_yellow })
  -- http//github.com/othree/yajs.vim
  h('javascriptArrowFunc',    { fg = purple })
  h('javascriptClassExtends', { fg = purple })
  h('javascriptClassKeyword', { fg = purple })
  h('javascriptDocNotation',  { fg = purple })
  h('javascriptDocParamName', { fg = blue })
  h('javascriptDocTags',      { fg = purple })
  h('javascriptEndColons',    { fg = white })
  h('javascriptExport',       { fg = purple })
  h('javascriptFuncArg',      { fg = white })
  h('javascriptFuncKeyword',  { fg = purple })
  h('javascriptIdentifier',   { fg = red })
  h('javascriptImport',       { fg = purple })
  h('javascriptMethodName',   { fg = white })
  h('javascriptObjectLabel',  { fg = white })
  h('javascriptOpSymbol',     { fg = cyan })
  h('javascriptOpSymbols',    { fg = cyan })
  h('javascriptPropertyName', { fg = green })
  h('javascriptTemplateSB',   { fg = dark_red })
  h('javascriptVariable',     { fg = purple })

  -- JSON
  h('jsonCommentError',      { fg = white })
  h('jsonKeyword',           { fg = red })
  h('jsonBoolean',           { fg = dark_yellow })
  h('jsonNumber',            { fg = dark_yellow })
  h('jsonQuote',             { fg = white })
  h('jsonMissingCommaError', { fg = red, gui = 'reverse' })
  h('jsonNoQuotesError',     { fg = red, gui = 'reverse' })
  h('jsonNumError',          { fg = red, gui = 'reverse' })
  h('jsonString',            { fg = green })
  h('jsonStringSQError',     { fg = red, gui = 'reverse' })
  h('jsonSemicolonError',    { fg = red, gui = 'reverse' })

  -- LESS
  h('lessVariable',      { fg = purple })
  h('lessAmpersandChar', { fg = white })
  h('lessClass',         { fg = dark_yellow })

  -- Markdown (keep consistent with HTML, above)
  h('markdownBlockquote',        { fg = comment_grey })
  h('markdownBold',              { fg = dark_yellow, gui = 'bold', cterm = 'bold' })
  h('markdownCode',              { fg = green })
  h('markdownCodeBlock',         { fg = green })
  h('markdownCodeDelimiter',     { fg = green })
  h('markdownH1',                { fg = red })
  h('markdownH2',                { fg = red })
  h('markdownH3',                { fg = red })
  h('markdownH4',                { fg = red })
  h('markdownH5',                { fg = red })
  h('markdownH6',                { fg = red })
  h('markdownHeadingDelimiter',  { fg = red })
  h('markdownHeadingRule',       { fg = comment_grey })
  h('markdownId',                { fg = purple })
  h('markdownIdDeclaration',     { fg = blue })
  h('markdownIdDelimiter',       { fg = purple })
  h('markdownItalic',            { fg = purple, gui = 'italic', cterm = 'italic' })
  h('markdownLinkDelimiter',     { fg = purple })
  h('markdownLinkText',          { fg = dark_blue })
  h('markdownListMarker',        { fg = red })
  h('markdownOrderedListMarker', { fg = red })
  h('markdownRule',              { fg = comment_grey })
  h('markdownUrl',               { fg = dark_cyan, gui = 'underline', cterm = 'underline' })

  -- Perl
  h('perlFiledescRead',      { fg = green })
  h('perlFunction',          { fg = purple })
  h('perlMatchStartEnd',     { fg = blue })
  h('perlMethod',            { fg = purple })
  h('perlPOD',               { fg = comment_grey })
  h('perlSharpBang',         { fg = comment_grey })
  h('perlSpecialString',     { fg = dark_yellow })
  h('perlStatementFiledesc', { fg = red })
  h('perlStatementFlow',     { fg = red })
  h('perlStatementInclude',  { fg = purple })
  h('perlStatementScalar',   { fg = purple })
  h('perlStatementStorage',  { fg = purple })
  h('perlSubName',           { fg = yellow })
  h('perlVarPlain',          { fg = blue })

  -- PHP
  h('phpVarSelector',    { fg = red })
  h('phpOperator',       { fg = white })
  h('phpParent',         { fg = white })
  h('phpMemberSelector', { fg = white })
  h('phpType',           { fg = purple })
  h('phpKeyword',        { fg = purple })
  h('phpClass',          { fg = yellow })
  h('phpUseClass',       { fg = white })
  h('phpUseAlias',       { fg = white })
  h('phpInclude',        { fg = purple })
  h('phpClassExtends',   { fg = green })
  h('phpDocTags',        { fg = white })
  h('phpFunction',       { fg = blue })
  h('phpFunctions',      { fg = cyan })
  h('phpMethodsVar',     { fg = dark_yellow })
  h('phpMagicConstants', { fg = dark_yellow })
  h('phpSuperglobals',   { fg = red })
  h('phpConstants',      { fg = dark_yellow })

  -- Ruby
  h('rubyBlockParameter',            { fg = red})
  h('rubyBlockParameterList',        { fg = red })
  h('rubyClass',                     { fg = purple})
  h('rubyConstant',                  { fg = yellow})
  h('rubyControl',                   { fg = purple })
  h('rubyEscape',                    { fg = red})
  h('rubyFunction',                  { fg = blue})
  h('rubyGlobalVariable',            { fg = red})
  h('rubyInclude',                   { fg = blue})
  h('rubyIncluderubyGlobalVariable', { fg = red})
  h('rubyInstanceVariable',          { fg = red})
  h('rubyInterpolation',             { fg = cyan })
  h('rubyInterpolationDelimiter',    { fg = red })
  h('rubyInterpolationDelimiter',    { fg = red})
  h('rubyRegexp',                    { fg = cyan})
  h('rubyRegexpDelimiter',           { fg = cyan})
  h('rubyStringDelimiter',           { fg = green})
  h('rubySymbol',                    { fg = cyan})

  -- Sass
  -- http//github.com/tpope/vim-haml
  h('sassAmpersand',      { fg = red })
  h('sassClass',          { fg = dark_yellow })
  h('sassControl',        { fg = purple })
  h('sassExtend',         { fg = purple })
  h('sassFor',            { fg = white })
  h('sassFunction',       { fg = cyan })
  h('sassId',             { fg = blue })
  h('sassInclude',        { fg = purple })
  h('sassMedia',          { fg = purple })
  h('sassMediaOperators', { fg = white })
  h('sassMixin',          { fg = purple })
  h('sassMixinName',      { fg = blue })
  h('sassMixing',         { fg = purple })
  h('sassVariable',       { fg = purple })
  -- http//github.com/cakebaker/scss-syntax.vim
  h('scssExtend',         { fg = purple })
  h('scssImport',         { fg = purple })
  h('scssInclude',        { fg = purple })
  h('scssMixin',          { fg = purple })
  h('scssSelectorName',   { fg = dark_yellow })
  h('scssVariable',       { fg = purple })

  -- TeX
  h('texStatement',    { fg = purple })
  h('texSubscripts',   { fg = dark_yellow })
  h('texSuperscripts', { fg = dark_yellow })
  h('texTodo',         { fg = dark_red })
  h('texBeginEnd',     { fg = purple })
  h('texBeginEndName', { fg = blue })
  h('texMathMatcher',  { fg = blue })
  h('texMathDelim',    { fg = blue })
  h('texDelimiter',    { fg = dark_yellow })
  h('texSpecialChar',  { fg = dark_yellow })
  h('texCite',         { fg = blue })
  h('texRefZone',      { fg = blue })

  -- TypeScript
  h('typescriptReserved',  { fg = purple })
  h('typescriptEndColons', { fg = white })
  h('typescriptBraces',    { fg = white })

  -- XML
  h('xmlAttrib',  { fg = dark_yellow })
  h('xmlEndTag',  { fg = red })
  h('xmlTag',     { fg = red })
  h('xmlTagName', { fg = red })

  -- airblade/vim-gitgutter
  vim.cmd('hi link GitGutterAdd    SignifySignAdd')
  vim.cmd('hi link GitGutterChange SignifySignChange')
  vim.cmd('hi link GitGutterDelete SignifySignDelete')

  -- dense-analysis/ale
  h('ALEError',   { fg = red, gui = 'underline', cterm = 'underline' })
  h('ALEWarning', { fg = yellow, gui = 'underline', cterm = 'underline'})
  h('ALEInfo',    { gui = 'underline', cterm = 'underline'})

  -- easymotion/vim-easymotion
  h('EasyMotionTarget',        { fg = red, gui = 'bold', cterm = 'bold' })
  h('EasyMotionTarget2First',  { fg = yellow, gui = 'bold', cterm = 'bold' })
  h('EasyMotionTarget2Second', { fg = dark_yellow, gui = 'bold', cterm = 'bold' })
  h('EasyMotionShade',         { fg = comment_grey })

  -- mhinz/vim-signify
  h('SignifySignAdd',    { fg = green })
  h('SignifySignChange', { fg = yellow })
  h('SignifySignDelete', { fg = red })

  -- neomake/neomake
  h('NeomakeWarningSign', { fg = yellow })
  h('NeomakeErrorSign',   { fg = red })
  h('NeomakeInfoSign',    { fg = blue })

  -- plasticboy/vim-markdown (keep consistent with Markdown, above)
  h('mkdDelimiter', { fg = purple })
  h('mkdHeading',   { fg = red })
  h('mkdLink',      { fg = blue })
  h('mkdURL',       { fg = cyan, gui = 'underline', cterm = 'underline' })

  -- tpope/vim-fugitive
  -- diffOnly       xxx links to Constant
  -- diffIdentical  xxx links to Constant
  -- diffDiffer     xxx links to Constant
  -- diffBDiffer    xxx links to Constant
  -- diffIsA        xxx links to Constant
  -- diffCommon     xxx links to Constant
  -- diffChanged    xxx links to PreProc
  -- diffComment    xxx links to Comment
  h('diffAdded',      { fg = green })
  h('diffRemoved',    { fg = red })
  h('diffFile',       { fg = white, gui = 'bold', cterm = 'bold' })
  h('diffFileId',     { fg = blue, gui = 'bold,reverse', cterm = 'bold,reverse' })
  h('diffNewFile',    { fg = white, gui = 'bold', cterm = 'bold' })
  h('diffOldFile',    { fg = white, gui = 'bold', cterm = 'bold' })
  h('diffIndexLine',  { fg = white, gui = 'bold', cterm = 'bold' })
  h("diffLine",       { fg = purple })
  h("diffNoEOL",      { fg = purple })
  h("diffSubname",    { fg = white })

  -- Git Highlighting
  h('gitcommitComment',       { fg = comment_grey })
  h('gitcommitUnmerged',      { fg = green })
  h('gitcommitOnBranch',      { })
  h('gitcommitBranch',        { fg = purple })
  h('gitcommitDiscardedType', { fg = red })
  h('gitcommitSelectedType',  { fg = green })
  h('gitcommitHeader',        { })
  h('gitcommitUntrackedFile', { fg = cyan })
  h('gitcommitDiscardedFile', { fg = red })
  h('gitcommitSelectedFile',  { fg = green })
  h('gitcommitUnmergedFile',  { fg = yellow })
  h('gitcommitFile',          { })
  h('gitcommitSummary',       { fg = white })
  h('gitcommitOverflow',      { fg = red })
  vim.cmd('hi link gitcommitNoBranch gitcommitBranch')
  vim.cmd('hi link gitcommitUntracked gitcommitComment')
  vim.cmd('hi link gitcommitDiscarded gitcommitComment')
  vim.cmd('hi link gitcommitSelected gitcommitComment')
  vim.cmd('hi link gitcommitDiscardedArrow gitcommitDiscardedFile')
  vim.cmd('hi link gitcommitSelectedArrow gitcommitSelectedFile')
  vim.cmd('hi link gitcommitUnmergedArrow gitcommitUnmergedFile')

    -- Nvim-tree support
  h("NvimTreeFolderIcon", { fg = purple })
  h("NvimTreeFolderName", { fg = blue })
  h("NvimTreeRootFolder", { fg = green })

  -- Neovim terminal colors
  vim.g.terminal_color_0  = black.gui
  vim.g.terminal_color_1  = red.gui
  vim.g.terminal_color_2  = green.gui
  vim.g.terminal_color_3  = yellow.gui
  vim.g.terminal_color_4  = blue.gui
  vim.g.terminal_color_5  = purple.gui
  vim.g.terminal_color_6  = cyan.gui
  vim.g.terminal_color_7  = white.gui
  vim.g.terminal_color_8  = visual_grey.gui
  vim.g.terminal_color_9  = dark_red.gui
  vim.g.terminal_color_10 = dark_green.gui
  vim.g.terminal_color_11 = dark_yellow.gui
  vim.g.terminal_color_12 = dark_blue.gui
  vim.g.terminal_color_13 = dark_purple.gui
  vim.g.terminal_color_14 = dark_cyan.gui
  vim.g.terminal_color_15 = comment_grey.gui
  vim.g.terminal_color_background = vim.g.terminal_color_0
  vim.g.terminal_color_foreground = vim.g.terminal_color_7

end

return M
