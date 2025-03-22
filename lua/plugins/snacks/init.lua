local M = {
  "folke/snacks.nvim",
  enabled = true,
  event = "VeryLazy",
}

function M.init()
  require("plugins.snacks.mappings").map()
end

function M.config()
  local layouts = require("snacks.picker.config.layouts")
  for _, k in ipairs({ "default", "vertical" }) do
    layouts[k].layout.width = 0.8
    layouts[k].layout.height = 0.85
  end
  -- layouts.default.layout[1].width = 0.40    -- main win width
  -- layouts.vertical.layout[3].height = 0.45  -- prev win height
  require("snacks").setup({
    ---@type snacks.image.Config
    image = {
      enabled = true,
    },
    ---@type snacks.picker.Config
    picker = {
      ui_select = false,
      -- layout = { preset = "ivy" },
      layout = { preset = function() return vim.o.columns >= 140 and "default" or "vertical" end },
      ---@class snacks.picker.previewers.Config
      previewers = {
        git = { native = true },
      },
      win = {
        input = {
          keys = {
            -- ["<C-y>"] = { function() print("test") end, mode = { "i", "n" } },
            ["<c-d>"] = false,
            ["<c-u>"] = false,
            ["<C-c>"] = { "close", mode = { "i", "n" } },
            ["<c-b>"] = { "list_scroll_up", mode = { "i", "n" } },
            ["<c-f>"] = { "list_scroll_down", mode = { "i", "n" } },
            ["<c-p>"] = { "history_back", mode = { "i", "n" } },
            ["<c-n>"] = { "history_forward", mode = { "i", "n" } },
            ["<s-up>"] = { "preview_scroll_up", mode = { "i", "n" } },
            ["<s-down>"] = { "preview_scroll_down", mode = { "i", "n" } },
            ["<F1>"] = { "toggle_help", mode = { "i", "n" } },
            ["<F2>"] = { "toggle_maximize", mode = { "i", "n" } },
            ["<F4>"] = { "toggle_preview", mode = { "i", "n" } },
          }
        }
      }
    }
  })
end

return M
