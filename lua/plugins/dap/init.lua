local M = {
  "mfussenegger/nvim-dap",
  keys = { "<F5>", "<S-F5>", "<F8>", "<F9>" },
  dependencies = {
    {
      "rcarriga/nvim-dap-ui",
      dependencies = { "nvim-neotest/nvim-nio" },
    },
    { "theHamsta/nvim-dap-virtual-text" },
    { "jbyuki/one-small-step-for-vimkind" },
    { "mfussenegger/nvim-dap-python" },
  },
}

M.config = function()
  local map = vim.keymap.set
  local dap = require "dap"

  map({ "n", "v" }, "<F5>", dap.continue, { silent = true, desc = "DAP launch or continue" })
  map({ "n", "v" }, "<S-F5>", function() require "osv".launch({ port = 8086 }) end,
    { silent = true, desc = "Start OSV Lua Debug Server" })
  map({ "n", "v" }, "<F8>", require "plugins.dap.ui".toggle,
    { silent = true, desc = "DAP toggle UI" })
  map({ "n", "v" }, "<S-F8>", function() require "plugins.dap.ui".toggle(true, true) end,
    { silent = true, desc = "DAP toggle UI" })
  map({ "n", "v" }, "<F9>", require "dap".toggle_breakpoint,
    { silent = true, desc = "DAP toggle breakpoint" })
  map({ "n", "v" }, "<F10>", dap.step_over, { silent = true, desc = "DAP step over" })
  map({ "n", "v" }, "<F11>", dap.step_into, { silent = true, desc = "DAP step into" })
  map({ "n", "v" }, "<F12>", dap.step_out, { silent = true, desc = "DAP step out" })
  map({ "n", "v" }, "<F6>", dap.terminate, { silent = true, desc = "DAP Terminate" })
  map({ "n", "v" }, "<leader>dt", dap.terminate, { silent = true, desc = "terminate session" })
  map({ "n", "v" }, "<leader>dc", function()
    dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
  end, { silent = true, desc = "set breakpoint with condition" })
  map({ "n", "v" }, "<leader>dp", function()
      dap.set_breakpoint(nil, nil, vim.fn.input("Log point message: "))
    end,
    { silent = true, desc = "set breakpoint with log point message" })
  map({ "n", "v" }, "<leader>dr", dap.repl.toggle,
    { silent = true, desc = "toggle debugger REPL" })

  -- launch fzf-lua
  local function fzf_lua(cmd)
    return require("fzf-lua")[cmd]
  end

  map({ "n", "v" }, "<leader>d?", fzf_lua("dap_commands"),
    { silent = true, desc = "fzf nvim-dap builtin commands" })
  map({ "n", "v" }, "<leader>db", fzf_lua("dap_breakpoints"),
    { silent = true, desc = "fzf breakpoint list" })
  map({ "n", "v" }, "<leader>df", fzf_lua("dap_frames"),
    { silent = true, desc = "fzf frames" })
  map({ "n", "v" }, "<leader>dv", fzf_lua("dap_variables"),
    { silent = true, desc = "fzf variables" })
  map({ "n", "v" }, "<leader>dx", fzf_lua("dap_configurations"),
    { silent = true, desc = "fzf debugger configurations" })

  -- Lazy load fzf-lua to register_ui_select
  require("fzf-lua")

  -- Set logging level
  require("dap").set_log_level("DEBUG")

  -- configure dap-ui and language adapaters
  require "plugins.dap.ui".setup()
  require "plugins.dap.go"
  require "plugins.dap.lua"
  require "plugins.dap.python"
  require "plugins.dap.cpp_rust"

  -- Load configurations from `.launch.json`
  -- require("dap.ext.vscode").json_decode = require ...
  -- Example `.launch.json`:
  --   {
  --     "version": "0.2.0",
  --     "configurations": [
  --       {
  --         "type": "lldb",
  --         "request": "launch",
  --         "name": "[LLDB] Launch '${workspaceFolder}/a.out'",
  --         "program": "a.out",
  --         "cwd": "${workspaceFolder}",
  --         "stopOnEntry": false
  --       }
  --     ]
  --   }
  require("dap.ext.vscode").load_launchjs(".launch.json", {
    go     = { "go" },
    python = { "py" },
    lldb   = { "c", "cpp", "rust" },
  })

  -- links by default to DiagnosticVirtualTextXXX which linkx to Comment in nightgly
  vim.api.nvim_set_hl(0, "NvimDapVirtualText", { link = "Comment" })
  vim.api.nvim_set_hl(0, "NvimDapVirtualTextInfo", { link = "DiagnosticInfo" })
  vim.api.nvim_set_hl(0, "NvimDapVirtualTextError", { link = "DiagnosticError" })
  vim.api.nvim_set_hl(0, "NvimDapVirtualTextChanged", { link = "DiagnosticWarn" })

  -- configure nvim-dap-virtual-text
  local ok, dapvt = pcall(require, "nvim-dap-virtual-text")
  if ok and dapvt then
    dapvt.setup({
      -- "inline" is also possible with nvim-0.10, IMHO is confusing
      virt_text_pos = "eol",
    })
  end
end

return M
