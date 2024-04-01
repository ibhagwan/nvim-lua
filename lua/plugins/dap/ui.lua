local res, dapui = pcall(require, "dapui")
if not res then
  return
end

local utils = require("utils")
local M = {}

M.setup = function()
  ---@diagnostic disable-next-line: missing-fields
  dapui.setup({
    layouts = {
      {
        position = "bottom",
        size = 0.30,
        elements = {
          { id = "repl",    size = 0.60, },
          { id = "console", size = 0.40 },
        },
      },
      {
        position = "right",
        size = 0.40,
        elements = {
          { id = "scopes",      size = 0.38, },
          { id = "watches",     size = 0.12 },
          { id = "stacks",      size = 0.32 },
          { id = "breakpoints", size = 0.18 },
        },
      },
    },
  })
  local dap = require("dap")
  dap.listeners.before.attach.dapui_config = function()
    M.open()
  end
  dap.listeners.before.launch.dapui_config = function()
    M.open()
  end
  dap.listeners.after.event_initialized.dapui_config = function()
    M.open()
  end
  dap.listeners.before.event_terminated.dapui_config = function(e)
    require("utils").info(
      string.format("program '%s' was terminated.", vim.fn.fnamemodify(e.config.program, ":t")))
  end
  -- dap.listeners.before.event_exited.dapui_config = function(e)
  --   dapui.close()
  -- end
end

M.open = function(reset, tmux_zoom)
  if not M._is_open and tmux_zoom and not M._tmux_was_unzoomed then
    M._tmux_was_unzoomed = utils.tmux_zoom()
    if M._tmux_was_unzoomed then
      vim.cmd("sleep! 20m")
    end
  end
  dapui.open({ reset = reset == nil and true or reset })
  M._is_open = true
end

M.close = function(tmux_zoom)
  dapui.close()
  if tmux_zoom and M._tmux_was_unzoomed then
    utils.tmux_unzoom()
    M._tmux_was_unzoomed = nil
  end
  M._is_open = nil
end

M.toggle = function(reset, tmux_zoom)
  if M._is_open then
    M.close(tmux_zoom)
  else
    M.open(reset, tmux_zoom)
  end
end

return M
