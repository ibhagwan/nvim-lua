if not pcall(require, "fzf-lua") then
  return
end

local actions = require "fzf-lua.actions"

local M = {}

M.setup = function()
  -- require'fzf-lua'.setup({})
  require'fzf-lua'.setup {
    winopts = {
      -- split            = "belowright new",
      win_height       = 0.85,            -- window height
      win_width        = 0.80,            -- window width
      win_row          = 0.30,            -- window row position (0=top, 1=bottom)
      win_col          = 0.50,            -- window col position (0=left, 1=right)
      -- win_border    = false,           -- window border? or borderchars?
      win_border       = { '╭', '─', '╮', '│', '╯', '─', '╰', '│' },
      hl_normal        = 'Normal',        -- window normal color
      hl_border        = 'FloatBorder',   -- window border color
      -- window_on_create = function()
        -- vim.cmd("set winhl=Normal:NormalFloat,FloatBorder:Normal")
      -- end,
    },
    fzf_bin             = 'sk',        -- use skim instead of fzf?
    fzf_layout          = 'reverse',      -- fzf '--layout='
    fzf_args            = '',             -- adv: fzf extra args, empty unless adv
    fzf_binds           = {               -- fzf '--bind=' options
        'f2:toggle-preview',
        'f3:toggle-preview-wrap',
        'shift-down:preview-page-down',
        'shift-up:preview-page-up',
        'ctrl-u:unix-line-discard',
        'ctrl-f:half-page-down',
        'ctrl-b:half-page-up',
        'alt-a:toggle-all',
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
      cmd = {
        -- custom previewer, will execute:
        -- `<cmd> <args> <filename>`
        cmd             = "echo",
        args            = "",
      },
      cat = {
        cmd             = "cat",
        args            = "--number",
      },
      bat = {
        cmd             = "bat",
        args            = "--italic-text=always --style=numbers,changes --color always",
        theme           = 'Coldark-Dark', -- bat preview theme (bat --list-themes)
        config          = "",             -- nil uses $BAT_CONFIG_PATH
      },
      head = {
        cmd             = "head",
        args            = nil,
      },
      git_diff = {
        cmd             = "git diff",
        args            = "--color",
      },
      builtin = {
        title           = true,         -- preview title?
        scrollbar       = true,         -- scrollbar?
        scrollchar      = '█',          -- scrollbar character
        wrap            = false,        -- wrap lines?
        syntax          = true,         -- preview syntax highlight?
        syntax_limit_b  = 1024*1024,    -- syntax limit (bytes), 0=nolimit
        syntax_limit_l  = 0,            -- syntax limit (lines), 0=nolimit
        expand          = false,        -- preview max size?
        hidden          = false,         -- start hidden?
        hl_cursor       = 'Cursor',     -- cursor highlight
        hl_cursorline   = 'CursorLine', -- cursor line highlight
        hl_range        = 'IncSearch',  -- ranger highlight (not yet in use)
        keymap = {
          toggle_full   = '<F2>',       -- toggle full screen
          toggle_wrap   = '<F3>',       -- toggle line wrap
          toggle_hide   = '<F4>',       -- toggle on/off (not yet in use)
          page_up       = '<S-up>',     -- preview scroll up
          page_down     = '<S-down>',   -- preview scroll down
          page_reset    = '<S-left>',      -- reset scroll to orig pos
        },
      },
    },
    -- provider setup
    files = {
      -- previewer         = "builtin",      -- uncomment to override previewer
      prompt            = 'Files❯ ',
      cmd               = '',             -- "find . -type f -printf '%P\n'",
      git_icons         = true,           -- show git icons?
      file_icons        = true,           -- show file icons?
      color_icons       = true,           -- colorize file|git icons
      actions = {
        -- set bind to 'false' to disable
        ["default"]     = actions.file_edit,
        ["ctrl-s"]      = actions.file_split,
        ["ctrl-v"]      = actions.file_vsplit,
        ["ctrl-t"]      = actions.file_tabedit,
        ["alt-q"]       = actions.file_sel_to_qf,
        -- custom actions are available too
        ["ctrl-y"]      = function(selected) print(selected[2]) end,
      },
      winopts = {
        -- hl_normal       = 'Normal',       -- window normal color
        -- hl_border       = 'Normal',       -- window border color
      }
    },
    git = {
      files = {
        prompt        = 'GitFiles❯ ',
        cmd           = 'git ls-files --exclude-standard',
        git_icons     = true,           -- show git icons?
        file_icons    = true,           -- show file icons?
        color_icons   = true,           -- colorize file|git icons
      },
      status = {
        prompt        = 'GitStatus❯ ',
        cmd           = "git status -s",
        previewer     = "git_diff",
        file_icons    = true,
        git_icons     = true,
        color_icons   = true,
      },
      commits = {
        prompt        = 'Commits❯ ',
        cmd           = "git log --pretty=oneline --abbrev-commit --color --reflog",
        preview       = "git show --pretty='%Cred%H%n%Cblue%an%n%Cgreen%s' --color {1}",
        actions = {
          ["default"] = nil,
        },
      },
      bcommits = {
        prompt        = 'BCommits❯ ',
        cmd           = "git log --pretty=oneline --abbrev-commit --color --reflog",
        preview       = "git show --pretty='%Cred%H%n%Cblue%an%n%Cgreen%s' --color {1}",
        actions = {
          ["default"] = nil,
        },
      },
      branches = {
        prompt        = 'Branches❯ ',
        cmd           = "git branch --all --color",
        preview       = "git log --graph --pretty=oneline --abbrev-commit --color {1}",
        actions = {
          ["default"] = actions.git_switch,
        },
      },
      icons = {
          ["M"]       = { icon = "M", color = "yellow" },
          ["D"]       = { icon = "D", color = "red" },
          ["A"]       = { icon = "A", color = "green" },
          ["?"]       = { icon = "?", color = "magenta" },
          -- ["M"]    = { icon = "★", color = "red" },
          -- ["D"]    = { icon = "✗", color = "red" },
          -- ["A"]    = { icon = "+", color = "green" },
      },
    },
    grep = {
      prompt            = 'Rg❯ ',
      input_prompt      = 'Grep For❯ ',
      -- cmd               = "rg --vimgrep",
      rg_opts           = "--hidden --column --line-number --no-heading " ..
                          "--color=always --smart-case -g '!{.git,node_modules}/*'",
      git_icons         = true,           -- show git icons?
      file_icons        = true,           -- show file icons?
      color_icons       = true,           -- colorize file|git icons
      actions           = { ["ctrl-q"] = false }
    },
    oldfiles = {
      prompt            = 'History❯ ',
      cwd_only          = false,
    },
    buffers = {
      -- previewer         = false,        -- disable the builtin previewer?
      prompt            = 'Buffers❯ ',
      file_icons        = true,         -- show file icons?
      color_icons       = true,         -- colorize file|git icons
      sort_lastused     = true,         -- sort buffers() by last used
      actions = {
        ["default"]     = actions.buf_edit,
        ["ctrl-s"]      = actions.buf_split,
        ["ctrl-v"]      = actions.buf_vsplit,
        ["ctrl-t"]      = actions.buf_tabedit,
        ["ctrl-x"]      = actions.buf_del,
      }
    },
    blines = {
      previewer         = "builtin",    -- set to 'false' to disable
      prompt            = 'BLines❯ ',
      actions = {
        ["default"]     = actions.buf_edit,
        ["ctrl-s"]      = actions.buf_split,
        ["ctrl-v"]      = actions.buf_vsplit,
        ["ctrl-t"]      = actions.buf_tabedit,
      }
    },
    colorschemes = {
      prompt            = 'Colorschemes❯ ',
      live_preview      = true,         -- apply the colorscheme on preview?
      actions = {
        ["default"]     = actions.colorscheme,
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
    quickfix = {
      -- cwd               = vim.loop.cwd(),
      file_icons        = true,
      git_icons         = true,
    },
    lsp = {
      prompt            = '❯ ',
      -- cwd               = vim.loop.cwd(),
      cwd_only          = false,      -- LSP/diagnostics for cwd only?
      async_or_timeout  = true,       -- timeout(ms) or false for blocking calls
      file_icons        = true,
      git_icons         = false,
      lsp_icons         = true,
      severity          = "hint",
      icons = {
        ["Error"]       = { icon = "", color = "red" },       -- error
        ["Warning"]     = { icon = "", color = "yellow" },    -- warning
        ["Information"] = { icon = "", color = "blue" },      -- info
        ["Hint"]        = { icon = "", color = "magenta" },   -- hint
      },
    },
    -- uncomment to disable the previewer
    -- helptags = { previewer = { _new = false } },
    -- manpages = { previewer = { _new = false } },
    -- uncomment to set dummy win split (top bar)
    -- "topleft"  : up
    -- "botright" : down
    -- helptags = { previewer = { split = "topleft" } },
    -- manpages = { previewer = { split = "topleft" } },
    -- uncomment 2 lines to use `man` command as native fzf previewer
    -- manpages = { previewer = { cmd  = "man", _new = function()
        -- return require 'fzf-lua.previewer'.man_pages end } },
    -- optional override of file extension icon colors
    -- available colors (terminal):
    --    clear, bold, black, red, green, yellow
    --    blue, magenta, cyan, grey, dark_grey, white
    -- padding can help kitty term users with
    -- double-width icon rendering
    file_icon_padding = '',
    file_icon_colors = {
      ["sh"]    = "green",
    },
    _winopts_raw = function() -- remove _underscore to enable (winopts_raw)
      local width = math.floor(vim.o.columns * 0.60)
      local height = math.floor(vim.o.lines * 0.65)
      if vim.o.columns < 120 then
        width = math.floor(vim.o.columns * 0.40)
      end
      local row = math.floor((vim.o.lines - height) * 0.50)
      local col = math.floor((vim.o.columns - width) * 0.50)
      return {
        height = height,
        width = width,
        row = row,
        col = col,
        -- border = 'none',
        window_on_create = function()
          print("window_on_create")
          vim.cmd("set winhl=Normal:NormalFloat,FloatBorder:VertSplit")
        end
      }
    end
  }
end


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

function M.branch_compare(opts)
  if not opts then opts = {} end
  local function branch_compare(selected, o)
    -- remove anything past space
    local branch = selected[1]:match("[^ ]+")
    -- do nothing for active branch
    if branch:find("%*") ~= nil then return end
    -- git_cwd is only required if you want to also run
    -- this outside your current working directory
    -- all it does is add `git -C <cwd_path>`
    -- this enables you to run:
    -- branch_compare({ cwd = "~/Sources/nvim/fzf-lua" })
    o.cmd = require'fzf-lua.path'.git_cwd(
      -- change this to whaetever command works best for you:
      -- git diff --name-only $(git merge-base HEAD [SELECTED_BRANCH])
      ("git diff --name-only %s"):format(branch), o.cwd)
    -- replace the previewer with our custom command
    o.previewer = {
      cmd       = require'fzf-lua.path'.git_cwd("git diff", o.cwd),
      args      = ("--color main %s -- "):format(branch),
      -- tells the previewer not to add cwd to the
      -- file path when executing the preview command
      -- relative  = true,
      _new      = function() return require 'fzf-lua.previewer'.cmd_async end,
    }
    -- disable git icons, without adjustments they will
    -- display their current status and not the branch status
    -- TODO: supply `files` with `git_diff_cmd`, `git_untracked_cmd`
    o.git_icons = false
    -- reset the default action that was carried over from the
    -- `git_branches` call
    o.actions = nil
    require'fzf-lua'.files(o)
  end
  opts.prompt = 'BranchCompare❯ '
  opts.actions = { ["default"] = branch_compare }
  require'fzf-lua'.git_branches(opts)
end


function M.git_history(opts)
  if not opts then opts = {} end
  opts.prompt = opts.prompt or "Git History> "
  opts.input_prompt = opts.input_prompt or "Search For> "

  opts.cmd = require'fzf-lua.path'.git_cwd("git log --pretty --oneline --color", opts.cwd)
  opts.preview = "git show --pretty='%Cred%H%n%Cblue%an%n%Cgreen%s' --color {1}"

  if not opts.search then
    opts.search = vim.fn.input(opts.input_prompt) or ""
  end

  opts.cmd = opts.cmd .. " -S " .. vim.fn.shellescape(opts.search)
  print(opts.cmd)
  require'fzf-lua'.git_commits(opts)
end

-- call the setup function automatically
M.setup()

return setmetatable({}, {
  __index = function(_, k)
    -- reloader()

    if M[k] then
      return M[k]
    else
      return require('fzf-lua')[k]
    end
  end,
})
