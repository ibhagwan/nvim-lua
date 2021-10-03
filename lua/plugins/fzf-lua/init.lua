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
    fullscreen       = false,           -- start fullscreen?
    window_on_create = function()
      -- vim.cmd("set winhl=Normal:NormalFloat,FloatBorder:Normal")
    end,
  },
  keymap = {
    builtin = {
      ["<F2>"]      = "toggle-fullscreen",
      -- Only valid with the 'builtin' previewer
      ["<F3>"]      = "toggle-preview-wrap",
      ["<F4>"]      = "toggle-preview",
      ["<S-down>"]  = "preview-page-down",
      ["<S-up>"]    = "preview-page-up",
      ["<S-left>"]  = "preview-page-reset",
    },
    fzf = {
      ["ctrl-u"]        = "unix-line-discard",
      ["ctrl-f"]        = "half-page-down",
      ["ctrl-b"]        = "half-page-up",
      ["ctrl-a"]        = "beginning-of-line",
      ["ctrl-e"]        = "end-of-line",
      ["alt-a"]         = "toggle-all",
      -- Only valid with fzf previewers (bat/cat/git/etc)
      ["f3"]            = "toggle-preview-wrap",
      ["f4"]            = "toggle-preview",
      ["shift-down"]    = "preview-page-down",
      ["shift-up"]      = "preview-page-up",
    },
  },
  fzf_bin             = 'sk',
  fzf_opts = {
      -- set to `false` to remove a flag
      ['--ansi']      = '',
      ['--prompt']    = ' >',
      ['--info']      = 'inline',
      ['--height']    = '100%',
      ['--layout']    = 'reverse',
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
      syntax          = true,           -- preview syntax highlight?
      syntax_limit_b  = 1024*1024,      -- syntax limit (bytes), 0=nolimit
      syntax_limit_l  = 0,              -- syntax limit (lines), 0=nolimit
      hl_cursor       = 'Cursor',       -- cursor highlight
      hl_cursorline   = 'CursorLine',   -- cursor line highlight
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

function M.git_history(opts)
  local path = require'fzf-lua.path'
  local core = require'fzf-lua.core'
  local config = require'fzf-lua.config'
  local actions = require 'fzf-lua.actions'
  opts = config.normalize_opts(opts, config.globals.git)
  opts.prompt = opts.prompt or "Git History> "
  opts.input_prompt = opts.input_prompt or "Search For> "

  opts.cwd = path.git_root(opts.cwd)
  local cmd = path.git_cwd("git log --pretty --oneline --color", opts.cwd)
  opts.preview = vim.fn.shellescape(path.git_cwd(
    "git show --pretty='%Cred%H%n%Cblue%an%n%Cgreen%s' --color {1}",
    opts.cwd))

  if not opts.query then
    opts.query = vim.fn.input(opts.input_prompt) or ""
  end

  -- this gets called every keystroke, setup for this
  -- is done inside 'set_fzf_interactive_cmd(opts)'
  opts._reload_command = function(query)
    return ("%s %s"):format(cmd, #query>0 and "-S "..vim.fn.shellescape(query) or "")
  end

  -- without this queries won't execute until you start typing
  -- change to false to ignore empty string queries
  opts.exec_empty_query = true
  opts = core.set_fzf_interactive_cmd(opts)

  coroutine.wrap(function ()
    local selected = core.fzf(opts)
    if not selected then return end
    actions.act(opts.actions, selected, opts)
  end)()
end

local previous_cwd = nil

function M.workdirs(opts)
  if not opts then opts = {} end

  -- workdirs.lua returns a table of workdirs
  local ok, dirs = pcall(require, 'workdirs')
  if not ok then return end

  local iconify = function(path, is_pcwd)
    local ansi_codes = require'fzf-lua.utils'.ansi_codes
    local is_cwd = (path == vim.loop.cwd())
    local icon = is_cwd and ansi_codes.magenta('')
      or is_pcwd and ansi_codes.yellow('')
      or ansi_codes.blue('')
    path = require'fzf-lua.path'.relative(vim.fn.expand(path), vim.fn.expand('$HOME'))
    return ("%s  %s"):format(icon, path), path
  end

  coroutine.wrap(function ()
    local dedup = {}
    local entries = {}
    if previous_cwd then
        local item, key = iconify(previous_cwd, true)
        entries[1] = item
        dedup[key] = item
    end
    for _, path in ipairs(dirs) do
      -- prevent duplicates
      local item, key = iconify(path)
      if dedup[key] == nil then
        dedup[key] = item
        entries[#entries+1] = item
      end
    end

    local fzf_fn = function(cb)
      for _, entry in ipairs(entries) do
        cb(entry, function(err)
          if err then return end
          cb(nil, function() end)
        end)
      end
    end

    opts.fzf_opts = {
      ['--no-multi']        = '',
      ['--prompt']          = 'Workdirs❯ ',
      ['--preview-window']  = 'hidden:right:0',
    }

    local selected = require'fzf-lua.core'.fzf(opts, fzf_fn)
    if not selected then return end
    previous_cwd = vim.loop.cwd()
    local pwd = require'fzf-lua.path'.join({
      vim.fn.expand('$HOME'), selected[1]:match("[^ ]*$")
    })
    require'utils'.set_cwd(pwd)
  end)()
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
