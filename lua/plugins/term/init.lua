local M = {
  "akinsho/toggleterm.nvim",
  keys = { "gxx", "gx", "<C-\\>" },
  cmd = { "T" },
}

M.config = function()
  require("plugins.term.repl")
  require("toggleterm").setup({
    size = function(term)
      if term.direction == "horizontal" then
        return vim.o.lines * 0.4
      elseif term.direction == "vertical" then
        return vim.o.columns * 0.5
      end
    end,
    open_mapping = [[<c-\>]],
    hide_numbers = true,
    shade_filetypes = {},
    shade_terminals = true,
    shading_factor = -30,
    start_in_insert = true,
    insert_mappings = true,
    persist_size = true,
    -- direction = 'float',
    direction = "horizontal",
    close_on_exit = true,
    float_opts = {
      border = "rounded",
      width = math.floor(vim.o.columns * 0.85),
      height = math.floor(vim.o.lines * 0.8),
      winblend = 15,
      highlights = {
        border = "Normal",
        background = "Normal",
      }
    },
    highlights = {
      StatusLine   = { link = "StatusLine" },
      StatusLineNC = { link = "StatusLineNC" },
    }
  })
end

return M
