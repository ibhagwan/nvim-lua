require("mini.surround").setup({
  -- vim-surround style mappings
  -- left brackets add space around the text object
  -- 'ysiw('    foo -> ( foo )
  -- 'ysiw)'    foo ->  (foo)
  custom_surroundings = {
    -- since mini.nvim#84 we no longer need to customize
    -- the left brackets, they are spaced by default
    -- https://github.com/echasnovski/mini.nvim/issues/84
    s = {
      -- lua bracketed string mapping
      -- 'ysiwS'  foo -> [[foo]]
      input = { "%[%[().-()%]%]" },
      output = { left = "[[", right = "]]" },
    },
    b = {
      -- replace b (brackets) with lua block comment
      -- 'viwSb'  foo         -> --[[ foo ]]
      -- 'dsb'    --[[ foo ]] -> foo
      -- 'csb"'   --[[ foo ]] -> "foo"
      input = { "%-%-%[%[%s?().-()%s?%]%]" },
      output = { left = "--[[ ", right = " ]]" },
    },
  },
  mappings = {
    add = "ys",
    delete = "ds",
    find = "",
    find_left = "",
    highlight = "gs",    -- hijack 'gs' (sleep) for highlight
    replace = "cs",
    update_n_lines = "", -- bind for updating 'config.n_lines'
  },
  -- Number of lines within which surrounding is searched
  n_lines = 68,
  -- Duration (in ms) of highlight when calling `MiniSurround.highlight()`
  highlight_duration = 2000,
  -- How to search for surrounding (first inside current line, then inside
  -- neighborhood). One of 'cover', 'cover_or_next', 'cover_or_prev',
  -- 'cover_or_nearest'. For more details, see `:h MiniSurround.config`.
  search_method = "cover_or_next",
})

-- Remap adding surrounding to Visual mode selection
vim.keymap.set("x", "S", [[:<C-u>lua MiniSurround.add('visual')<CR>]], { silent = true })

-- unmap config generated `ys` mapping, prevents visual mode yank delay
vim.keymap.del("x", "ys")

-- Make special mapping for "add surrounding for line"
vim.keymap.set("n", "yss", "ys_", { remap = true })
