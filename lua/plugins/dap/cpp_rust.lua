local res, dap = pcall(require, "dap")
if not res then
  return
end

local utils = require("utils")

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

-- https://github.com/mfussenegger/nvim-dap/wiki/C-C---Rust-(gdb-via--vscode-cpptools)
dap.adapters.cppdbg = {
  id = "cppdbg",
  type = "executable",
  command = vim.fn.stdpath("data") .. "/mason/bin/OpenDebugAD7",
}

dap.configurations.c = {
  {
    name = "[CPPDBG] Launch Executable",
    type = "cppdbg",
    request = "launch",
    program = utils.dap_pick_exec,
    cwd = "${workspaceFolder}",
    stopAtEntry = false,
  },
  {
    name = "[CPPDBG] Launch Executable (External console)",
    type = "cppdbg",
    request = "launch",
    program = utils.dap_pick_exec,
    cwd = "${workspaceFolder}",
    stopAtEntry = false,
    externalConsole = true,
  },
  {
    name = "[CPPDBG] Attach to process",
    type = "cppdbg",
    request = "attach",
    program = utils.dap_pick_exec,
    processId = utils.dap_pick_process,
    args = {},
  },
  {
    name = "[CPPDBG] Launch Neovim (Development build)",
    type = "cppdbg",
    request = "launch",
    program = function()
      local nvim_bin = vim.fn.expand("$HOME/Sources/nvim/neovim/build/bin/nvim")
      if not vim.loop.fs_stat(nvim_bin) then
        utils.warn(string.format("'%s' is not executable, aborting.", nvim_bin))
        return dap.ABORT
      end
      -- The idea for the below is taken from:
      -- https://zignar.net/2023/02/17/debugging-neovim-with-neovim-and-nvim-dap/
      -- Neovim sepaprated the TUI from the main process, launching neovim in fact
      -- spawns another process `nvim --embed`, if we want to debug nvim itself we
      -- need to attach to the subprocess, we can do so by adding a oneshot listener
      local key = "nvim-debug-subprocess"
      dap.listeners.after.initialize[key] = function(session)
        -- This is a oneshot listener, clear immediately
        dap.listeners.after.initialize[key] = nil
        -- Ensure our listeners are cleaned up after close
        session.on_close[key] = function()
          for _, handler in pairs(dap.listeners.after) do
            handler[key] = nil
          end
        end
      end
      -- Listen to event `process` to get the pid
      dap.listeners.after.event_process[key] = function(_, body)
        dap.listeners.after.event_process[key] = nil
        -- Wait for the child pid for 1 second and if valid launch 2nd "attach" session
        -- this event also gets called a second time for the child process but the pid
        -- will be nil the second time and will therefore do nothing
        local ppid = body.systemProcessId
        utils.info(string.format("Launched nvim process (ppid=%s)", ppid))
        vim.wait(1000, function()
          return tonumber(vim.fn.system("ps -o pid= --ppid " .. tostring(ppid))) ~= nil
        end)
        local pid = tonumber(vim.fn.system("ps -o pid= --ppid " .. tostring(ppid)))
        utils.info(
          string.format("Attaching to nvim (ppid=%s) child process (pid=%s)", ppid, pid))
        if pid then
          dap.run({
            name = "Neovim embedded",
            type = "cppdbg",
            request = "attach",
            processId = pid,
            program = vim.fn.expand("$HOME/Sources/nvim/neovim/build/bin/nvim"),
            cwd = "${workspaceFolder}",
            externalConsole = false,
          })
        end
      end
      return nvim_bin
    end,
    environment = function()
      -- https://code.visualstudio.com/docs/cpp/launch-json-reference
      return {
        -- Neovim needs it's source directory `runtimepath`
        { name = "VIMRUNTIME", value = vim.fn.expand("$HOME/Sources/nvim/neovim/runtime") }
      }
    end,
    cwd = "${workspaceFolder}",
    stopAtEntry = false,
    externalConsole = true,
  },
  {
    name = "[CPPDBG] Attach to Neovim (Development build)",
    type = "cppdbg",
    request = "attach",
    program = function()
      local nvim_bin = vim.fn.expand("$HOME/Sources/nvim/neovim/build/bin/nvim")
      if not vim.loop.fs_stat(nvim_bin) then
        utils.warn(string.format("'%s' is not executable, aborting.", nvim_bin))
        return dap.ABORT
      end
      return nvim_bin
    end,
    processId = function()
      -- attach to the `nvim --embed` process
      return utils.dap_pick_process(
        { winopts = { height = 0.30 } },
        { filter = function(proc) return proc.name:match("nvim.*%-%-embed") end })
    end,
    cwd = "${workspaceFolder}",
    stopAtEntry = false,
  },
  {
    name = "[LLDB] Launch Executable",
    type = "lldb",
    request = "launch",
    program = utils.dap_pick_exec,
    cwd = "${workspaceFolder}",
    stopOnEntry = false,
    args = {},
  },
  {
    name = "[LLDB] Attach to process",
    type = "lldb",
    request = "attach",
    pid = utils.dap_pick_process,
    args = {},
  },
  {
    name = "[GDB] Launch Executable",
    type = "gdb",
    request = "launch",
    program = utils.dap_pick_exec,
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
    --       utils.warn(string.format("'%s' is not executable, aborting.", bin))
    --     end
    --     return dap.ABORT
    --   end
    -- end,
    cwd = "${workspaceFolder}",
    stopAtBeginningOfMainSubprogram = false,
  },
  {
    name = "[GDB] Attach to process",
    type = "gdb",
    request = "attach",
    pid = utils.dap_pick_process,
    args = {},
  },
}

dap.configurations.cpp = dap.configurations.c
dap.configurations.rust = vim.deepcopy(dap.configurations.c)

-- https://github.com/mfussenegger/nvim-dap/wiki/Debug-Adapter-installation#ccrust-via-lldb-vscode
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

for i, c in ipairs(dap.configurations.rust) do
  if c.type == "lldb" then
    dap.configurations.rust[i] = vim.tbl_extend("force", dap.configurations.rust[i], {
      env = build_env,
      initCommands = rustInitCommands,
    })
  end
end
