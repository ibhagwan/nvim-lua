local M = {
  -- vim-surround/sandwich, lua version
  -- mini also has an indent highlighter
  "nvim-mini/mini.nvim",
  event = { "VeryLazy" }
}

function M.init()
  vim.keymap.set({ "n", "v" }, "<leader>tt",
    function() require("mini.test").run_file() end,
    { silent = true, desc = "Run tests in current file" })
  vim.keymap.set({ "n", "v" }, "<leader>tl",
    function() require("mini.test").run_at_location() end,
    { silent = true, desc = "Run test at cursor" })
  vim.keymap.set({ "n", "v" }, "<leader>ta",
    function() require("mini.test").run() end,
    { silent = true, desc = "Run all tests" })
end

function M.config()
  require("plugins.mini.surround")
  require("plugins.mini.indentscope")
  require("plugins.mini.statusline").setup()
  require("mini.ai").setup()
  require("mini.test").setup({
    collect = {
      find_files = function()
        local test_files = vim.fn.globpath("tests", "**/*_spec.lua", true, true)
        vim.tbl_map(function(f) table.insert(test_files, f) end,
          vim.fn.globpath("tests", "**/test_*.lua", true, true))
        return test_files
      end,
    },
  })
  local miniclue = require("mini.clue")
  miniclue.setup({
    window = { delay = 500, config = { width = "auto" } },
    clues = {
      miniclue.gen_clues.builtin_completion(),
      miniclue.gen_clues.g(),
      miniclue.gen_clues.marks(),
      miniclue.gen_clues.registers(),
      miniclue.gen_clues.windows(),
      miniclue.gen_clues.z(),
      { mode = "n", keys = "<leader>g", desc = "+Git", },
      { mode = "n", keys = "<leader>G", desc = "+Git", },
      { mode = "n", keys = "<leader>y", desc = "+Git (yadm)", },
      { mode = "n", keys = "<leader>l", desc = "+Lsp", },
      { mode = "n", keys = "<leader>L", desc = "+Lsp", },
      { mode = "n", keys = "<leader>d", desc = "+Dap", },
      { mode = "n", keys = "<leader>f", desc = "+Fzf", },
      { mode = "n", keys = "<leader>F", desc = "+Snacks", },
      { mode = "n", keys = "<leader>h", desc = "+Gitsigns", },
      { mode = "n", keys = "<leader>t", desc = "+MiniTest", },
    },
    triggers = {
      -- Leader triggers
      { mode = "n", keys = "<Leader>" },
      { mode = "x", keys = "<Leader>" },
      -- Built-in completion
      { mode = "i", keys = "<C-x>" },
      -- `g` key
      { mode = "n", keys = "g" },
      { mode = "x", keys = "g" },
      -- Marks
      { mode = "n", keys = "'" },
      { mode = "n", keys = "`" },
      { mode = "x", keys = "'" },
      { mode = "x", keys = "`" },
      -- Registers
      { mode = "n", keys = '"' },
      { mode = "x", keys = '"' },
      { mode = "i", keys = "<C-r>" },
      { mode = "c", keys = "<C-r>" },
      -- Window commands
      { mode = "n", keys = "<C-w>" },
      -- `z` key
      { mode = "n", keys = "z" },
      { mode = "x", keys = "z" },
    },
  })
  vim.api.nvim_create_user_command("MiniHipatternsToggle", function()
    local hipatterns = require("mini.hipatterns")
    local hex_from_colormap = function()
      local colormap = vim.api.nvim_get_color_map()
      return function(_, match)
        match = #match > 0 and match:sub(1, 1):upper() .. match:sub(2) or match
        local col = colormap[match]
        if col == nil then return nil end
        return hipatterns.compute_hex_color_group(string.format("#%06x", col), "bg")
      end
    end
    if vim.b.minihipatterns_disable ~= false then
      vim.b.minihipatterns_disable = false
      hipatterns.enable(0, {
        highlighters = {
          hex_color = hipatterns.gen_highlighter.hex_color(),
          word_color = { pattern = "%w+", group = hex_from_colormap() },
        },
      })
    else
      hipatterns.disable(0)
      vim.b.minihipatterns_disable = true
    end
  end, {})
end

return M
