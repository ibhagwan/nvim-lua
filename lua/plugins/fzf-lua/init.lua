local res, fzf_lua = pcall(require, "fzf-lua")
if not res then
  return
end

-- local fzf_bin = 'sk'
local img_prev_bin = vim.fn.executable("ueberzug") == 1
  and { "ueberzug" }
  or  { "viu", "-b" }

-- return first matching highlight or nil
local function hl_match(t)
  for _, h in ipairs(t) do
    local ok, hl = pcall(vim.api.nvim_get_hl_by_name, h, true)
    -- must have at least bg or fg, otherwise this returns
    -- succesffully for cleared highlights (on colorscheme switch)
    if ok and (hl.foreground or hl.background) then
      return h
    end
  end
end

local fzf_colors = function(opts)
  local binary = opts and opts.fzf_bin
  local colors = {
    ["fg"] = { "fg", "Normal" },
    ["bg"] = { "bg", "Normal" },
    ["hl"] = { "fg", hl_match({ "NightflyViolet", "Directory" }) },
    ["fg+"] = { "fg", "Normal" },
    ["bg+"] = { "bg", hl_match({ "NightflyVisual", "CursorLine" }) },
    ["hl+"] = { "fg", "CmpItemKindVariable" },
    ["info"] = { "fg", hl_match({ "NightflyPeach", "WarningMsg" }) },
    -- ["prompt"] = { "fg", "SpecialKey" },
    ["pointer"] = { "fg", "DiagnosticError" },
    ["marker"] = { "fg", "DiagnosticError" },
    ["spinner"] = { "fg", "Label" },
    ["header"] = { "fg", "Comment" },
    ["gutter"] = { "bg", "Normal" },
  }
  if binary == 'sk' and vim.fn.executable(binary) == 1 then
    colors["matched_bg"] = { "bg", "Normal" }
    colors["current_match_bg"] = { "bg", hl_match({ "NightflyVisual", "CursorLine" }) }
  end
  return colors
end

-- custom devicons setup file to be loaded when `multiprocess = true`
fzf_lua.config._devicons_setup = "~/.config/nvim/lua/plugins/devicons.lua"

fzf_lua.setup {
  fzf_bin            = fzf_bin,
  fzf_colors         = fzf_colors,
  winopts = {
    -- split         = "belowright new",
    -- split         = "aboveleft vnew",
    height           = 0.85,
    width            = 0.80,
    row              = 0.35,
    col              = 0.55,
    -- border = { {'╭', 'IncSearch'}, {'─', 'IncSearch'}, {'╮', 'IncSearch'}, '│', '╯', '─', '╰', '│' },
    preview = {
      layout              = 'flex',
      flip_columns        = 130,
      scrollbar           = 'float',
      -- scrolloff        = '-1',
      -- scrollchars      = {'█', '░' },
    },
    -- on_create        = function()
    --   print("on_create")
    -- end,
  },
  winopts_fn = function()
    local hl = {
      border = hl_match({ 'NightflySteelBlue' }),
      cursorline = hl_match({ 'NightflyVisual' }),
      cursorlinenr = hl_match({ 'NightflyVisual' }),
    }
    return { hl = hl }
  end,
  previewers = {
    bat               = { theme = 'Coldark-Dark', },
    git_diff          = { pager = "delta", },
    builtin = {
      ueberzug_scaler = "cover",
      extensions      = {
        ["gif"]       = img_prev_bin,
        ["png"]       = img_prev_bin,
        ["jpg"]       = img_prev_bin,
        ["jpeg"]      = img_prev_bin,
      }
    },
  },
  files               = { actions = { ["ctrl-l"] = fzf_lua.actions.arg_add } },
  grep = {
    rg_glob           = true,
    rg_opts           = "--hidden --column --line-number --no-heading"
                      .. " --color=always --smart-case -g '!.git'",
  },
  git = {
    status = {
      cmd             = "git status -su",
      winopts         = {
        preview       = { vertical = "down:70%", horizontal = "right:70%" }
      },
      actions         = {
        ["ctrl-x"]    = { fzf_lua.actions.git_reset, fzf_lua.actions.resume },
      },
    },
    commits = {
      cmd             = "git log --color --pretty=format:'%C(yellow)%h%Creset %Cgreen(%><(12)%cr%><|(12))%Creset %s %C(blue)<%an>%Creset'",
      winopts         = { preview = { vertical = "down:60%", }}
    },
    bcommits          = { winopts = { preview = { vertical = "down:60%", }} },
    branches          = { winopts = {
      preview         = { vertical = "down:75%", horizontal = "right:75%", }
    }},
  },
  diagnostics         = { icon_padding = ' ' },
  -- Not needed anymore, see 'plugins/devicons.lua'
  -- file_icon_colors    = { ["sh"] = "green", },
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

function M.git_bcommits(opts)
  local function diffthis(action)
    return function(...)
      local curwin = vim.api.nvim_get_current_win()
      action(...)
      vim.cmd("windo diffthis")
      vim.api.nvim_set_current_win(curwin)
    end
  end
  opts.actions = {
    ["ctrl-v"] = diffthis(fzf_lua.actions.git_buf_vsplit),
  }
  return fzf_lua.git_bcommits(opts)
end

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
    path = fzf_lua.path.relative(path, vim.env.HOME)
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

  opts.actions = {
    ['default'] = function(selected)
      _previous_cwd = vim.loop.cwd()
      local newcwd = selected[1]:match("[^ ]*$")
      newcwd = fzf_lua.path.starts_with_separator(newcwd) and newcwd
      or fzf_lua.path.join({ vim.env.HOME, newcwd })
      require'utils'.set_cwd(newcwd)
    end
  }

  fzf_lua.fzf_exec(fzf_fn, opts)
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
