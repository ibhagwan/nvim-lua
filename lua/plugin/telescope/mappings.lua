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
map_tele('n', '<leader>,', "buffers")
map_tele('n', '<leader>zf', "find_files")
map_tele('n', '<leader>zd', "fd")
map_tele('n', '<leader>zg', "git_files")
-- map_tele('n', '<leader>zb', "curbuf")
map_tele('n', '<leader>zb', "current_buffer_fuzzy_find")
map_tele('n', '<leader>zh', "oldfiles")
map_tele('n', '<leader>z:', "commands")
map_tele('n', '<leader>zx', "command_history")
map_tele('n', '<leader>z/', "search_history")
map_tele('n', '<leader>zm', "marks")
map_tele('n', '<leader>zM', "man_pages")
map_tele('n', '<leader>zq', "quickfix")
map_tele('n', '<leader>zQ', "loclist")
map_tele('n', '<leader>z"', "registers")
map_tele('n', '<leader>zo', "vim_options")
map_tele('n', '<leader>zk', "keymaps")
map_tele('n', '<leader>zz', "spell_suggest")
map_tele('n', '<leader>zt', "current_buffer_tags")
map_tele('n', '<leader>zT', "tags")
map_tele('n', '<leader>zR', "live_grep")

--[[ map_tele('n', "<space>z/", "grep_last_search", {
  layout_strategy = "vertical",
}) ]]
map_tele('n', '<leader>zw', "grep_cword")
map_tele('n', '<leader>zW', "grep_cWORD")
map_tele('n', '<leader>zr', "grep_prompt")
map_tele('n', '<leader>zv', "grep_visual")
map_tele('v', '<leader>zv', "grep_visual")

-- Telescope Meta
map_tele('n', "<leader>z?", "builtin")

-- Git
map_tele('n', '<leader>zB', "git_branches")
map_tele('n', '<leader>zs', "git_status")
map_tele('n', '<leader>zc', "git_commits")
map_tele('n', '<leader>zC', "git_bcommits")

-- LSP
map_tele('n', '<leader>zlr', "lsp_references")
map_tele('n', '<leader>zla', "lsp_code_actions")
map_tele('n', '<leader>zlA', "lsp_range_code_actions")
map_tele('n', '<leader>zld', "lsp_definitions")
map_tele('n', '<leader>zlm', "lsp_implementations")
map_tele('n', '<leader>zlg', "lsp_document_diagnostics")
map_tele('n', '<leader>zlG', "lsp_workspace_diagnostics")
map_tele('n', '<leader>zls', "lsp_document_symbols")
map_tele('n', '<leader>zlS', "lsp_workspace_symbols")

-- Nvim & Dots
map_tele('n', '<leader>zen', "edit_neovim")
map_tele('n', '<leader>zed', "edit_dotfiles")
map_tele('n', '<leader>zez', "edit_zsh")
map_tele('n', '<leader>zep', "installed_plugins")
