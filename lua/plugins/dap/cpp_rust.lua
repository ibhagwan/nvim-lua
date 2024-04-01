local res, dap = pcall(require, "dap")
if not res then
  return
end

dap.adapters.gdb = {
  type = "executable",
  command = "gdb",
  args = { "-i", "dap" }
}

-- https://github.com/mfussenegger/nvim-dap/wiki/Debug-Adapter-installation#ccrust-via-lldb-vscode
dap.adapters.lldb = {
  type = "executable",
  command = "/usr/bin/lldb-vscode",
  name = "lldb"
}

local build_env = function()
  local variables = {}
  for k, v in pairs(vim.fn.environ()) do
    table.insert(variables, string.format("%s=%s", k, v))
  end
  return variables
end

local rustInitCommands = function()
  -- Find out where to look for the pretty printer Python module
  local rustc_sysroot = vim.fn.trim(vim.fn.system("rustc --print sysroot"))
  local script_import = 'command script import "' ..
      rustc_sysroot .. '/lib/rustlib/etc/lldb_lookup.py"'
  local commands_file = rustc_sysroot .. "/lib/rustlib/etc/lldb_commands"

  local commands = {}
  local file = io.open(commands_file, "r")
  if file then
    for line in file:lines() do
      table.insert(commands, line)
    end
    file:close()
  end
  table.insert(commands, 1, script_import)

  return commands
end

dap.configurations.c = {
  {
    name = "[LLDB] Launch Executable",
    type = "lldb",
    request = "launch",
    program = require("utils").dap_pick_exec,
    cwd = "${workspaceFolder}",
    stopOnEntry = false,
    args = {},
  },
  {
    name = "[LLDB] Attach to process",
    type = "lldb",
    request = "attach",
    pid = require("utils").dap_pick_process,
    args = {},
  },
  {
    name = "[GDB] Launch",
    type = "gdb",
    request = "launch",
    program = require("utils").dap_pick_exec,
    -- program = function()
    --   local bin
    --   vim.ui.input({ prompt = "Path to executable: " },
    --     function(input)
    --       bin = vim.fn.expand(input)
    --     end)
    --   if type(bin) == "string" and vim.loop.fs_stat(bin) then
    --     return bin
    --   else
    --     -- ctrl-c'ing `vin.ui.input` returns "v:null"
    --     if bin ~= "v:null" and bin ~= "" then
    --       require("utils").warn(string.format("'%s' is not executable, aborting.", bin))
    --     end
    --     return dap.ABORT
    --   end
    -- end,
    cwd = "${workspaceFolder}",
    stopAtBeginningOfMainSubprogram = true,
  },
  {
    name = "[GDB] Attach to process",
    type = "gdb",
    request = "attach",
    pid = require("utils").dap_pick_process,
    args = {},
  },
}

dap.configurations.cpp = dap.configurations.c
dap.configurations.rust = vim.deepcopy(dap.configurations.c)

dap.configurations.rust[1] = vim.tbl_extend("force", dap.configurations.rust[1], {
  env = build_env,
  initCommands = rustInitCommands,
})

dap.configurations.rust[2] = vim.tbl_extend("force", dap.configurations.rust[2], {
  env = build_env,
  initCommands = rustInitCommands,
})
