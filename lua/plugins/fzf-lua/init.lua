local res, fzf_lua = pcall(require, "fzf-lua")
if not res then
  return
end

local fzf_bin = 'sk'

local function fzf_colors(binary)
  binary = binary or fzf_bin
  local colors = {
    ["fg"] = { "fg", "CursorLine" },
    ["bg"] = { "bg", "Normal" },
    ["hl"] = { "fg", "Comment" },
    ["fg+"] = { "fg", "ModeMsg" },
    ["bg+"] = { "bg", "CursorLine" },
    ["hl+"] = { "fg", "Statement" },
    ["info"] = { "fg", "PreProc" },
    ["prompt"] = { "fg", "Conditional" },
    ["pointer"] = { "fg", "Exception" },
    ["marker"] = { "fg", "Keyword" },
    ["spinner"] = { "fg", "Label" },
    ["header"] = { "fg", "Comment" },
    ["gutter"] = { "bg", "Normal" },
  }
  if binary == 'sk' and vim.fn.executable(binary) == 1 then
    colors["matched_bg"] = { "bg", "Normal" }
    colors["current_match_bg"] = { "bg", "CursorLine" }
  end
  return colors
end

fzf_lua.setup {
  -- lua_io             = true,            -- perf improvement, experimental
  winopts = {
    -- split            = "belowright new",
    -- split            = "aboveleft vnew",
    height           = 0.85,            -- window height
    width            = 0.80,            -- window width
    row              = 0.35,            -- window row position (0=top, 1=bottom)
    col              = 0.55,            -- window col position (0=left, 1=right)
    -- border = 'double',
    -- border           = { '╭', '─', '╮', '│', '╯', '─', '╰', '│' },
    -- border = { {'╭', 'IncSearch'}, {'─', 'IncSearch'}, {'╮', 'IncSearch'}, '│', '╯', '─', '╰', '│' },
    fullscreen       = false,           -- start fullscreen?
    hl = {
      normal            = 'Normal',
      border            = 'FloatBorder',
      -- builtin preview
      cursor            = 'Cursor',
      cursorline        = 'CursorLine',
      title             = 'ModeMsg',
      scrollbar_e       = 'Visual',
      scrollbar_f       = 'WildMenu',
    },
    preview = {
      -- default             = 'bat',
      -- default             = 'bat_native',
      border              = 'border',
      wrap                = 'nowrap',
      hidden              = 'nohidden',
      vertical            = 'down:45%',
      horizontal          = 'right:60%',
      layout              = 'flex',
      flip_columns        = 120,
      title               = true,
      scrollbar           = 'float',
      -- scrolloff           = '-1',
      -- scrollchars         = {'█', '░' },
    },
    on_create        = function()
      -- print("on_create")
      -- vim.cmd("set winhl=Normal:NormalFloat,FloatBorder:Normal")
    end,
  },
  -- winopts_fn = function() return { row = 1, height=0.5, width=0.5, border = "double" } end,
  keymap = {
    builtin = {
      ["<F2>"]      = "toggle-fullscreen",
      -- Only valid with the 'builtin' previewer
      ["<F3>"]      = "toggle-preview-wrap",
      ["<F4>"]      = "toggle-preview",
      -- Rotate preview clockwise/counter-clockwise
      ["<F5>"]      = "toggle-preview-ccw",
      ["<F6>"]      = "toggle-preview-cw",
      ["<S-down>"]  = "preview-page-down",
      ["<S-up>"]    = "preview-page-up",
      ["<S-left>"]  = "preview-page-reset",
    },
    fzf = {
      ["ctrl-z"]        = "abort",
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
  fzf_opts = {
      -- set to `false` to remove a flag
      ['--ansi']      = '',
      ['--prompt']    = '> ',
      ['--info']      = 'inline',
      ['--height']    = '100%',
      ['--layout']    = 'reverse',
  },
  fzf_bin             = fzf_bin,
  fzf_colors          = fzf_colors(),
  previewers = {
    bat = {
      theme           = 'Coldark-Dark', -- bat preview theme (bat --list-themes)
    },
    man = {
      cmd             = "man -c %s | col -bx",
    },
    git_diff = {
      pager           = "delta",
    },
    builtin = {
      syntax          = true,           -- preview syntax highlight?
      syntax_limit_b  = 1024*1024,      -- syntax limit (bytes), 0=nolimit
      syntax_limit_l  = 0,              -- syntax limit (lines), 0=nolimit
    },
  },
  lsp = {
    actions = {
      -- ["default"] = function(...)
      --   print(vim.inspect(select(1, ...)))
      --   require'fzf-lua'.actions.file_edit_or_qf(...)
      -- end
    }
  },
  lines               = { prompt = 'Lines❯ ', },
  blines              = { prompt = 'BLines❯ ', },
  buffers             = { prompt = 'Buffers❯ ', },
  files = {
    prompt            = 'Files❯ ',
    actions = {
      ["ctrl-l"]      = fzf_lua.actions.arg_add,
      ["ctrl-y"]      = function(selected) print(selected[1]) end,
    },
  },
  args = {
    prompt            = 'Args❯ ',
    files_only        = true,
    actions = {
      ["ctrl-x"]      = fzf_lua.actions.arg_del,
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
    actions           = { ["ctrl-q"] = false },
    -- 'true' enables file and git icons in 'live_grep'
    -- degrades performance in large datasets, YMMV
    experimental      = true,
  },
  oldfiles = {
    prompt            = 'History❯ ',
    cwd_only          = false,
  },
  colorschemes = {
    prompt            = 'Colorschemes❯ ',
    live_preview      = true,
    actions = {
      ["ctrl-y"]      = function(selected) print(selected[1]) end,
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
  -- uncomment to use `man` command as native fzf previewer
  -- manpages = { previewer = { _ctor = require'fzf-lua.previewer'.fzf.man_pages } },
}

local M = {}

function M.edit_neovim(opts)
  if not opts then opts = {} end
  opts.prompt = "< VimRC > "
  opts.cwd = "$HOME/.config/nvim"
  fzf_lua.files(opts)
end

function M.edit_dotfiles(opts)
  if not opts then opts = {} end
  opts.prompt = "~ dotfiles ~ "
  opts.cwd = "~/dots"
  fzf_lua.files(opts)
end

function M.edit_zsh(opts)
  if not opts then opts = {} end
  opts.prompt = "~ zsh ~ "
  opts.cwd = "$HOME/.config/zsh"
  fzf_lua.files(opts)
end

function M.installed_plugins(opts)
  if not opts then opts = {} end
  opts.prompt = 'Plugins❯ '
  opts.cwd = vim.fn.stdpath "data" .. "/site/pack/packer/"
  fzf_lua.files(opts)
end

function M.buffers(opts)
  if not opts then opts = {} end
  opts.fzf_bin = 'fzf'
  opts.fzf_bin = opts.fzf_bin or fzf_bin
  opts.fzf_colors = fzf_colors(opts.fzf_bin)
  local action = require("fzf-lua.shell").action(function(selected)
    fzf_lua.actions.buf_del(selected)
    fzf_lua.win.set_autoclose(false)
    M.buffers(opts)
    fzf_lua.win.set_autoclose(true)
    -- execute with '--multi' and '{+}' is bugged with skim
  end, opts.fzf_bin == 'sk' and "{}" or "{+}")
  if not opts.curbuf then
    -- make sure we keep current buffer at the header
    opts.curbuf = vim.api.nvim_get_current_buf()
  end
  opts.actions = { ["ctrl-x"] = false }
  opts.fzf_cli_args  = ("--bind=ctrl-x:execute-silent:%s"):format(action)
  fzf_lua.buffers(opts)
end

local _previous_cwd = nil

function M.workdirs(opts)
  if not opts then opts = {} end

  -- workdirs.lua returns a table of workdirs
  local ok, dirs = pcall(require, 'workdirs')
  if not ok then dirs = {} end

  local iconify = function(path, color, icon)
    icon = fzf_lua.utils.ansi_codes[color](icon)
    path = fzf_lua.path.relative(path, vim.fn.expand('$HOME'))
    return ("%s  %s"):format(icon, path)
  end

  local dedup = {}
  local entries = {}
  local add_entry = function(path, color, icon)
    if not path then return end
    path = vim.fn.expand(path)
    if dedup[path] ~= nil then return end
    entries[#entries+1] = iconify(path, color or "blue", icon or '')
    dedup[path] = true
  end

  coroutine.wrap(function ()
    add_entry(vim.loop.cwd(), "magenta", '')
    add_entry(_previous_cwd, "yellow")
    for _, path in ipairs(dirs) do
      add_entry(path)
    end

    local fzf_fn = function(cb)
      for _, entry in ipairs(entries) do
        cb(entry)
      end
      cb(nil)
    end

    opts.fzf_opts = {
      ['--no-multi']        = '',
      ['--prompt']          = 'Workdirs❯ ',
      ['--preview-window']  = 'hidden:right:0',
      ['--header-lines']    = '1',
    }

    local selected = fzf_lua.fzf(opts, fzf_fn)
    if not selected then return end
    _previous_cwd = vim.loop.cwd()
    local newcwd = selected[1]:match("[^ ]*$")
    newcwd = fzf_lua.path.starts_with_separator(newcwd) and newcwd
      or fzf_lua.path.join({ vim.fn.expand('$HOME'), newcwd })
    require'utils'.set_cwd(newcwd)
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
