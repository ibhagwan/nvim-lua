local fzf_lua = require("fzf-lua")

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

local img_prev_bin = vim.fn.executable("ueberzug") == 1 and { "ueberzug" }
    or vim.fn.executable("chafa") == 1 and { "chafa" }
    or vim.fn.executable("viu") == 1 and { "viu", "-b" }
    or nil

local M = {}

M.profiles = {
  fzf = {},
  fzf_native = {
    fzf_bin = "fzf",
    winopts = { preview = { default = "bat" } },
    manpages = { previewer = "man_native" },
    helptags = { previewer = "help_native" },
    tags = { previewer = "bat" },
    btags = { previewer = "bat" },
  },
  fzf_tmux = {
    fzf_bin = "fzf-tmux",
    fzf_opts = { ["--border"] = "rounded" },
    fzf_tmux_opts = { ["-p"] = "80%,90%" },
    winopts = { preview = { default = "bat", layout = "horizontal" } },
    manpages = { previewer = "man_native" },
    helptags = { previewer = "help_native" },
    tags = { previewer = "bat" },
    btags = { previewer = "bat" },
  },
  sk = {
    fzf_bin = "sk",
    fzf_opts = { ["--no-separator"] = false },
    fzf_colors = {
      ["matched_bg"] = { "bg", "Normal" },
      ["current_match_bg"] = { "bg", hl_match({ "NightflyVisual", "CursorLine" }) },
    },
  },
}

-- default profile
M.active_profile = M.profiles.fzf

M.default_opts = {
  fzf_opts = { ["--no-separator"] = "" },
  fzf_colors = {
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
    ["scrollbar"] = { "fg", hl_match({ "NightflyPeach", "WarningMsg" }) },
  },
  winopts = {
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
  winopts_fn = function()
    local hl = {
      border = hl_match({ "NightflySteelBlue", "FloatBorder" }),
      cursorline = hl_match({ "NightflyVisual" }),
      cursorlinenr = hl_match({ "NightflyVisual" }),
    }
    return { hl = hl }
  end,
  previewers = {
    bat = { theme = "Coldark-Dark", },
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
  actions = { files = {
    ["default"] = fzf_lua.actions.file_edit_or_qf,
    ["ctrl-l"]  = fzf_lua.actions.arg_add,
    ["ctrl-s"]  = fzf_lua.actions.file_split,
    ["ctrl-v"]  = fzf_lua.actions.file_vsplit,
    ["ctrl-t"]  = fzf_lua.actions.file_tabedit,
    ["ctrl-q"]  = fzf_lua.actions.file_sel_to_qf,
    ["alt-q"]   = fzf_lua.actions.file_sel_to_ll,
  } },
  buffers = { no_action_zz = true },
  files = {
    -- uncomment to override .gitignore
    -- fd_opts  = "--no-ignore --color=never --type f --hidden --follow --exclude .git",
    fzf_opts = { ["--tiebreak"] = "end" },
  },
  grep = {
    rg_glob = true,
    rg_opts = "--hidden --column --line-number --no-heading"
    .. " --color=always --smart-case -g '!.git'",
  },
  git = {
    status   = {
      cmd = "git status -su",
      winopts = {
        preview = { vertical = "down:70%", horizontal = "right:70%" }
      },
      actions = { ["ctrl-x"] = { fzf_lua.actions.git_reset, fzf_lua.actions.resume } },
      preview_pager = vim.fn.executable("delta") == 1 and "delta --width=$COLUMNS",
    },
    commits  = {
      winopts = { preview = { vertical = "down:60%", } },
      preview_pager = vim.fn.executable("delta") == 1 and "delta --width=$COLUMNS",
    },
    bcommits = {
      winopts = { preview = { vertical = "down:60%", } },
      preview_pager = vim.fn.executable("delta") == 1 and "delta --width=$COLUMNS",
    },
    branches = { winopts = {
      preview = { vertical = "down:75%", horizontal = "right:75%", }
    } },
  },
  lsp = { symbols = { path_shorten = 1 } },
  diagnostics = { file_icons = false, icon_padding = " ", path_shorten = 1 },
}

M.setup = function()
  -- custom devicons setup file to be loaded when `multiprocess = true`
  fzf_lua.config._devicons_setup = "~/.config/nvim/lua/plugins/devicons.lua"

  -- merge defaults with the active profile
  fzf_lua.setup(vim.tbl_deep_extend("keep", vim.deepcopy(M.active_profile), M.default_opts))
end

return M