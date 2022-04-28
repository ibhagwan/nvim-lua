local map_tele = function(mode, key, f, options, buffer)

  local rhs = function()
    if not pcall(require, 'telescope.nvim') then
      require('packer').loader('plenary.nvim')
      require('packer').loader('popup.nvim')
      require('packer').loader('telescope-fzy-native.nvim')
      require('packer').loader('telescope.nvim')
    end
    require('plugins.telescope')[f](options or {})
  end

  local map_options = {
    noremap = true,
    silent = true,
    buffer = buffer,
  }

  require('utils').remap(mode, key, rhs, map_options)
end

-- mappings
map_tele('n', '<leader><F1>', "help_tags")
map_tele('n', '<leader>,', "buffers")
map_tele('n', '<leader>zf', "find_files")
map_tele('n', '<leader>zg', "git_files")
map_tele('n', '<leader>zb', "current_buffer_fuzzy_find")
map_tele('n', '<leader>zH', "oldfiles", { cwd = "~" })
map_tele('n', '<leader>zh', "oldfiles", { cwd = vim.loop.cwd(), cwd_only=true })
map_tele('n', '<leader>zx', "commands")
map_tele('n', '<leader>z:', "command_history")
map_tele('n', '<leader>z/', "search_history")
map_tele('n', '<leader>zm', "marks")
map_tele('n', '<leader>zM', "man_pages")
map_tele('n', '<leader>zq', "quickfix")
map_tele('n', '<leader>zQ', "loclist")
map_tele('n', '<leader>z"', "registers")
map_tele('n', '<leader>zo', "vim_options")
-- map_tele('n', '<leader>zo', "colorscheme")
map_tele('n', '<leader>zO', "highlights")
map_tele('n', '<leader>zk', "keymaps")
map_tele('n', '<leader>zz', "resume")
map_tele('n', '<leader>zt', "current_buffer_tags")
map_tele('n', '<leader>zT', "tags")
map_tele('n', '<leader>zR', "live_grep")

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
map_tele('n', '<leader>zc', "git_bcommits")
map_tele('n', '<leader>zC', "git_commits")

-- LSP
map_tele('n', '<leader>zlr', "lsp_references")
map_tele('n', '<leader>zla', "lsp_code_actions")
map_tele('n', '<leader>zlA', "lsp_range_code_actions")
map_tele('n', '<leader>zld', "lsp_definitions")
map_tele('n', '<leader>zlm', "lsp_implementations")
map_tele('n', '<leader>zlg', "diagnostics", { bufnr=0 })
map_tele('n', '<leader>zlG', "diagnostics")
map_tele('n', '<leader>zls', "lsp_document_symbols")
map_tele('n', '<leader>zlS', "lsp_workspace_symbols")

-- Nvim & Dots
map_tele('n', '<leader>zen', "edit_neovim")
map_tele('n', '<leader>zed', "edit_dotfiles")
map_tele('n', '<leader>zez', "edit_zsh")
map_tele('n', '<leader>zep', "installed_plugins")
