FzfMapArgs = FzfMapArgs or {}

local map_fzf = function(mode, key, f, options, buffer)
  local map_fzf = vim.api.nvim_replace_termcodes(key .. f, true, true, true)

  FzfMapArgs[map_fzf] = options or {}

  local rhs = string.format([[<cmd>lua require'utils'.ensure_loaded_fnc(]] ..
    [[ {'nvim-fzf','fzf-lua'}, function()]] ..
    [[ require('plugin.fzf-lua')['%s'](FzfMapArgs['%s'])]] ..
    [[ end)<CR>]]
    , f, map_fzf)

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
map_fzf('n', '<F1>', "help_tags")
map_fzf('n', '<c-P>', "files", {})
map_fzf('n', '<leader>,', "buffers")
map_fzf('n', '<leader>zr', "grep", {})
map_fzf('n', '<leader>zl', "live_grep", {})
map_fzf('n', '<leader>zR', "live_grep", {})
map_fzf('n', '<leader>zz', "grep", { repeat_last_search = true} )
map_fzf('n', '<leader>zw', "grep_cword")
map_fzf('n', '<leader>zW', "grep_cWORD")
map_fzf('n', '<leader>zv', "grep_visual")
map_fzf('v', '<leader>zv', "grep_visual")
map_fzf('n', '<leader>zb', "grep_curbuf", { prompt = 'Buffer❯ ' })
map_fzf('n', '<leader>zf', "files", {})
map_fzf('n', '<leader>zg', "git_files", {})
map_fzf('n', '<leader>zh', "oldfiles")
map_fzf('n', '<leader>zq', "quickfix")
map_fzf('n', '<leader>zQ', "loclist")
map_fzf('n', '<leader>zo', "colorschemes")
map_fzf('n', '<leader>zM', "man_pages")

-- Nvim & Dots
map_fzf('n', '<leader>en', "edit_neovim")
map_fzf('n', '<leader>ed', "edit_dotfiles")
map_fzf('n', '<leader>ez', "edit_zsh")
map_fzf('n', '<leader>ep', "installed_plugins")

--[[
map_fzf('n', '<leader>fc', "commands")
map_fzf('n', '<leader>fx', "command_history")
map_fzf('n', '<leader>fs', "search_history")
map_fzf('n', '<leader>fm', "marks")
map_fzf('n', '<leader>fR', "registers")
map_fzf('n', '<leader>fo', "vim_options")
map_fzf('n', '<leader>fk', "keymaps")
map_fzf('n', '<leader>fz', "spell_suggest")
map_fzf('n', '<leader>ft', "current_buffer_tags")
map_fzf('n', '<leader>fT', "tags")

-- Git
map_fzf('n', '<leader>fB', "git_branches")
map_fzf('n', '<leader>gB', "git_branches")
map_fzf('n', '<leader>gC', "git_commits")

-- LSP
map_fzf('n', '<leader>lr', "lsp_references")
map_fzf('n', '<leader>la', "lsp_code_actions")
map_fzf('n', '<leader>lA', "lsp_range_code_actions")
map_fzf('n', '<leader>ld', "lsp_definitions")
map_fzf('n', '<leader>lm', "lsp_implementations")
map_fzf('n', '<leader>lg', "lsp_document_diagnostics")
map_fzf('n', '<leader>lG', "lsp_workspace_diagnostics")
map_fzf('n', '<leader>ls', "lsp_document_symbols")
map_fzf('n', '<leader>lS', "lsp_workspace_symbols")

-- Telescope Meta
map_fzf('n', "<leader>f?", "builtin") ]]
