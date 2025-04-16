local section_mode = function(opts)
  -- Mode section hacked with faux "snippet mode"
  local mode, mode_hl = MiniStatusline.section_mode({ trunc_width = opts.trunc_width })
  if vim.snippet.active() then
    mode = MiniStatusline.is_truncated(opts.trunc_width) and "S" or "SNIPPET"
    mode_hl = "WildMenu"
  end
  mode = "%(" .. string.upper(mode) .. " %)"
  return mode, mode_hl
end

local section_diff = function(args)
  if MiniStatusline.is_truncated(args.trunc_width) then return "" end
  local summary = vim.b.minidiff_summary_string or vim.b.gitsigns_status
  return summary or ""
end

local section_fileicon = function(args)
  if MiniStatusline.is_truncated(args.trunc_width) then return "" end
  local fileinfo = MiniStatusline.section_fileinfo({})
  -- If icon was added it would be a multibyte char in the first index
  -- in which case string.len would be greater than the number of chars
  local diff = string.len(fileinfo) - vim.fn.strchars(fileinfo)
  return diff == 0 and "" or string.sub(MiniStatusline.section_fileinfo({}), 1, diff + 1)
end

local section_fileinfo = function(args)
  if MiniStatusline.is_truncated(args.trunc_width) then return "" end
  local fileinfo = MiniStatusline.section_fileinfo({})
  -- If icon was added it would be a multibyte char in the first index
  -- in which case string.len would be greater than the number of chars
  local diff = string.len(fileinfo) - vim.fn.strchars(fileinfo)
  return diff == 0 and fileinfo or string.sub(fileinfo, diff + 2)
end

local section_lsp = function(args)
  if MiniStatusline.is_truncated(args.trunc_width) then return "" end
  local names = {}
  for _, server in pairs(require("utils").lsp_get_clients({ bufnr = 0 }) or {}) do
    table.insert(names, server.name)
  end
  return table.concat(names, " ")
end

local section_diagnostics = function(args)
  if MiniStatusline.is_truncated(args.trunc_width) then return "" end
  local diags = {
    { "E", #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR }) },
    { "W", #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN }) },
    { "H", #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT }) },
    { "I", #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO }) },
  }
  local ret = {}
  for _, info in ipairs(diags) do
    if info[2] > 0 and (not args.severity or args.severity == info[1]) then
      table.insert(ret, string.format("%s:%d", info[1], info[2]))
    end
  end
  return table.concat(ret, " ")
end

local active_content = function()
  local mode, mode_hl = section_mode({ trunc_width = 40 })
  local git           = MiniStatusline.section_git({ trunc_width = 40 })
  local diff          = section_diff({ trunc_width = 75, icon = "" })
  local fileicon      = section_fileicon({ trunc_width = 75 })
  local fileinfo      = section_fileinfo({ trunc_width = 140 })
  local filename      = MiniStatusline.section_filename({ trunc_width = 140 })
  local lsp           = section_lsp({ trunc_width = 75 })
  -- local diagnostics   = MiniStatusline.section_diagnostics({ trunc_width = 75 })
  local diag_e        = section_diagnostics({ trunc_width = 75, severity = "E" })
  local diag_w        = section_diagnostics({ trunc_width = 75, severity = "W" })
  local diag_h        = section_diagnostics({ trunc_width = 75, severity = "H" })
  local diag_i        = section_diagnostics({ trunc_width = 75, severity = "I" })
  local location      = MiniStatusline.section_location({ trunc_width = 75 })
  local search        = MiniStatusline.section_searchcount({ trunc_width = 75 })


  return MiniStatusline.combine_groups({
    { hl = mode_hl,                     strings = { mode } },
    { hl = "MiniStatuslineDevinfo",     strings = { git } },
    { hl = "DiffAdd",                   strings = { diff } },
    { hl = "MiniStatuslineFilename",    strings = { "%=" } }, -- Right align
    { hl = "MiniStatuslineFilename",    strings = { fileicon, filename } },
    { hl = "MiniStatuslineFilename",    strings = { "%=" } }, -- Left align
    { hl = "MiniStatuslineFileinfo",    strings = { fileinfo } },
    { hl = "MiniStatusLineModeOther",   strings = { lsp } },
    -- { hl = "MiniStatusLineModeReplace", strings = { diagnostics } },
    { hl = "MiniStatusLineModeReplace", strings = { diag_e } },
    { hl = "MiniStatusLineModeCommand", strings = { diag_w } },
    { hl = "MiniStatusLineModeVisual",  strings = { diag_h } },
    { hl = "MiniStatusLineModeInsert",  strings = { diag_i } },
    { hl = "MiniStatusLineModeVisual",  strings = { search } },
    { hl = mode_hl,                     strings = { location } },
  })
end

local inactive_content = function()
  local filename = MiniStatusline.section_filename({ trunc_width = 140 })
  return MiniStatusline.combine_groups({
    { hl = "MiniStatuslineFilename", strings = { "%=" } }, -- Right align
    { hl = "MiniStatuslineFilename", strings = { filename } },
    { hl = "MiniStatuslineFilename", strings = { "%=" } }, -- Left align
  })
end

return {
  setup = function()
    require("mini.statusline").setup({
      content = {
        active = active_content,
        inactive = inactive_content,
      },
    })
  end
}
