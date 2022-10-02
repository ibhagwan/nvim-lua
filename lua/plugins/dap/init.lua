local res, _ = pcall(require, "dap")
if not res then
  return
end

local map = vim.keymap.set

map({ 'n', 'v' }, '<F5>', "<cmd>lua require'dap'.continue()<CR>",
  { silent = true, desc = "DAP launch or continue" })
map({ 'n', 'v' }, '<F8>', "<cmd>lua require'dapui'.toggle()<CR>",
  { silent = true, desc = "DAP toggle UI" })
map({ 'n', 'v' }, '<F9>', "<cmd>lua require'dap'.toggle_breakpoint()<CR>",
  { silent = true, desc = "DAP toggle breakpoint" })
map({ 'n', 'v' }, '<F10>', "<cmd>lua require'dap'.step_over()<CR>",
  { silent = true, desc = "DAP step over" })
map({ 'n', 'v' }, '<F11>', "<cmd>lua require'dap'.step_into()<CR>",
  { silent = true, desc = "DAP step into" })
map({ 'n', 'v' }, '<F12>', "<cmd>lua require'dap'.step_out()<CR>",
  { silent = true, desc = "DAP step out" })
map({ 'n', 'v' }, '<leader>dc', "<cmd>lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>", { silent = true, desc = "set breakpoint with condition" })
map({ 'n', 'v' }, '<leader>dp', "<cmd>lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<CR>", { silent = true, desc ="set breakpoint with log point message" })
map({ 'n', 'v' }, '<leader>dr', "<cmd>lua require'dap'.repl.toggle()<CR>",
  { silent = true, desc = "toggle debugger REPL" })

-- launch fzf-lua
local function fzf_lua(cmd)
    if not pcall(require, 'fzf-lua') then
      require('packer').loader('fzf-lua')
    end
    require('fzf-lua')[cmd]()
end

map({ 'n', 'v' }, '<leader>d?', function() fzf_lua("dap_commands") end,
  { silent = true, desc = "fzf nvim-dap builtin commands" })
map({ 'n', 'v' }, '<leader>db', function() fzf_lua("dap_breakpoints") end,
  { silent = true, desc = "fzf breakpoint list" })
map({ 'n', 'v' }, '<leader>df', function() fzf_lua("dap_frames") end,
  { silent = true, desc = "fzf frames" })
map({ 'n', 'v' }, '<leader>dv', function() fzf_lua("dap_variables") end,
  { silent = true, desc = "fzf variables" })
map({ 'n', 'v' }, '<leader>dx', function() fzf_lua("dap_configurations") end,
  { silent = true, desc = "fzf debugger configurations" })

-- configure language adapaters
require "plugins.dap.go"
require "plugins.dap.lua"
