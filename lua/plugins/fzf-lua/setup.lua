return {
  setup = function()
    local fzf_lua = require("fzf-lua")

    local pkg_opts = {
      sk = { bin = "sk", opts = {} },
      fzf = { opts = { ["--no-separator"] = "" } },
      -- fzf = { opts = { ["--info"] = "default" } },
    }
    -- easily switch between fzf|sk
    -- local fzf_pkg = pkg_opts.sk
    local fzf_pkg = pkg_opts.fzf

    local img_prev_bin = vim.fn.executable("ueberzug") == 1 and { "ueberzug" }
        or vim.fn.executable("chafa") == 1 and { "chafa" }
        or vim.fn.executable("viu") == 1 and { "viu", "-b" }
        or nil

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
      if binary == "sk" and vim.fn.executable(binary) == 1 then
        colors["matched_bg"] = { "bg", "Normal" }
        colors["current_match_bg"] = { "bg", hl_match({ "NightflyVisual", "CursorLine" }) }
      end
      return colors
    end

    -- custom devicons setup file to be loaded when `multiprocess = true`
    fzf_lua.config._devicons_setup = "~/.config/nvim/lua/plugins/devicons.lua"

    fzf_lua.setup {
      fzf_bin     = fzf_pkg.bin,
      fzf_opts    = fzf_pkg.opts,
      fzf_colors  = fzf_colors,
      winopts     = {
        -- split   = "belowright new",
        -- split   = "aboveleft vnew",
        height  = 0.85,
        width   = 0.80,
        row     = 0.35,
        col     = 0.55,
        -- border = { {'╭', 'IncSearch'}, {'─', 'IncSearch'},
        -- {'╮', 'IncSearch'}, '│', '╯', '─', '╰', '│' },
        preview = {
          layout       = "flex",
          flip_columns = 130,
          scrollbar    = "float",
          -- scrolloff        = '-1',
          -- scrollchars      = {'█', '░' },
        },
        -- on_create        = function()
        --   print("on_create")
        -- end,
      },
      winopts_fn  = function()
        local hl = {
          border = hl_match({ "NightflySteelBlue", "FloatBorder" }),
          cursorline = hl_match({ "NightflyVisual" }),
          cursorlinenr = hl_match({ "NightflyVisual" }),
        }
        return { hl = hl }
      end,
      previewers  = {
        bat     = { theme = "Coldark-Dark", },
        builtin = {
          ueberzug_scaler = "cover",
          extensions      = {
            ["gif"]  = img_prev_bin,
            ["png"]  = img_prev_bin,
            ["jpg"]  = img_prev_bin,
            ["jpeg"] = img_prev_bin,
            ["svg"]  = { "chafa" },
          }
        },
      },
      buffers     = { no_action_zz = true },
      files       = {
        -- uncomment to override .gitignore
        -- fd_opts  = "--no-ignore --color=never --type f --hidden --follow --exclude .git",
        fzf_opts = { ["--tiebreak"] = "end" },
        action   = { ["ctrl-l"] = fzf_lua.actions.arg_add }
      },
      grep        = {
        rg_glob = true,
        rg_opts = "--hidden --column --line-number --no-heading"
            .. " --color=always --smart-case -g '!.git'",
      },
      git         = {
        status   = {
          cmd           = "git status -su",
          winopts       = {
            preview = { vertical = "down:70%", horizontal = "right:70%" }
          },
          actions       = {
            ["ctrl-x"] = { fzf_lua.actions.git_reset, fzf_lua.actions.resume },
          },
          preview_pager = vim.fn.executable("delta") == 1 and "delta --width=$COLUMNS",
        },
        commits  = {
          winopts       = { preview = { vertical = "down:60%", } },
          preview_pager = vim.fn.executable("delta") == 1 and "delta --width=$COLUMNS",
        },
        bcommits = {
          winopts       = { preview = { vertical = "down:60%", } },
          preview_pager = vim.fn.executable("delta") == 1 and "delta --width=$COLUMNS",
        },
        branches = { winopts = {
          preview = { vertical = "down:75%", horizontal = "right:75%", }
        } },
      },
      lsp         = { symbols = { path_shorten = 1 } },
      diagnostics = { file_icons = false, icon_padding = " ", path_shorten = 1 },
    }
  end
}
