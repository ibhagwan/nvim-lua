TelescopeMapArgs = TelescopeMapArgs or {}

local map_tele = function(mode, key, f, options, buffer)
  local map_key = vim.api.nvim_replace_termcodes(key .. f, true, true, true)

  TelescopeMapArgs[map_key] = options or {}

  local rhs = string.format([[<cmd>lua require'utils'.ensure_loaded_fnc(]] ..
    [[ {'plenary.nvim', 'popup.nvim', 'telescope-fzy-native.nvim', 'telescope.nvim' }, function()]] ..
    [[ require('plugin.telescope')['%s'](TelescopeMapArgs['%s'])]] ..
    [[ end)<CR>]]
    , f, map_key)

  local map_options = {
    noremap = true,
    silent = true,
  }

  if not buffer then
    vim.api.nvim_set_keymap(mode, key, rhs, map_options)
  else
    vim.api.nvim_buf_set_keymap(0, mode, key, rhs, map_options)
  end
end

-- mappings
map_tele('n', '<leader><F1>', "help_tags")
map_tele('n', '<leader>ff', "find_files")
map_tele('n', '<leader>;', "buffers")
map_tele('n', '<space>fd', "fd")
map_tele('n', '<leader>fg', "git_files")
-- map_tele('n', '<leader>fb', "curbuf")
map_tele('n', '<leader>fb', "current_buffer_fuzzy_find")
map_tele('n', '<leader>fh', "oldfiles")
map_tele('n', '<leader>fc', "commands")
map_tele('n', '<leader>fx', "command_history")
map_tele('n', '<leader>fs', "search_history")
map_tele('n', '<leader>fm', "marks")
map_tele('n', '<leader>fM', "man_pages")
map_tele('n', '<leader>fq', "quickfix")
map_tele('n', '<leader>fQ', "loclist")
map_tele('n', '<leader>fR', "registers")
map_tele('n', '<leader>fo', "vim_options")
map_tele('n', '<leader>fk', "keymaps")
map_tele('n', '<leader>fz', "spell_suggest")
map_tele('n', '<leader>ft', "current_buffer_tags")
map_tele('n', '<leader>fT', "tags")
map_tele('n', '<leader>fl', "live_grep")

map_tele('n', "<space>f/", "grep_last_search", {
  layout_strategy = "vertical",
})
map_tele('n', '<leader>fw', "grep_cword")
map_tele('n', '<leader>fW', "grep_cWORD")
map_tele('n', '<leader>fr', "grep_prompt")
map_tele('n', '<leader>fv', "grep_visual")
map_tele('v', '<leader>fv', "grep_visual")

-- Git
map_tele('n', '<leader>fB', "git_branches")
map_tele('n', '<leader>gB', "git_branches")
map_tele('n', '<leader>gC', "git_commits")

-- LSP
map_tele('n', '<leader>lr', "lsp_references")
map_tele('n', '<leader>la', "lsp_code_actions")
map_tele('n', '<leader>lA', "lsp_range_code_actions")
map_tele('n', '<leader>ld', "lsp_definitions")
map_tele('n', '<leader>lm', "lsp_implementations")
map_tele('n', '<leader>lg', "lsp_document_diagnostics")
map_tele('n', '<leader>lG', "lsp_workspace_diagnostics")
map_tele('n', '<leader>ls', "lsp_document_symbols")
map_tele('n', '<leader>lS', "lsp_workspace_symbols")

-- Telescope Meta
map_tele('n', "<leader>f?", "builtin")
