local map_fzf = function(mode, key, f, options, buffer)

  local rhs = function()
    if not pcall(require, 'fzf-lua') then
      require('packer').loader('fzf-lua')
    end
    require('plugins.fzf-lua')[f](options or {})
  end

  local map_options = {
    noremap = true,
    silent = true,
    buffer = buffer,
  }

  require('utils').remap(mode, key, rhs, map_options)
end

-- mappings
map_fzf('n', '<F1>', "help_tags")
map_fzf('n', '<c-P>', "files", {})
map_fzf('n', '<c-K>', "workdirs", {
  winopts = {
    height       = 0.40,
    width        = 0.60,
    row          = 0.40,
  }})
map_fzf('n', '<leader>;', "buffers")
map_fzf('n', '<leader>fr', "grep", {})
map_fzf('n', '<leader>fl', "live_grep", {})
map_fzf('n', '<leader>fR', "live_grep", { repeat_last_search = true })
map_fzf('n', '<leader>ff', "resume")
-- map_fzf('n', '<leader>ff', "grep", { repeat_last_search = true} )
map_fzf('n', '<leader>fw', "grep_cword")
map_fzf('n', '<leader>fW', "grep_cWORD")
map_fzf('n', '<leader>fv', "grep_visual")
map_fzf('v', '<leader>fv', "grep_visual")
map_fzf('n', '<leader>fb', "blines")
map_fzf('n', '<leader>fB', "lgrep_curbuf", { prompt = 'Buffer❯ ' })
map_fzf('n', '<leader>f3', "blines", function()
  return { fzf_opts = { ["--query"] = vim.fn.expand("<cword>") }}
end)
map_fzf('n', '<leader>f8', "grep_curbuf", function()
  return { prompt = 'Buffer❯ ', search=vim.fn.expand("<cword>") }
end)
map_fzf('n', '<leader>f*', "grep_curbuf", function()
  return { prompt = 'Buffer❯ ', search=vim.fn.expand("<cWORD>") }
end)
map_fzf('n', '<leader>fp', "files", {})
map_fzf('n', '<leader>fg', "git_files", {})
map_fzf('n', '<leader>fH', "oldfiles", { cwd = "~" })
map_fzf('n', '<leader>fh', "oldfiles", function()
  return {
    cwd = vim.loop.cwd(),
    show_cwd_header = true,
    cwd_only = true,
  }
end)
map_fzf('n', '<leader>fq', "quickfix")
map_fzf('n', '<leader>fQ', "loclist")
map_fzf('n', '<leader>fo', "colorschemes")
map_fzf('n', '<leader>fO', "highlights")
map_fzf('n', '<leader>fM', "man_pages")

-- LSP
map_fzf('n', '<leader>lr', "lsp_references")
map_fzf('n', '<leader>ld', "lsp_definitions", { jump_to_single_result = false })
map_fzf('n', '<leader>lD', "lsp_declarations")
map_fzf('n', '<leader>ly', "lsp_typedefs")
map_fzf('n', '<leader>lm', "lsp_implementations")
map_fzf('n', '<leader>ls', "lsp_document_symbols", { path_shorten=1 })
map_fzf('n', '<leader>lS', "lsp_workspace_symbols", { path_shorten=1 })
map_fzf('n', '<leader>la', "lsp_code_actions", {
  winopts = {
    win_height       = 0.30,
    win_width        = 0.70,
    win_row          = 0.40,
  }})
map_fzf('n', '<leader>lg', "lsp_document_diagnostics", { file_icons = false })
map_fzf('n', '<leader>lG', "lsp_workspace_diagnostics", { file_icons = false })

-- Git
map_fzf('n', '<leader>fs', "git_status")
-- Full screen git status
map_fzf('n', '<leader>fS', "git_status_tmuxZ", {
  winopts = {
    fullscreen = true,
    preview = {
      vertical = "down:70%",
      horizontal = "right:70%",
    }
  }
})
map_fzf('n', '<leader>gB', "git_branches")
map_fzf('n', '<leader>gC', "git_commits")
map_fzf('n', '<leader>fC', "git_commits")
map_fzf('n', '<leader>fc', "git_bcommits")

-- yadm repo
local yadm_opts = {
  show_cwd_header = false,
  git_dir = "$HOME/dots/yadm-repo",
}
map_fzf('n', '<leader>ed', "git_files", vim.tbl_extend("force", yadm_opts,
  { prompt = "~ dotfiles ~ "}))
map_fzf('n', '<leader>eb', "git_branches", yadm_opts )
map_fzf('n', '<leader>eC', "git_commits",  yadm_opts )
map_fzf('n', '<leader>ec', "git_bcommits", yadm_opts )
map_fzf('n', '<leader>es', "git_status", vim.tbl_extend("force",
  yadm_opts, { cmd = "git status -s" }))
map_fzf('n', '<leader>eS', "git_status_tmuxZ", vim.tbl_extend("force",
  yadm_opts, {
    cmd = "git status -s",
    winopts = {
      fullscreen = true,
      preview = {
        vertical = "down:70%",
        horizontal = "right:70%",
      }
    }
  }))

-- Nvim & Dots
map_fzf('n', '<leader>ez', "files", {
  prompt = "~ zsh ~ ", cwd = "$HOME/.config/zsh"
})
map_fzf('n', '<leader>en', "files", {
  prompt = "< VimRC > ", cwd = "$HOME/.config/nvim"
})
map_fzf('n', '<leader>ep', "files", {
  prompt = "Plugins❯ ", cwd = vim.fn.stdpath "data" .. "/site/pack/packer/"
})

-- Fzf-lua methods
map_fzf('n', "<leader>f?", "builtin")
map_fzf('n', '<leader>fm', "marks")
map_fzf('n', '<leader>fx', "commands")
map_fzf('n', '<leader>f:', "command_history")
map_fzf('n', '<leader>f/', "search_history")
map_fzf('n', '<leader>f"', "registers")
map_fzf('n', '<leader>fk', "keymaps")
map_fzf('n', '<leader>fz', "spell_suggest", {
  winopts = {
    win_height       = 0.60,
    win_width        = 0.50,
    win_row          = 0.40,
  }})
map_fzf('n', '<leader>fT', "tags")
map_fzf('n', '<leader>ft', "btags")
