local res, _ = pcall(require, "dap")
if not res then
  return
end

local remap = require'utils'.remap

remap({ 'n', 'v' }, '<F5>', "<cmd>lua require'dap'.continue()<CR>", { silent = true })
remap({ 'n', 'v' }, '<F8>', "<cmd>lua require'dapui'.toggle()<CR>", { silent = true })
remap({ 'n', 'v' }, '<F9>', "<cmd>lua require'dap'.toggle_breakpoint()<CR>", { silent = true })
remap({ 'n', 'v' }, '<F10>', "<cmd>lua require'dap'.step_over()<CR>", { silent = true })
remap({ 'n', 'v' }, '<F11>', "<cmd>lua require'dap'.step_into()<CR>", { silent = true })
remap({ 'n', 'v' }, '<F12>', "<cmd>lua require'dap'.step_out()<CR>", { silent = true })
remap({ 'n', 'v' }, '<leader>db', "<cmd>lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>", { silent = true })
remap({ 'n', 'v' }, '<leader>dp', "<cmd>lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<CR>", { silent = true })
remap({ 'n', 'v' }, '<leader>dr', "<cmd>lua require'dap'.repl.toggle()<CR>", { silent = true })

-- launch fzf-lua
local function fzf_lua(cmd)
    if not pcall(require, 'fzf-lua') then
      require('packer').loader('fzf-lua')
    end
    require('fzf-lua')[cmd]()
end

-- remap({ 'n', 'v' }, '<leader>d?', "<cmd>lua require'fzf-lua'.dap_commands()<CR>", { silent = true })
remap({ 'n', 'v' }, '<leader>d?', function() fzf_lua("dap_commands") end,       { silent = true })
remap({ 'n', 'v' }, '<leader>db', function() fzf_lua("dap_breakpoints") end,    { silent = true })
remap({ 'n', 'v' }, '<leader>df', function() fzf_lua("dap_frames") end,         { silent = true })
remap({ 'n', 'v' }, '<leader>dv', function() fzf_lua("dap_variables") end,      { silent = true })
remap({ 'n', 'v' }, '<leader>dx', function() fzf_lua("dap_configurations") end, { silent = true })

-- configure language adapaters
require "plugins.dap.go"
require "plugins.dap.lua"
