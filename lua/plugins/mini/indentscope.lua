require("mini.indentscope").setup({
  draw = {
    -- Delay (in ms) between event and start of drawing scope indicator
    delay = 100,
    -- Animation rule for scope's first drawing. A function which, given next
    -- and total step numbers, returns wait time (in ms). See
    -- |MiniIndentscope.gen_animation()| for builtin options. To not use
    -- animation, supply `require('mini.indentscope').gen_animation('none')`.
    animation = function(_, _)
      return 5
    end,
  },
  -- Module mappings. Use `''` (empty string) to disable one.
  mappings = {
    -- Textobjects
    object_scope = "ii",
    object_scope_with_border = "ai",
    -- Motions (jump to respective border line; if not present - body line)
    goto_top = "[i",
    goto_bottom = "]i",
  },
  -- Options which control computation of scope. Buffer local values can be
  -- supplied in buffer variable `vim.b.miniindentscope_options`.
  options = {
    -- Type of scope's border: which line(s) with smaller indent to
    -- categorize as border. Can be one of: 'both', 'top', 'bottom', 'none'.
    border = "both",
    -- Whether to use cursor column when computing reference indent. Useful to
    -- see incremental scopes with horizontal cursor movements.
    indent_at_cursor = true,
    -- Whether to first check input line to be a border of adjacent scope.
    -- Use it if you want to place cursor on function header to get scope of
    -- its body.
    try_as_border = true,
  },
  -- Which character to use for drawing scope indicator
  -- alternative styles: ┆ ┊ ╎
  symbol = "╎",
})

vim.keymap.set("", [[<leader>"]],
  "<cmd>lua require'plugins.mini.indentscope'.btoggle()<CR>",
  { silent = true, desc = "toggle 'mini.indentscope' on/off" })

local M = {}

M.toggle = function(bufnr)
  if bufnr then
    vim.b.miniindentscope_disable = not vim.b.miniindentscope_disable
  else
    vim.g.miniindentscope_disable = not vim.g.miniindentscope_disable
  end
  require("mini.indentscope").draw()
end

M.btoggle = function()
  M.toggle(vim.api.nvim_get_current_buf())
end

return M
