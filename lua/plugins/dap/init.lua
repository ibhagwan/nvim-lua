local M = {
  "mfussenegger/nvim-dap",
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

local utils = require "utils"
local BP_DB_PATH = vim.fn.stdpath("data") .. "/dap_bps.json"

M._load_bps = function()
  local fp = io.open(BP_DB_PATH, "r")
  if not fp then
    utils.info("No breakpoint json-db present.")
    return
  end
  local json = fp:read("*a")
  local ok, bps = pcall(vim.json.decode, json)
  if not ok or type(bps) ~= "table" then
    utils.warn(string.format("Error parsing breakpoint json-db: %s", bps))
    return
  end
  local path2bufnr = {}
  for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
    local path = vim.api.nvim_buf_get_name(bufnr)
    if type(bps[path]) == "table" and not vim.tbl_isempty(bps[path]) then
      path2bufnr[path] = bufnr
    end
  end
  -- no breakpoints in current buflist
  if vim.tbl_isempty(path2bufnr) then return end
  local bp_count = 0
  for path, buf_bps in pairs(bps) do
    local bufnr = tonumber(path2bufnr[path])
    if bufnr then
      for _, bp in pairs(buf_bps) do
        bp_count = bp_count + 1
        local line = bp.line
        local opts = {
          condition = bp.condition,
          log_message = bp.logMessage,
          hit_condition = bp.hitCondition,
        }
        require("dap.breakpoints").set(opts, bufnr, line)
      end
    end
  end
  -- Load bps into active session (not just the UI)
  local session = require("dap").session()
  if session and bp_count > 0 then
    session:set_breakpoints(require("dap.breakpoints").get())
  end
  utils.info(string.format("Loaded %d breakpoints in %d bufers.",
    bp_count, vim.tbl_count(path2bufnr)))
end

M._store_bps = function()
  local fp = io.open(BP_DB_PATH, "r")
  local json = fp and fp:read("*a") or "{}"
  local ok, bps = pcall(vim.json.decode, json)
  if not ok or type(bps) ~= "table" then
    bps = {}
  end
  local bp_count = 0
  local breakpoints_by_buf = require("dap.breakpoints").get()
  for bufnr, buf_bps in pairs(breakpoints_by_buf) do
    bp_count = bp_count + #buf_bps
    bps[vim.api.nvim_buf_get_name(bufnr)] = buf_bps
  end
  -- If buffer has no breakpoints, remove from the db
  for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
    if not breakpoints_by_buf[bufnr] then
      local path = vim.api.nvim_buf_get_name(bufnr)
      bps[path] = nil
    end
  end
  fp = io.open(BP_DB_PATH, "w")
  if fp then
    fp:write(vim.json.encode(bps))
    fp:close()
    utils.info(string.format("Stored %d breakpoints in %d bufers.",
      bp_count, vim.tbl_count(breakpoints_by_buf)))
  end
end

M.init = function()
  vim.keymap.set({ "n", "v" },
    "<F5>",
    function() require "dap".continue() end,
    { silent = true, desc = "DAP launch or continue" })
  vim.keymap.set({ "n", "v" },
    -- `<S-F5>`, test by pressing `<C-v><S-F5>` in INSERT mode
    "<F17>",
    function() require "osv".launch({ port = 8086 }) end,
    { silent = true, desc = "Start OSV Lua Debug Server" })
  vim.keymap.set({ "n", "v" },
    "<F8>",
    function()
      -- lazy load nvim-dap so `dapui.setup()` is called
      require "dap"; require "plugins.dap.ui".toggle()
    end,
    { silent = true, desc = "DAP toggle UI" })
  vim.keymap.set({ "n", "v" },
    -- Test by pressing `<C-v><S-F8>` in INSERT mode
    -- "<F20>",
    "<S-F8>",
    function()
      require "dap"; require "plugins.dap.ui".toggle(true, true)
    end,
    { silent = true, desc = "DAP toggle UI" })
  vim.keymap.set({ "n", "v" },
    "<F9>",
    function() require "dap".toggle_breakpoint() end,
    { silent = true, desc = "DAP toggle breakpoint" })
  vim.keymap.set({ "n", "v" },
    "<F10>",
    function() require "dap".step_over() end,
    { silent = true, desc = "DAP step over" })
  vim.keymap.set({ "n", "v" },
    "<F11>",
    function() require "dap".step_into() end,
    { silent = true, desc = "DAP step into" })
  vim.keymap.set({ "n", "v" },
    "<F12>",
    function() require "dap".step_out() end,
    { silent = true, desc = "DAP step out" })
  vim.keymap.set({ "n", "v" },
    "<F6>",
    function() require "dap".terminate() end,
    { silent = true, desc = "DAP Terminate" })
  vim.keymap.set({ "n", "v" },
    "<leader>dt",
    function() require "dap".terminate() end,
    { silent = true, desc = "DAP terminate" })

  -- Conditional breakpoints
  vim.keymap.set({ "n", "v" },
    "<leader>dc",
    function() require "dap".set_breakpoint(utils.input("Breakpoint condition: ")) end,
    { silent = true, desc = "DAP: set breakpoint with condition" })
  vim.keymap.set({ "n", "v" },
    "<leader>dl",
    function() require "dap".set_breakpoint(nil, nil, utils.input("Log point message: ")) end,
    { silent = true, desc = "DAP: set breakpoint with log point message" })

  -- Load/Store breakpoint in a json-db
  vim.keymap.set({ "n", "v" },
    "<leader>d-",
    M._load_bps,
    { silent = true, desc = "DAP load breakpoints" })
  vim.keymap.set({ "n", "v" },
    "<leader>d+",
    M._store_bps,
    { silent = true, desc = "DAP store breakpoints" })

  vim.keymap.set({ "n", "v" },
    "<leader>dr",
    function() require "dap".repl.toggle() end,
    { silent = true, desc = "DAP toggle debugger REPL" })

  -- DAP-UI widgets
  vim.keymap.set({ "n", "v" },
    "<Leader>dk",
    function() require("dap.ui.widgets").hover() end,
    { silent = true, desc = "DAP Hover" })
  vim.keymap.set({ "n", "v" },
    "<Leader>dp",
    function() require("dap.ui.widgets").preview() end,
    { silent = true, desc = "DAP Preview" })
  vim.keymap.set({ "n", "v" },
    "<Leader>df",
    function()
      local widgets = require("dap.ui.widgets")
      widgets.centered_float(widgets.frames)
    end,
    { silent = true, desc = "DAP Frames" })
  vim.keymap.set({ "n", "v" },
    "<Leader>ds",
    function()
      local widgets = require("dap.ui.widgets")
      widgets.centered_float(widgets.scopes)
    end,
    { silent = true, desc = "DAP Scopes" })

  -- fzf-lua
  vim.keymap.set({ "n", "v" },
    "<leader>d?",
    function() require "fzf-lua".dap_commands() end,
    { silent = true, desc = "DAP: fzf nvim-dap builtin commands" })
  vim.keymap.set({ "n", "v" },
    "<leader>db",
    function() require "fzf-lua".dap_breakpoints() end,
    { silent = true, desc = "DAP: fzf breakpoint list" })
  vim.keymap.set({ "n", "v" },
    "<leader>dF",
    function() require "fzf-lua".dap_frames() end,
    { silent = true, desc = "DAP: fzf frames" })
  vim.keymap.set({ "n", "v" },
    "<leader>dv",
    function() require "fzf-lua".dap_variables() end,
    { silent = true, desc = "DAP: fzf variables" })
  vim.keymap.set({ "n", "v" },
    "<leader>dx",
    function() require "fzf-lua".dap_configurations() end,
    { silent = true, desc = "DAP: fzf debugger configurations" }
  )
end


M.config = function()
  local dap = require "dap"

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

  -- Override the json decoder so we can support jsonc (comments, trailing commas)
  require("dap.ext.vscode").json_decode = require("lib.jsonc").decode

  -- Load configurations from `.launch.json`
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
  require("dap.ext.vscode").load_launchjs(".launch.jsonc", {
    go     = { "go" },
    python = { "py" },
    gdb    = { "c", "cpp", "rust" },
    lldb   = { "c", "cpp", "rust" },
    cppdbg = { "c", "cpp", "rust" },
  })

  -- Controls how stepping switches buffers
  dap.defaults.fallback.switchbuf = "useopen,uselast"

  -- Which terminal should be launched when `externalConsole = true`
  dap.defaults.fallback.external_terminal = {
    command = "/usr/bin/alacritty",
    args = { "-e" },
  }

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
