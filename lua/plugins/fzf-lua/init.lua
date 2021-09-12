if not pcall(require, "fzf-lua") then
  return
end

require'fzf-lua'.setup {
  -- lua_io             = true,            -- perf improvement, experimental
  winopts = {
    -- split            = "belowright new",
    win_height       = 0.85,            -- window height
    win_width        = 0.80,            -- window width
    win_row          = 0.30,            -- window row position (0=top, 1=bottom)
    win_col          = 0.50,            -- window col position (0=left, 1=right)
    -- win_border    = false,           -- window border? or borderchars?
    -- win_border       = { '╭', '─', '╮', '│', '╯', '─', '╰', '│' },
    -- win_border       = { '╭', '─', '╮', '│', '╯', '─', '╰', {'│', 'NormalFloat' } },
    hl_normal        = 'Normal',        -- window normal color
    hl_border        = 'FloatBorder',   -- window border color
    -- window_on_create = function()
      -- vim.cmd("set winhl=Normal:NormalFloat,FloatBorder:Normal")
    -- end,
  },
  fzf_bin             = 'sk',
  fzf_binds           = {
      ["f4"]          = "abort",
      ["f2"]          = "toggle-preview",
      ["f3"]          = "toggle-preview-wrap",
      ["shift-down"]  = "preview-page-down",
      ["shift-up"]    = "preview-page-up",
      ["ctrl-u"]      = "unix-line-discard",
      ["ctrl-f"]      = "half-page-down",
      ["ctrl-b"]      = "half-page-up",
      ["ctrl-a"]      = "beginning-of-line",
      ["ctrl-e"]      = "end-of-line",
      ["alt-a"]       = "toggle-all",
  },
  fzf_colors = {
      ["fg"] = { "fg", "CursorLine" },
      ["bg"] = { "bg", "Normal" },
      ["hl"] = { "fg", "Comment" },
      ["fg+"] = { "fg", "Normal" },
      ["bg+"] = { "bg", "CursorLine" },
      ["hl+"] = { "fg", "Statement" },
      ["info"] = { "fg", "PreProc" },
      ["prompt"] = { "fg", "Conditional" },
      ["pointer"] = { "fg", "Exception" },
      ["marker"] = { "fg", "Keyword" },
      ["spinner"] = { "fg", "Label" },
      ["header"] = { "fg", "Comment" },
      ["gutter"] = { "bg", "Normal" },
  },
  preview_border      = 'border',       -- border|noborder
  preview_wrap        = 'nowrap',       -- wrap|nowrap
  preview_opts        = 'nohidden',     -- hidden|nohidden
  preview_vertical    = 'down:45%',     -- up|down:size
  preview_horizontal  = 'right:60%',    -- right|left:size
  preview_layout      = 'flex',         -- horizontal|vertical|flex
  flip_columns        = 120,            -- #cols to switch to horizontal on flex
  -- default_previewer   = "bat",       -- override the default previewer?
                                        -- by default uses the builtin previewer
  previewers = {
    bat = {
      theme           = 'Coldark-Dark', -- bat preview theme (bat --list-themes)
    },
    builtin = {
      title           = true,           -- preview title?
      scrollbar       = true,           -- scrollbar?
      scrollchar      = '█',            -- scrollbar character
      wrap            = false,          -- wrap lines?
      syntax          = true,           -- preview syntax highlight?
      syntax_limit_b  = 1024*1024,      -- syntax limit (bytes), 0=nolimit
      syntax_limit_l  = 0,              -- syntax limit (lines), 0=nolimit
      expand          = false,          -- preview max size?
      hidden          = false,          -- start hidden?
      hl_cursor       = 'Cursor',       -- cursor highlight
      hl_cursorline   = 'CursorLine',   -- cursor line highlight
      hl_range        = 'IncSearch',    -- ranger highlight (not yet in use)
      keymap = {
        toggle_full   = '<F2>',         -- toggle full screen
        toggle_wrap   = '<F3>',         -- toggle line wrap
        toggle_hide   = '<F4>',         -- toggle on/off (not yet in use)
        page_up       = '<S-up>',       -- preview scroll up
        page_down     = '<S-down>',     -- preview scroll down
        page_reset    = '<S-left>',     -- reset scroll to orig pos
      },
    },
  },
  lsp                 = { prompt = '❯ ', },
  lines               = { prompt = 'Lines❯ ', },
  blines              = { prompt = 'BLines❯ ', },
  buffers             = { prompt = 'Buffers❯ ', },
  files = {
    prompt            = 'Files❯ ',
    actions = {
      ["ctrl-y"]      = function(selected) print(selected[2]) end,
    },
  },
  git = {
    files             = { prompt = 'GitFiles❯ ', },
    status            = { prompt = 'GitStatus❯ ', },
    commits           = { prompt = 'Commits❯ ', },
    bcommits          = { prompt = 'BCommits❯ ', },
    branches          = { prompt = 'Branches❯ ', },
    icons = {
        -- ["M"]    = { icon = "★", color = "red" },
        -- ["D"]    = { icon = "✗", color = "red" },
        -- ["A"]    = { icon = "+", color = "green" },
    },
  },
  grep = {
    prompt            = 'Rg❯ ',
    input_prompt      = 'Grep For❯ ',
    actions           = { ["ctrl-q"] = false }
  },
  oldfiles = {
    prompt            = 'History❯ ',
    cwd_only          = false,
  },
  colorschemes = {
    prompt            = 'Colorschemes❯ ',
    live_preview      = true,
    actions = {
      ["ctrl-y"]      = function(selected) print(selected[2]) end,
    },
    winopts = {
      win_height        = 0.55,
      win_width         = 0.30,
    },
    post_reset_cb     = function()
      -- reset statusline highlights after
      -- a live_preview of the colorscheme
      require('feline').reset_highlights()
    end,
  },
  -- optional override of file extension icon colors
  -- available colors (terminal):
  --    clear, bold, black, red, green, yellow
  --    blue, magenta, cyan, grey, dark_grey, white
  file_icon_colors = {
    ["sh"]    = "green",
  },
  -- uncomment to disable the previewer
  -- nvim = { marks = { previewer = { _ctor = false } } },
  -- helptags = { previewer = { _ctor = false } },
  -- manpages = { previewer = { _ctor = false } },
  -- uncomment to set dummy win split (top bar)
  -- "topleft"  : up
  -- "botright" : down
  -- helptags = { previewer = { split = "topleft" } },
  -- manpages = { previewer = { split = "topleft" } },
  -- uncomment to use `man` command as native fzf previewer
  -- manpages = { previewer = { _ctor = require'fzf-lua.previewer'.fzf.man_pages } },
}

local M = {}

function M.edit_neovim(opts)
  if not opts then opts = {} end
  opts.prompt = "< VimRC > "
  opts.cwd = "$HOME/.config/nvim"
  require'fzf-lua'.files(opts)
end

function M.edit_dotfiles(opts)
  if not opts then opts = {} end
  opts.prompt = "~ dotfiles ~ "
  opts.cwd = "~/dots"
  require'fzf-lua'.files(opts)
end

function M.edit_zsh(opts)
  if not opts then opts = {} end
  opts.prompt = "~ zsh ~ "
  opts.cwd = "$HOME/.config/zsh"
  require'fzf-lua'.files(opts)
end

function M.installed_plugins(opts)
  if not opts then opts = {} end
  opts.prompt = 'Plugins❯ '
  opts.cwd = vim.fn.stdpath "data" .. "/site/pack/packer/"
  require'fzf-lua'.files(opts)
end

return setmetatable({}, {
  __index = function(_, k)

    if M[k] then
      return M[k]
    else
      return require('fzf-lua')[k]
    end
  end,
})
