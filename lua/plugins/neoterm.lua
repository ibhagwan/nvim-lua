local res, terminal = pcall(require, "toggleterm")
if not res then
  return
end

terminal.setup({
  size = function(term)
    if term.direction == "horizontal" then
      return vim.o.lines * 0.4
    elseif term.direction == "vertical" then
      return vim.o.columns * 0.5
    end
  end,
  open_mapping = [[<c-\>]],
  hide_numbers = true,
  shade_filetypes = {},
  shade_terminals = true,
  shading_factor = '1',
  start_in_insert = true,
  insert_mappings = true,
  persist_size = true,
  -- direction = 'float',
  direction = 'horizontal',
  close_on_exit = true,
  float_opts = {
    border = 'rounded',
    width = math.floor(vim.o.columns*0.85),
    height = math.floor(vim.o.lines*0.8),
    winblend = 15,
    highlights = {
      border = "Normal",
      background = "Normal",
    }
  }
})

local remap = require'utils'.remap

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
  if not id or id<1 then id=1 end
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

remap({ "n" }, "gxx", function()
  return term_exec(vim.fn.getline('.'))
end)

remap({ "v" }, "gx", function()
  local mode = vim.fn.mode()
  if mode == 'v' or mode == 'V' or mode == '' then
    local text = require'utils'.get_visual_selection()
    term_exec(text)
  end
end)

require'utils'.command({
  "-count -nargs=*", "T",
  function(args, count)
    term_exec(args, count)
  end
})
