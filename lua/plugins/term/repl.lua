local function ft_repl_cmd(ft)
  local repl_map = {
    ["lua"] = { "luap", "lua" },
    ["ruby"] = { "bundle exec rails console" },
    ["eruby"] = { "bundle exec rails console" },
    ["python"] = { "ipython --no-autoindent", "python" },
    ["javascript"] = { "node" },
    ["java"] = { "jshell" },
    ["elixir"] = { "iex" },
    ["julia"] = { "julia" },
    ["gp"] = { "gp" },
    ["r"] = { "R" },
    ["rmd"] = { "R" },
    ["octave"] = { "octave-cli", "octave" },
    ["matlab"] = { "matlab -nodesktop -nosplash" },
    ["idris"] = { "idris" },
    ["lidris"] = { "idris" },
    ["haskell"] = { "stack ghci", "ghci" },
    ["php"] = { "psysh", "php" },
    ["clojure"] = { "lein repl" },
    ["tcl"] = { "tclsh" },
    ["sml"] = { "rlwrap sml", "sml" },
    ["sbt"] = { "sbt console" },
    ["stata"] = { "stata -q" },
    ["racket"] = { "racket" },
    ["lfe"] = { "lfe" },
    ["rust"] = { "evcxr" },
    ["janet"] = { "janet" },
  }

  local executable = function(t)
    if not t then return end
    for _, c in ipairs(t) do
      if vim.fn.executable(c:match("[^ ]+")) == 1 then
        return c
      end
    end
    return nil
  end

  return executable(repl_map[ft])
end

local function term_exec(cmd, id)
  if not id or id < 1 then id = 1 end
  local terminal = require("toggleterm")
  local terms = require("toggleterm.terminal").get_all()
  local term_init = false
  for i = #terms, 1, -1 do
    local term = terms[i]
    if term.id == id then
      term_init = true
      break
    end
  end
  if not term_init then
    local repl_cmd = ft_repl_cmd(vim.bo.filetype)
    if repl_cmd then
      terminal.exec(repl_cmd, id)
    end
  end
  return terminal.exec(cmd, id)
end

vim.keymap.set({ "n" }, "gxx", function()
  return term_exec(vim.fn.getline("."))
end, { desc = "REPL send to terminal (line)" })

vim.keymap.set({ "v" }, "gx", function()
  local mode = vim.fn.mode()
  if mode == "v" or mode == "V" or mode == "" then
    local text = require "utils".get_visual_selection()
    term_exec(text)
  end
end, { desc = "REPL send to terminal (motion)" })

vim.api.nvim_create_user_command("T",
  function(t)
    term_exec(t.args, t.count)
  end,
  { nargs = "*", count = true }
)
