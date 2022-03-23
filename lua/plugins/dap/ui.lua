local res, dapui = pcall(require, "dapui")
if not res then
  return
end

dapui.setup({
  sidebar = {
    size = 40,
    position = "right",
    elements = {
      { id = "scopes", size = 0.46, },
      { id = "stacks", size = 0.36 },
      { id = "breakpoints", size = 0.18 },
      -- { id = "watches", size = 00.25 },
    }
  }
})

local dap = require("dap")

dap.listeners.after.event_initialized["dapui_config"] = function()
  dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
  dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
  dapui.close()
end
