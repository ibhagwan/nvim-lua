local res, dapui = pcall(require, "dapui")
if not res then
  return
end

dapui.setup({
  layouts = {
    {
      position = "bottom",
      size = 10,
      elements = {
        { id = "repl",    size = 0.50, },
        { id = "console", size = 0.50 },
      },
    },
    {
      position = "right",
      size = 40,
      elements = {
        { id = "scopes",      size = 0.46, },
        { id = "stacks",      size = 0.36 },
        { id = "breakpoints", size = 0.18 },
        -- { id = "watches", size = 00.25 },
      },
    },
  },
})

local dap = require("dap")

dap.listeners.after.event_initialized["dapui_config"] = function()
  dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function(e)
  require("utils").info(
    string.format("program '%s' was terminated.", vim.fn.fnamemodify(e.config.program, ":t")))
end
-- dap.listeners.before.event_exited["dapui_config"] = function(e)
--   dapui.close()
-- end
