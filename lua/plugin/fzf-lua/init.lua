if not pcall(require, "fzf-lua") then
  return
end

local actions = require "fzf-lua.actions"

local M = {}

M.setup = function()
  -- require'fzf-lua'.setup({})
  require'fzf-lua'.setup {
    winopts = {
      win_height       = 0.85,            -- window height
      win_width        = 0.80,            -- window width
      win_row          = 0.30,            -- window row position (0=top, 1=bottom)
      win_col          = 0.50,            -- window col position (0=left, 1=right)
      -- win_border    = false,           -- window border? or borderchars?
      win_border       = { '╭', '─', '╮', '│', '╯', '─', '╰', '│' },
      window_on_create = function()         -- nvim window options override
        vim.cmd("set winhl=Normal:Normal")  -- popup bg match normal windows
      end,
    },
    -- fzf_bin             = 'sk',        -- use skim instead of fzf?
    fzf_layout          = 'reverse',      -- fzf '--layout='
    fzf_args            = '',             -- adv: fzf extra args, empty unless adv
    fzf_binds           = {               -- fzf '--bind=' options
        'f2:toggle-preview',
        'f3:toggle-preview-wrap',
        'shift-down:preview-page-down',
        'shift-up:preview-page-up',
        'ctrl-d:half-page-down',
        'ctrl-u:half-page-up',
        'ctrl-f:page-down',
        'ctrl-b:page-up',
        'ctrl-a:toggle-all',
        'ctrl-l:clear-query',
    },
    preview_border      = 'border',       -- border|noborder
    preview_wrap        = 'nowrap',       -- wrap|nowrap
    preview_opts        = 'nohidden',     -- hidden|nohidden
    preview_vertical    = 'down:45%',     -- up|down:size
    preview_horizontal  = 'right:60%',    -- right|left:size
    preview_layout      = 'flex',         -- horizontal|vertical|flex
    flip_columns        = 120,            -- #cols to switch to horizontal on flex
    -- default_previewer   = "bat",       -- override the default previewer?
                                          -- by default auto-detect bat|cat
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
    },
    -- provider setup
    files = {
      -- previewer         = "cat",       -- uncomment to override previewer
      prompt            = 'Files❯ ',
      cmd               = '',             -- "find . -type f -printf '%P\n'",
      git_icons         = true,           -- show git icons?
      file_icons        = true,           -- show file icons?
      color_icons       = true,           -- colorize file|git icons
      actions = {
        ["default"]     = actions.file_edit,
        ["ctrl-s"]      = actions.file_split,
        ["ctrl-v"]      = actions.file_vsplit,
        ["ctrl-t"]      = actions.file_tabedit,
        ["ctrl-q"]      = actions.file_sel_to_qf,
        ["ctrl-y"]      = function(selected) print(selected[2]) end,
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
        cmd           = "git log --pretty=oneline --abbrev-commit --color",
        preview       = "git show --pretty='%Cred%H%n%Cblue%an%n%Cgreen%s' --color {1}",
        actions = {
          ["default"] = nil,
        },
      },
      bcommits = {
        prompt        = 'BCommits❯ ',
        cmd           = "git log --pretty=oneline --abbrev-commit --color --",
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
      actions = {
        ["default"]     = actions.file_edit,
        ["ctrl-s"]      = actions.file_split,
        ["ctrl-v"]      = actions.file_vsplit,
        ["ctrl-t"]      = actions.file_tabedit,
        ["ctrl-q"]      = actions.file_sel_to_qf,
        ["ctrl-y"]      = function(selected) print(selected[2]) end,
      }
    },
    oldfiles = {
      prompt            = 'History❯ ',
      cwd_only          = false,
    },
    buffers = {
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
        window_on_create  = function()
          vim.cmd("set winhl=Normal:Normal")
        end,
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
    -- placeholders for additional user customizations
    loclist = {},
    helptags = {},
    manpages = {},
    -- optional override of file extension icon colors
    -- available colors (terminal):
    --    clear, bold, black, red, green, yellow
    --    blue, magenta, cyan, grey, dark_grey, white
    file_icon_colors = {
      ["lua"]   = "blue",
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
          vim.cmd("set winhl=Normal:Normal,FloatBorder:VertSplit")
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
