local res, statusline = pcall(require, "lualine")
if not res then
  return
end

local col_from_hl = require("lualine.utils.utils").extract_color_from_hllist

local import_hls = {
    ['String']      = 'fg',
    ['Special']     = 'fg',
    ['Type']        = 'fg',
    ['Label']       = 'fg',
    ['PreProc']     = 'fg',
    ['Search']      = 'fg',
    ['Identifier']  = 'fg',
    ['Keyword']     = 'fg',
    ['DiffAdd']     = 'bg',
    ['DiffDelete']  = 'bg',
    ['DiffChange']  = 'fg',
    ['DiffText']    = 'bg',
    ['IncSearch']   = 'fg',
    ['ErrorMsg']    = 'fg',
    ['WildMenu']    = 'bg',
}

local colors = {
    bg = col_from_hl('bg', { 'StatusLine',  }, '#000000'),
    fg = col_from_hl('fg', { 'Normal', 'StatusLine' }, '#000000'),
}

for hl, col in pairs(import_hls) do
  colors[hl] = col_from_hl(col, { hl,  }, '#000000')
end

local filename = {
  {
    'filetype',
    icon_only = true,
  },
  {
    'filename',
    path = 1,             -- relative path
    shorting_target = 80, -- shorten long paths
    file_status = true,   -- show modified/readonly
    symbols = { modified = '[+]', readonly = '[-]' },
    -- symbols = { modified = ' ', readonly = ' ' },
  },
}

local function lsp_name()
  local buf_ft = vim.api.nvim_buf_get_option(0, 'filetype')
  local clients = vim.lsp.get_active_clients()
  if next(clients) == nil then
    return nil
  end
  for _, client in ipairs(clients) do
    local filetypes = client.config.filetypes
    if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
      return client.name
    end
  end
  return nil
end

local lsp_tbl = {
  function()
    return lsp_name()
  end,
  cond = function()
    return lsp_name() ~= nil
  end,
  -- icon = ' ',
  icon = '慎',
  color = { fg = colors.bg, bg = colors.IncSearch },
}

statusline.setup({
  options = {
    component_separators = {left='', right=''},
    section_separators = {left='', right=''},
    disabled_filetypes = {
      'packer',
      'NvimTree',
      'fugitive',
      'fugitiveblame',
    }
  },
  sections = {
    -- lualine_a = {{'mode'}},
    lualine_a = {{'mode', fmt = function(str) return ' ' .. str end}},
    lualine_b = {
      -- {'branch', icon = '', color = { fg = colors.Label, gui = 'bold' }},
      {'branch', icon = ''},
      {'diff',
        symbols = { added = ' ', modified = '柳', removed = ' ' },
        diff_color = {
          added = { fg = colors.DiffAdd },
          modified = { fg = colors.DiffChange },
          removed = { fg = colors.DiffDelete },
        },
      }
    },
    lualine_c = filename,
    lualine_x = {{
      'diagnostics',
      sources = { 'nvim_lsp' },
      symbols = { error = ' ', warn = ' ', info = ' ', hint = ' ' },
      diagnostics_color = {
        error = { fg = colors.ErrorMsg },
        warn  = { fg = colors.DiffChange },
        info  = { fg = colors.WildMenu },
        hint  = { fg = colors.Identifier },
      },
      -- color = { bg = colors.String },
    }, lsp_tbl},
    lualine_y = {{'fileformat'},{'encoding'},
      -- char under cursor in hex
      {'%B', fmt = function(str) return '0x'..str end}},
    lualine_z = {{'progress'},{'location'}},
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = filename,
    lualine_x = {{'fileformat'},{'encoding'},{'progress'},{'location'}},
    lualine_y = {},
    lualine_z = {},
  },
})
