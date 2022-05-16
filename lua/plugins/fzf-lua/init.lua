local res, fzf_lua = pcall(require, "fzf-lua")
if not res then
  return
end

-- local fzf_bin = 'sk'
local img_prev_bin = vim.fn.executable("ueberzug") == 1
  and { "ueberzug" }
  or  { "viu", "-b" }

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
    ["prompt"] = { "fg", "Function" },
    ["pointer"] = { "fg", "Exception" },
    ["marker"] = { "fg", "Statement" },
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

-- custom devicons setup file to be loaded when `multiprocess = true`
fzf_lua.config._devicons_setup = "~/.config/nvim/lua/plugins/devicons.lua"

fzf_lua.setup {
  -- lua_io             = true,            -- perf improvement, experimental
  global_resume         = true,
  global_resume_query   = true,
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
      scrollbar_e       = 'PMenuSbar',
      scrollbar_f       = 'PMenuSel',
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
      flip_columns        = 130,
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
  winopts_fn = function()
    -- Use custom borders hls if they exist in the colorscheme
    local border = 'Normal'
    local hls = { 'NightflySteelBlue', 'TelescopeBorder', 'FloatermBorder', 'FloatBorder' }
    for _, hl in ipairs(hls) do
      if #vim.fn.synIDattr(vim.fn.hlID(hl), "fg") > 0 then
        border = hl
        break
      end
    end
    return {
      hl = { border = border },
      -- preview = {
      --   -- conditionally override the layout paramter thus overriding the 'flex' layout
      --   layout = vim.api.nvim_win_get_width(0)<100 and 'vertical' or 'horizontal'
      -- }
    }
  end,
  keymap = {
    builtin = {
      ["<F1>"]      = "toggle-help",
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
  actions = {
    files = {
      -- ["default"]       = fzf_lua.actions.file_edit,
      ["default"]       = fzf_lua.actions.file_edit_or_qf,
      ["ctrl-s"]        = fzf_lua.actions.file_split,
      ["ctrl-v"]        = fzf_lua.actions.file_vsplit,
      ["ctrl-t"]        = fzf_lua.actions.file_tabedit,
      ["alt-q"]         = fzf_lua.actions.file_sel_to_qf,
    },
    buffers = {
      ["default"]       = fzf_lua.actions.buf_switch_or_edit,
      ["ctrl-s"]        = fzf_lua.actions.buf_split,
      ["ctrl-v"]        = fzf_lua.actions.buf_vsplit,
      ["ctrl-t"]        = fzf_lua.actions.buf_tabedit,
    }
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
      ueberzug_scaler = "cover",
      extensions      = {
        ["gif"]       = img_prev_bin,
        ["png"]       = img_prev_bin,
        ["jpg"]       = img_prev_bin,
        ["jpeg"]      = img_prev_bin,
      }
    },
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
    multiprocess      = true,
    debug             = false,
  },
  grep = {
    prompt            = 'Rg❯ ',
    input_prompt      = 'Grep For❯ ',
    rg_opts           = "--column --line-number --no-heading --color=always --smart-case",
    rg_glob           = true,
    multiprocess      = true,
    debug             = false,
    debug_cmd         = false,
  },
  tags                = { debug = true, debug_cmd = false },
  btags               = { debug = true, debug_cmd = false },
  git = {
    files             = {
      prompt          = 'GitFiles❯ ',
      multiprocess    = true,
      debug           = false,
    },
    status            = {
      prompt          = 'GitStatus❯ ',
      cmd             = "git status -su",
      winopts         = {
        preview       = { vertical = "down:70%", horizontal = "right:70%" }
      },
      actions         = {
        ["ctrl-x"]    = { fzf_lua.actions.git_reset, fzf_lua.actions.resume },
      },
    },
    commits           = {
      prompt          = 'Commits❯ ',
      cmd             = "git log --color --pretty=format:'%C(yellow)%h%Creset %Cgreen(%><(12)%cr%><|(12))%Creset %s %C(blue)<%an>%Creset'",
      winopts         = { preview = { vertical = "down:60%", }}
    },
    bcommits          = {
      prompt          = 'BCommits❯ ',
      winopts         = { preview = { vertical = "down:60%", }}
    },
    branches          = {
      prompt          = 'Branches❯ ',
      winopts         = {
        preview       = {
          vertical    = "down:75%",
          horizontal  = "right:75%",
        }
      }
    },
    icons = {
        -- ["M"]    = { icon = "★", color = "red" },
        -- ["D"]    = { icon = "✗", color = "red" },
        -- ["A"]    = { icon = "+", color = "green" },
    },
  },
  args = {
    prompt            = 'Args❯ ',
    files_only        = true,
  },
  oldfiles = {
    prompt            = 'History❯ ',
    cwd_only          = false,
    stat_file         = true,
    include_current_session = false,
  },
  colorschemes = {
    prompt            = 'Colorschemes❯ ',
    live_preview      = true,
    winopts = {
      win_height        = 0.55,
      win_width         = 0.30,
    },
    post_reset_cb     = function()
      -- reset statusline highlights after
      -- a live_preview of the colorscheme
      -- require('feline').reset_highlights()
    end,
  },
  -- optional override of file extension icon colors
  -- available colors (terminal):
  --    clear, bold, black, red, green, yellow
  --    blue, magenta, cyan, grey, dark_grey, white
  file_icon_padding = '',
  file_icon_colors = {
    ["sh"]    = "green",
  },
  -- uncomment to disable the previewer
  -- nvim = { marks = { previewer = false } },
  -- nvim = { marks = { previewer = { _ctor = false } } },
  -- helptags = { previewer = false },
  -- helptags = { previewer = { _ctor = false } },
  -- manpages = { previewer = false },
  -- manpages = { previewer = { _ctor = false } },
  -- uncomment to set dummy win split (top bar)
  -- "topleft"  : up
  -- "botright" : down
  -- helptags = { previewer = { split = "topleft" } },
  -- uncomment to use `man` command as native fzf previewer
  -- manpages = { previewer = { _ctor = require'fzf-lua.previewer'.fzf.man_pages } },
}

-- register fzf-lua as vim.ui.select interface
if vim.ui then
  fzf_lua.register_ui_select({
    winopts = {
      win_height       = 0.30,
      win_width        = 0.70,
      win_row          = 0.40,
    }
  })
end

local M = {}

function M.git_status_tmuxZ(opts)
  local function tmuxZ()
    vim.cmd("!tmux resize-pane -Z")
  end
  opts = opts or {}
  opts.fn_pre_win = function(_)
    if not opts.__want_resume then
      -- new fzf window, set tmux Z
      -- add small delay or fzf
      -- win gets wrong dimensions
      tmuxZ()
      vim.cmd("sleep! 20m")
    end
    opts.__want_resume = nil
  end
  opts.fn_post_fzf = function(_, s)
    opts.__want_resume = s and (s[1] == 'left' or s[1] == 'right')
    if not opts.__want_resume then
      -- resume asked do not resize
      -- signals fn_pre to do the same
      tmuxZ()
    end
  end
  fzf_lua.git_status(opts)
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
    if not vim.loop.fs_stat(path) then return end
    if dedup[path] ~= nil then return end
    entries[#entries+1] = iconify(path, color or "blue", icon or '')
    dedup[path] = true
  end

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

  fzf_lua.fzf_wrap(opts, fzf_fn, function(selected)
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
