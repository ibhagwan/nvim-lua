local utils = require("utils")

local map_tele = function(mode, key, f, options, buffer)
  local desc = nil
  if type(options) == "table" then
    desc = options.desc
    options.desc = nil
  elseif type(options) == "function" then
    desc = options().desc
  end

  if utils.SWITCH_TELE then
    for _, k in ipairs({ "F", "L", "G" }) do
      key = key:gsub("<leader>" .. k, "<leader>" .. string.lower(k))
    end
    for _, k in ipairs({ "<F1>", "<c-P>", "<c-K>" }) do
      if key == "<leader>" .. k then
        key = k
      end
    end
    -- remap buffers
    if key == "<leader>;" then
      key = "<leader>,"
    end
  end

  local rhs = function()
    local builtin = require("telescope.builtin")
    local custom = require("plugins.telescope.cmds")
    if custom[f] then
      custom[f](options or {})
    else
      builtin[f](options or {})
    end
  end

  local map_options = {
    silent = true,
    buffer = buffer,
    desc   = desc or string.format("Telescope %s", f),
  }

  vim.keymap.set(mode, key, rhs, map_options)
end

-- non "<leader>F" keys
map_tele("n", "<leader>;", "buffers", { desc = "buffers" })
map_tele("n", "<leader><F1>", "help_tags", { desc = "help tags" })
map_tele("n", "<leader><c-P>", "find_files", { desc = "find files" })
map_tele("n", "<leader><c-K>", "workdirs", {
  desc = "cwd workdirs",
  layout_config = {
    width = 0.60,
    height = 0.40,
  },
})

map_tele("n", "<leader>Fp", "find_files", {
  desc = "plugin files",
  prompt_title = "Plugins",
  cwd = vim.fn.stdpath "data" .. "/lazy"
})

-- only tele
map_tele("n", "<leader>Ff", "find_files")

-- same as fzf-lua
map_tele("n", "<leader>F?", "builtin")
map_tele("n", "<leader>Ff", "resume")
map_tele("n", "<leader>FF", "resume")
map_tele("n", "<leader>Fm", "marks")
map_tele("n", "<leader>FM", "man_pages")
map_tele("n", "<leader>Fx", "commands")
map_tele("n", "<leader>F:", "command_history")
map_tele("n", "<leader>F/", "search_history")
map_tele("n", [[<leader>F"]], "registers")
map_tele("n", "<leader>Fk", "keymaps")
map_tele("n", "<leader>Fz", "spell_suggest")

map_tele("n", "<leader>FT", "tags")
map_tele("n", "<leader>Ft", "current_buffer_tags")

map_tele("n", "<leader>Fr", "grep_prompt")
-- TODO: how to resume last search
-- map_tele("n", "<leader>FR", "grep_prompt")
map_tele("n", "<leader>Fw", "grep_cword")
map_tele("n", "<leader>FW", "grep_cWORD")
map_tele("n", "<leader>Fv", "grep_visual")
map_tele("v", "<leader>Fv", "grep_visual")
map_tele("n", "<leader>Fb", "current_buffer_fuzzy_find")
map_tele("n", "<leader>Fl", "live_grep")

-- TODO: how to prefill query
map_tele("n", "<leader>F3", "current_buffer_fuzzy_find")

map_tele("n", "<leader>FH", "oldfiles", { prompt_title = "History (all)" })
map_tele("n", "<leader>Fh", "oldfiles", {
  prompt_title = "History (cwd)",
  cwd = vim.loop.cwd(),
  cwd_only = true
})
map_tele("n", "<leader>Fq", "quickfix")
map_tele("n", "<leader>FQ", "loclist")
map_tele("n", "<leader>Fo", "colorscheme")
map_tele("n", "<leader>FO", "highlights")
-- map_tele("n", "<leader>FO", "vim_options")

-- LSP
map_tele("n", "<leader>Lr", "lsp_references", { desc = "references [LSP]" })
map_tele("n", "<leader>Ld", "lsp_definitions",
  { telec = "definitionS [LSP]", jump_to_single_result = false })
map_tele("n", "<leader>Ly", "lsp_type_definitions", { desc = "type definitions [LSP]" })
map_tele("n", "<leader>Lm", "lsp_implementations", { desc = "implementations [LSP]" })
map_tele("n", "<leader>Ls", "lsp_document_symbols", { desc = "document symbols [LSP]" })
map_tele("n", "<leader>LS", "lsp_workspace_symbols", { desc = "workspace symbols [LSP]" })
map_tele("n", "<leader>Lg", "diagnostics", { bufnr = 0, desc = "document diagnostics [LSP]" })
map_tele("n", "<leader>LG", "diagnostics", { desc = "workspace diagnostics [LSP]" })

-- Git
map_tele("n", "<leader>Gf", "git_files", { desc = "git ls-files" })
map_tele("n", "<leader>Gs", "git_status", { desc = "git status" })
map_tele("n", "<leader>GB", "git_branches", { desc = "git branches" })
map_tele("n", "<leader>GC", "git_commits", { desc = "git commits (project)" })
map_tele("n", "<leader>Gc", "git_bcommits", { desc = "git commits (buffer)" })
map_tele("v", "<leader>Gc", "git_bcommits_range", { desc = "git commits (buffer)" })
