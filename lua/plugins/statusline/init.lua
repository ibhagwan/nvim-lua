local res, statusline = pcall(require, "el")
if not res then
  return
end

local builtin = require "el.builtin"
local sections = require "el.sections"
local c = require "plugins.statusline.components"

local function setup()

  statusline.setup {
    regenerate_autocmds = { 'WinEnter', 'WinLeave' },
    generator = function(window, buffer)
      local is_inactive = vim.o.laststatus ~= 3 and
        window.win_id ~= vim.api.nvim_get_current_win()

      if not is_inactive then
        for _, ft in ipairs({
          'fzf',
          'packer',
          'NvimTree',
          'fugitive',
          'fugitiveblame',
        }) do
          if vim.bo[buffer.bufnr].ft == ft then
            is_inactive = true
          end
        end
      end

      local hl_red = 'ErrorMsg'
      local hl_green = 'diffAdded'
      local hl_yellow = 'WarningMsg'
      local hl_magenta = 'WarningMsg'
      local hl_statusline = 'StatusLine'
      if vim.g.colors_name == "nightfly" then
        hl_green = 'NightflyTurquoise'
        hl_yellow = 'NightflyYellow'
        hl_magenta = 'NightflyViolet'
        -- hl_statusline = 'DiffText'
        -- vim.cmd("hi clear StatusLine")
        -- vim.cmd("hi! link StatusLine " .. hl_statusline)
      end

      local highlights = {
        red_fg = c.extract_hl({
          bg = { [hl_statusline]  = 'bg' },
          fg = { [hl_red]         = 'fg' },
          gui = "bold",
        }),
        green_fg = c.extract_hl({
          bg = { [hl_statusline]  = 'bg' },
          fg = { [hl_green]       = 'fg' },
          gui = "bold",
        }),
        yellow_fg = c.extract_hl({
          bg = { [hl_statusline]  = 'bg' },
          fg = { [hl_yellow]      = 'fg' },
          gui = "bold",
        }),
        magenta_fg = c.extract_hl({
          bg = { [hl_statusline]   = 'bg' },
          fg = { [hl_magenta]      = 'fg' },
          -- fg = { MatchParen   = 'fg' },
          gui = "bold",
        }),
      }

      local modes = {
        n      = {'Normal', 'N',   },
        niI    = {'Normal', 'N',   },
        niR    = {'Normal', 'N',   },
        niV    = {'Normal', 'N',   },
        no     = {'N·OpPd', '?',   },
        v      = {'Visual', 'V',   { 'Directory' } },
        V      = {'V·Line', 'Vl',  { 'Directory' } },
        [''] = {'V·Blck', 'Vb',  { 'Directory' } },
        s      = {'Select', 'S',   { 'Search' } },
        S      = {'S·Line', 'Sl',  { 'Search' } },
        [''] = {'S·Block', 'Sb', { 'Search' } },
        i      = {'Insert', 'I',   { 'ErrorMsg' } },
        ic     = {'ICompl', 'Ic',  { 'ErrorMsg' } },
        R      = {'Rplace', 'R',   { 'WarningMsg', 'IncSearch' } },
        Rv     = {'VRplce', 'Rv',  { 'WarningMsg', 'IncSearch' } },
        c      = {'Cmmand', 'C',   { 'diffAdded', 'DiffAdd' } },
        cv     = {'Vim Ex', 'E',   },
        ce     = {'Ex (r)', 'E',   },
        r      = {'Prompt', 'P',   },
        rm     = {'More  ', 'M',   },
        ['r?'] = {'Cnfirm', 'Cn',  },
        ['!']  = {'Shell ', 'S',   { 'DiffAdd', 'diffAdded' } },
        t      = {'Term  ', 'T',   { 'DiffAdd', 'diffAdded' } },
      }

      local components = {
        { c.mode { modes = modes, fmt = " %s %s ", icon = "", hl_icon_only = false } },
        { c.git_branch { fmt = " %s %s ", icon = "", hl = highlights.magenta_fg } },
        { sections.split, required = true },
        { c.file_icon { fmt = "%s ", hl_icon = false } },
        { sections.maximum_width(builtin.make_responsive_file(140, 90), 0.40) , required = true },
        { sections.collapse_builtin { { " " }, { builtin.modified_flag } } },
        { sections.split, required = true },
        { c.diagnostics {
            fmt = "[%s]", lsp = true,
            hl_err  = highlights.red_fg,
            hl_warn = highlights.yellow_fg,
            hl_info = highlights.green_fg,
            hl_hint = highlights.magenta_fg,
            -- icon_err = ' ', icon_warn = ' ', icon_info = '', icon_hint = ''
          }
        },
        { c.git_changes_buf {
            fmt = "[%s]",
            icon_insert = '+',
            icon_change = '~',
            icon_delete = '-',
            hl_insert = highlights.green_fg,
            hl_change = highlights.yellow_fg,
            hl_delete = highlights.red_fg,
          }
        },
        { "[" },
        { builtin.line_with_width(3) },
        { ":" },
        { builtin.column_with_width(2) },
        { "]" },
        {
          sections.collapse_builtin {
            "[",
            builtin.help_list,
            builtin.readonly_list,
            "]",
          },
        },
        -- { "[" },
        -- { builtin.percentage_through_window },
        -- { "]" },
        { builtin.filetype },
      }

      local add_item = function(result, item)
        if is_inactive and not item.required then
          return
        end

        table.insert(result, item)
      end

      local result = {}
      for _, item in ipairs(components) do
        add_item(result, item)
      end

      return result
    end,
  }
end

-- run at least once
setup()

return {
  setup = setup
}
