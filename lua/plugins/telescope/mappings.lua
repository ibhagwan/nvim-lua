local map_tele = function(mode, key, f, options, buffer)
  local desc = nil
  if type(options) == "table" then
    desc = options.desc
    options.desc = nil
  end

  local rhs = function()
    local builtins = require("telescope.builtin")
    if builtins[f] then
      builtins[f](options or {})
    else
      require("plugins.telescope.cmds")[f](options or {})
    end
  end

  local map_options = {
    silent = true,
    buffer = buffer,
    desc   = desc or string.format("Telescope %s", f),
  }

  vim.keymap.set(mode, key, rhs, map_options)
end

-- mappings
map_tele("n", "<leader><F1>", "help_tags")
map_tele("n", "<leader>,", "buffers")
map_tele("n", "<leader>tf", "find_files")
map_tele("n", "<leader>tg", "git_files")
map_tele("n", "<leader>tb", "current_buffer_fuzzy_find")
map_tele("n", "<leader>tH", "oldfiles", { cwd = "~" })
map_tele("n", "<leader>th", "oldfiles", { cwd = vim.loop.cwd(), cwd_only = true })
map_tele("n", "<leader>tx", "commands")
map_tele("n", "<leader>t:", "command_history")
map_tele("n", "<leader>t/", "search_history")
map_tele("n", "<leader>tm", "marks")
map_tele("n", "<leader>tM", "man_pages")
map_tele("n", "<leader>tq", "quickfix")
map_tele("n", "<leader>tQ", "loclist")
map_tele("n", [[<leader>t"]], "registers")
map_tele("n", "<leader>to", "vim_options")
-- map_tele('n', '<leader>to', "colorscheme")
map_tele("n", "<leader>tO", "highlights")
map_tele("n", "<leader>tk", "keymaps")
map_tele("n", "<leader>tz", "resume")
map_tele("n", "<leader>tt", "current_buffer_tags")
map_tele("n", "<leader>tT", "tags")
map_tele("n", "<leader>tR", "live_grep")

map_tele("n", "<leader>tw", "grep_cword")
map_tele("n", "<leader>tW", "grep_cWORD")
map_tele("n", "<leader>tr", "grep_prompt")
map_tele("n", "<leader>tv", "grep_visual")
map_tele("v", "<leader>tv", "grep_visual")

-- Telescope Meta
map_tele("n", "<leader>t?", "builtin")

-- Git
map_tele("n", "<leader>tB", "git_branches")
map_tele("n", "<leader>ts", "git_status")
map_tele("n", "<leader>tc", "git_bcommits")
map_tele("n", "<leader>tC", "git_commits")

-- LSP
map_tele("n", "<leader>tlr", "lsp_references")
map_tele("n", "<leader>tld", "lsp_definitions")
map_tele("n", "<leader>tlm", "lsp_implementations")
map_tele("n", "<leader>tlg", "diagnostics", { bufnr = 0 })
map_tele("n", "<leader>tlG", "diagnostics")
map_tele("n", "<leader>tls", "lsp_document_symbols")
map_tele("n", "<leader>tlS", "lsp_workspace_symbols")

-- Insalled plugin folder
map_tele("n", "<leader>tp", "installed_plugins")
