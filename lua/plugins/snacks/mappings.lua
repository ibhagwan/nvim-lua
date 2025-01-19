local keys = {
  { "<leader>;", function() require "snacks".picker.buffers() end, desc = "Buffers" },
  { "<leader>F?", function() require "snacks".picker.pickers() end, desc = "Snacks Pickers" },
  { "<leader>F/", function() require "snacks".picker.search_history() end, desc = "Command History" },
  { "<leader>F:", function() require "snacks".picker.command_history() end, desc = "Command History" },
  { "<leader>Fx", function() require "snacks".picker.commands() end, desc = "Commands" },
  { "<leader><F1>", function() require "snacks".picker.help() end, desc = "Help Pages" },
  -- find
  { "<leader><C-p>", function() require "snacks".picker.files() end, desc = "Find Files" },
  { "<leader><C-k>", function() require "snacks".picker.zoxide() end, desc = "Zoxide" },
  { "<leader>Fp", function() require "snacks".picker.files({ cwd = vim.fn.stdpath("data") .. "/lazy" }) end, desc = "Find Plugin File" },
  { "<leader>Ff", function() require "snacks".picker.resume() end, desc = "Resume" },
  { "<leader>FF", function() require "snacks".picker.resume() end, desc = "Resume" },
  { "<leader>Fh", function() require "snacks".picker.recent() end, desc = "Recent" },
  -- git
  { "<leader>Gf", function() require "snacks".picker.git_files() end, desc = "Find Git Files" },
  { "<leader>Gc", function() require "snacks".picker.git_log_file() end, desc = "Git Log" },
  { "<leader>GC", function() require "snacks".picker.git_log() end, desc = "Git Log" },
  { "<leader>Gs", function() require "snacks".picker.git_status() end, desc = "Git Status" },
  -- Grep
  { "<leader>Fl", function() require "snacks".picker.grep() end, desc = "Grep" },
  { "<leader>Fb", function() require "snacks".picker.lines() end, desc = "Buffer Lines" },
  { "<leader>FB", function() require "snacks".picker.grep_buffers() end, desc = "Grep Open Buffers" },
  { "<leader>Fw", function() require "snacks".picker.grep_word() end, desc = "Visual selection or word", mode = { "n", "v" } },
  -- search
  { '<leader>F"', function() require "snacks".picker.registers() end, desc = "Registers" },
  { "<leader>Fa", function() require "snacks".picker.autocmds() end, desc = "Autocmds" },
  { "<leader>FO", function() require "snacks".picker.highlights() end, desc = "Highlights" },
  { "<leader>Fj", function() require "snacks".picker.jumps() end, desc = "Jumps" },
  { "<leader>Fk", function() require "snacks".picker.keymaps() end, desc = "Keymaps" },
  { "<leader>Fq", function() require "snacks".picker.qflist() end, desc = "Quickfix List" },
  { "<leader>FQ", function() require "snacks".picker.loclist() end, desc = "Location List" },
  { "<leader>Fm", function() require "snacks".picker.marks() end, desc = "Marks" },
  { "<leader>FM", function() require "snacks".picker.man() end, desc = "Man Pages" },
  { "<leader>Fo", function() require "snacks".picker.colorschemes() end, desc = "Colorschemes" },
  { "<leader>FP", function() require "snacks".picker.projects() end, desc = "Projects" },
  { "<leader>Fz", function() require "snacks".picker.spelling() end, desc = "Zoxide" },
  -- LSP
  { "<leader>Ld", function() require "snacks".picker.lsp_definitions() end, desc = "Goto Definition" },
  { "<leader>Lr", function() require "snacks".picker.lsp_references() end, nowait = true, desc = "References" },
  { "<leader>Lm", function() require "snacks".picker.lsp_implementations() end, desc = "Goto Implementation" },
  { "<leader>Ly", function() require "snacks".picker.lsp_type_definitions() end, desc = "Goto T[y]pe Definition" },
  { "<leader>Ls", function() require "snacks".picker.lsp_symbols() end, desc = "LSP Symbols" },
  { "<leader>Lg", function() require "snacks".picker.diagnostics() end, desc = "Diagnostics" },
}

for _, m in ipairs(keys) do
  local opts = vim.deepcopy(m)
  opts[1], opts[2], opts.mode = nil, nil, nil
  vim.keymap.set(m.mode or "n", m[1], m[2], opts)
end
