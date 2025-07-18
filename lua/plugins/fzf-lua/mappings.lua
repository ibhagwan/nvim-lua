-- yadm repo
local yadm_git_opts = {
  cwd_header = false,
  cwd = "$HOME",
  git_dir = "$YADM_REPO",
  git_worktree = "$HOME",
  git_config = "status.showUntrackedFiles=no",
}
local yadm_grep_opts = {
  prompt = "YadmGrep❯ ",
  cwd_header = false,
  cwd = "$HOME",
  cmd = "git --git-dir=${YADM_REPO} -C ${HOME} grep -i --line-number --column --color=always",
  rg_glob = false, -- this isn't `rg`
}

local keys = {
  ---@format disable
  { "<leader>,", function() require "fzf-lua".buffers() end, desc = "Buffers" },
  { "<leader>f?", function() require "fzf-lua".builtin() end, desc = "FzfLua Builtins", mode = { "n", "v" } },
  { "<leader>fP", function() require "fzf-lua".profiles() end, desc = "FzfLua Profiles" },
  { "<leader>f/", function() require "fzf-lua".search_history() end, desc = "Command History" },
  { "<leader>f:", function() require "fzf-lua".command_history() end, desc = "Command History" },
  { "<leader>fx", function() require "fzf-lua".commands() end, desc = "Commands" },
  { "<leader>f0", function() require "fzf-lua".tmux_buffers() end, desc = "Tmux Buffers" },
  { "<F1>", function() require "fzf-lua".helptags() end, desc = "Help Pages" },
  -- find
  { "<C-p>", function() require "fzf-lua".global() end, desc = "Find Files" },
  { "<C-k>", function() require "fzf-lua".zoxide() end, desc = "Zoxide" },
  { "<leader>fp", function() require "fzf-lua".files({ cwd = vim.fn.stdpath("data") .. "/lazy" }) end, desc = "Find Plugin File" },
  { "<leader>ff", function() require "fzf-lua".resume() end, desc = "Resume" },
  { "<leader>fF", function() require "fzf-lua".resume() end, desc = "Resume" },
  { "<leader>fH", function() require "fzf-lua".oldfiles() end, desc = "Oldfiles (All)" },
  { "<leader>fh", function() require "fzf-lua".oldfiles({ cwd = vim.uv.cwd(), cwd_header = true, cwd_only = true }) end, desc = "Oldfiles (cwd)" },
  -- git
  { "<leader>gb", function() require "fzf-lua".git_blame() end, desc = "Git Blame", mode = { "n", "v" } },
  { "<leader>gB", function() require "fzf-lua".git_branches() end, desc = "Git Branches" },
  { "<leader>gB", function() require "fzf-lua".git_branches() end, desc = "Git Branches" },
  { "<leader>gc", function() require "fzf-lua".git_bcommits() end, desc = "Git Log", mode = { "n",  "v" } },
  { "<leader>gC", function() require "fzf-lua".git_commits() end, desc = "Git Log" },
  { "<leader>gs", function() require "fzf-lua".git_status() end, desc = "Git Status" },
  { "<leader>gh", function() require "fzf-lua".git_hunks({ path_shorten = true }) end, desc = "Git Diff (hunks)" },
  { "<leader>gt", function() require "fzf-lua".git_tags() end, desc = "Git Tags" },
  { "<leader>gS", function() require "plugins.fzf-lua.cmds".git_status_tmuxZ({
    winopts = {
        fullscreen = true,
        preview = { vertical = "down:70%", horizontal = "right:70%" }
    }
  }) end, desc = "Git Status" },
  -- Grep
  { "<leader>fl", function() require "fzf-lua".live_grep() end, desc = "Grep" },
  { "<leader>fB", function() require "fzf-lua".lgrep_curbuf() end, desc = "Buffers Grep" },
  { "<leader>fw", function() require "fzf-lua".grep_cword() end, desc = "Grep word", mode = { "n", "v" } },
  { "<leader>fW", function() require "fzf-lua".grep_cWORD() end, desc = "Grep WORD", mode = { "n", "v" } },
  { "<leader>fv", function() require "fzf-lua".grep_visual() end, desc = "Grep Visual selection", mode = { "n", "v" } },
  { "<leader>ft", function() require "fzf-lua".btags() end, desc = "Buffer Tags" },
  { "<leader>fT", function() require "fzf-lua".tags() end, desc = "Tags" },
  { "<leader>fb", function() require "fzf-lua".blines() end, desc = "Buffer Lines", mode = { "n", "v" } },
  { "<leader>f3", function() require "fzf-lua".blines({ query = vim.fn.expand("<cword>") }) end, desc = "Buffer Lines (word)", mode = { "n" } },
  { "<leader>f3", function()
    vim.cmd("visual")
    require "fzf-lua".blines({ query = require("utils").get_visual_selection() })
  end, desc = "Buffer Lines (word)", mode = { "x" } },
  { "<leader>/", function() require "fzf-lua".blines({ start = "cursor" }) end, desc = "Buffer Lines", mode = { "n", "v" } },
  { "<leader>f8", function() require "fzf-lua".grep_curbuf({ search = vim.fn.expand("<cword>") }) end, desc = "Buffer Grep (word)" },
  { "<leader>f8", function()
    require "fzf-lua".grep_curbuf({ search = require("utils").get_visual_selection() })
  end, desc = "Buffer Grep (word)", mode = { "x" } },
  { "<leader>f*", function() require "fzf-lua".grep_curbuf({ search = vim.fn.expand("<cWORD>") }) end, desc = "Buffer Grep (WORD)" },
  -- search
  { '<leader>f"', function() require "fzf-lua".registers() end, desc = "Registers" },
  { "<leader>fa", function() require "fzf-lua".autocmds() end, desc = "Autocmds" },
  { "<leader>fO", function() require "fzf-lua".highlights() end, desc = "Highlights" },
  { "<leader>fj", function() require "fzf-lua".jumps() end, desc = "Jumps" },
  { "<leader>fk", function() require "fzf-lua".keymaps() end, desc = "Keymaps" },
  { "<leader>fq", function() require "fzf-lua".quickfix() end, desc = "Quickfix List" },
  { "<leader>fQ", function() require "fzf-lua".loclist() end, desc = "Location List" },
  { "<leader>fm", function() require "fzf-lua".marks() end, desc = "Marks" },
  { "<leader>fM", function() require "fzf-lua".manpages() end, desc = "Man Pages" },
  { "<leader>fo", function() require "fzf-lua".colorschemes({ winopts = { height = 0.45, width = 0.30 } }) end, desc = "Colorschemes" },
  { "<leader>fz", function() require "fzf-lua".spell_suggest() end, desc = "Spell suggest" },
  { "<leader>fs", function() require "fzf-lua".spellcheck() end, desc = "Spellcheck buffer", mode = { "n", "v" } },
  -- LSP
  { "<leader>ll", function() require "fzf-lua".lsp_finder() end, desc = "LSP Finder" },
  { "<leader>ld", function() require "fzf-lua".lsp_definitions() end, desc = "Goto Definition" },
  { "<leader>lD", function() require "fzf-lua".lsp_declarations() end, desc = "Goto Declaration" },
  { "<leader>lr", function() require "fzf-lua".lsp_references() end, nowait = true, desc = "References" },
  { "<leader>lm", function() require "fzf-lua".lsp_implementations() end, desc = "Goto Implementation" },
  { "<leader>ly", function() require "fzf-lua".lsp_typedefs() end, desc = "Goto T[y]pe Definition" },
  { "<leader>ls", function() require "fzf-lua".lsp_document_symbols() end, desc = "LSP Symbols (buffer)" },
  { "<leader>lS", function() require "fzf-lua".lsp_workspace_symbols() end, desc = "LSP Symbols (workspace)" },
  { "<leader>la", function() require "fzf-lua".lsp_code_actions() end, desc = "Code Actions" },
  { "<leader>lg", function() require "fzf-lua".diagnostics_document() end, desc = "Buffer Diagnostics" },
  { "<leader>lG", function() require "fzf-lua".diagnostics_workspace() end, desc = "Workspace Diagnostics" },
  { "<leader>lt", function() require "fzf-lua".treesitter() end, desc = "Treesitter" },
  -- yadm
  { "<leader>yf", function() require "fzf-lua".git_files(vim.tbl_extend("force", yadm_git_opts, { prompt = "YadmFiles> " })) end, desc = "Yadm Files" },
  { "<leader>yb", function() require "fzf-lua".git_branches(vim.tbl_extend("force", yadm_git_opts, { prompt = "YadmBranches> " })) end, desc = "Yadm Branches" },
  { "<leader>yc", function() require "fzf-lua".git_bcommits(vim.tbl_extend("force", yadm_git_opts, { prompt = "YadmBCommits> " })) end, desc = "Yadm Log", mode = { "n",  "v" } },
  { "<leader>yC", function() require "fzf-lua".git_commits(vim.tbl_extend("force", yadm_git_opts, { prompt = "YadmCommits> " })) end, desc = "Yadm Log" },
  { "<leader>yl", function() require "fzf-lua".live_grep(vim.tbl_extend("force", yadm_grep_opts, { prompt = "YadmGrep> " })) end, desc = "Yadm Grep" },
  { "<leader>ys", function() require "fzf-lua".git_status(vim.tbl_extend("force", yadm_git_opts, {
    prompt = "YadmStatus> ", cmd = "git status -s"
  })) end, desc = "Yadm Status" },
  { "<leader>yh", function() require "fzf-lua".git_hunks(vim.tbl_extend("force", yadm_git_opts, {
    prompt = "YadmDiff> ", path_shorten = true })) end, desc = "Yadm Diff (hunks)" },
  { "<leader>yS", function() require "plugins.fzf-lua.cmds".git_status_tmuxZ(vim.tbl_extend("force", yadm_git_opts, {
      prompt = "YadmStatus> ",
      cmd = "git -c color.status=false --no-optional-locks status --porcelain=v1",
      winopts = {
        fullscreen = true,
        preview = {
          vertical = "down:70%",
          horizontal = "right:70%",
        }
      } })) end, desc = "Yadm Status" },
}

return {
  map = function()
    for _, m in ipairs(keys) do
      local key = m[1]
      if require "utils".__USE_SNACKS then
        key = key:gsub("<leader>,", "<leader>;")
        for _, k in ipairs({ "<F1>", "<C-p>", "<C-k>" }) do
          if key == k then key = "<leader>" .. k end
        end
        key = key:gsub("<leader>%l", function(x)
          return x:sub(1, -2) .. x:sub(-1):upper()
        end)
      end
      local opts = vim.deepcopy(m)
      opts[1], opts[2], opts.mode = nil, nil, nil
      vim.keymap.set(m.mode or "n", key, m[2], opts)
    end
  end
}
