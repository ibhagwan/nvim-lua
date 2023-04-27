local map = vim.keymap.set

-- Reload the config (including certain plugins)
vim.api.nvim_create_user_command("NvimRestart",
  function()
    require("utils").reload_config()
  end,
  { nargs = "*" }
)

map("", "<leader>R", "<Esc>:NvimRestart<CR>",
  { silent = true, desc = "reload nvim configuration" })

-- Use ':Grep' or ':LGrep' to grep into quickfix|loclist
-- without output or jumping to first match
-- Use ':Grep <pattern> %' to search only current file
-- Use ':Grep <pattern> %:h' to search the current file dir
vim.cmd("command! -nargs=+ -complete=file Grep noautocmd grep! <args> | redraw! | copen")
vim.cmd("command! -nargs=+ -complete=file LGrep noautocmd lgrep! <args> | redraw! | lopen")

-- Fix common typos
vim.cmd([[
    cnoreabbrev W! w!
    cnoreabbrev W1 w!
    cnoreabbrev w1 w!
    cnoreabbrev Q! q!
    cnoreabbrev Q1 q!
    cnoreabbrev q1 q!
    cnoreabbrev Qa! qa!
    cnoreabbrev Qall! qall!
    cnoreabbrev Wa wa
    cnoreabbrev Wq wq
    cnoreabbrev wQ wq
    cnoreabbrev WQ wq
    cnoreabbrev wq1 wq!
    cnoreabbrev Wq1 wq!
    cnoreabbrev wQ1 wq!
    cnoreabbrev WQ1 wq!
    cnoreabbrev W w
    cnoreabbrev Q q
    cnoreabbrev Qa qa
    cnoreabbrev Qall qall
]])

-- root doesn't use plugins, use builtin FZF
if require "utils".is_root() then
  vim.env.FZF_DEFAULT_OPTS = (vim.env.FZF_DEFAULT_OPTS or "") .. " --info=default"
  vim.g.fzf_layout = { window = { ["width"] = 0.9, height = 0.9 } }
  map("n", "<C-p>", "<cmd>FZF<CR>", { desc = "FZF" })
end

map({ "n", "v", "i" }, "<C-x><C-f>",
  function() require("fzf-lua").complete_path() end,
  { silent = true, desc = "Fuzzy complete path" })

map({ "n", "v", "i" }, "<C-x><C-l>",
  function() require("fzf-lua").complete_line() end,
  { silent = true, desc = "Fuzzy complete line" })

-- <ctrl-s> to Save
map({ "n", "v", "i" }, "<C-S>", "<C-c>:update<cr>", { silent = true, desc = "Save" })

-- w!! to save with sudo
map("c", "w!!", "<esc>:lua require'utils'.sudo_write()<CR>", { silent = true })

-- Beginning and end of line in `:` command mode
map("c", "<C-a>", "<home>", {})
map("c", "<C-e>", "<end>", {})

-- Arrows in command line mode (':') menus
-- TODO: why the below doesn't work with nightly 0.8?
-- map('c', '<down>', '(pumvisible() ? "\\<C-n>" : "\\<down>")', { expr = true })
-- map('c', '<up>',   '(pumvisible() ? "\\<C-p>" : "\\<up>")',   { expr = true })
for k, v in pairs({ ["<down>"] = "<C-n>", ["<up>"] = "<C-p>" }) do
  map("c", k, function()
    local key = vim.fn.pumvisible() ~= 0 and v or k
    vim.api.nvim_feedkeys(
      vim.api.nvim_replace_termcodes(key,
        true, false, true), "n", false)
  end, { silent = false })
end

-- Terminal mappings
map("t", "<M-[>", [[<C-\><C-n>]], {})
map("t", "<C-w>", [[<C-\><C-n><C-w>]], {})
map("t", "<M-r>", [['<C-\><C-N>"'.nr2char(getchar()).'pi']], { expr = true })

-- TMUX aware navigation
for _, k in ipairs({ "h", "j", "k", "l", "\\" }) do
  map({ "n", "x", "t" }, string.format("<M-%s>", k), function()
    require("utils").tmux_aware_navigate(k, true)
  end, { silent = true })
end

-- tmux like directional window resizes
map("n", "<leader>=", "<C-w>=",
  { silent = true, desc = "normalize split layout" })
map("n", "<leader><Up>", "<cmd>lua require'utils'.resize(false, -5)<CR>",
  { silent = true, desc = "horizontal split increase" })
map("n", "<leader><Down>", "<cmd>lua require'utils'.resize(false,  5)<CR>",
  { silent = true, desc = "horizontal split decrease" })
map("n", "<leader><Left>", "<cmd>lua require'utils'.resize(true,  -5)<CR>",
  { silent = true, desc = "vertical split decrease" })
map("n", "<leader><Right>", "<cmd>lua require'utils'.resize(true,   5)<CR>",
  { silent = true, desc = "vertical split increase" })

-- Navigate tabs
map("n", "[t", ":tabprevious<CR>", { desc = "Previous tab" })
map("n", "]t", ":tabnext<CR>", { desc = "Next tab" })
map("n", "[T", ":tabfirst<CR>", { desc = "First tab" })
map("n", "]T", ":tablast<CR>", { desc = "Last tab" })
-- Navigate buffers
map("n", "[b", ":bprevious<CR>", { desc = "Previous buffer" })
map("n", "]b", ":bnext<CR>", { desc = "Next buffer" })
map("n", "[B", ":bfirst<CR>", { desc = "First buffer" })
map("n", "]B", ":blast<CR>", { desc = "Last buffer" })
-- Quickfix list mappings
map("n", "<leader>q", "<cmd>lua require'utils'.toggle_qf('q')<CR>",
  { desc = "toggle quickfix list" })
map("n", "[q", ":cprevious<CR>", { desc = "Next quickfix" })
map("n", "]q", ":cnext<CR>", { desc = "Previous quickfix" })
map("n", "[Q", ":cfirst<CR>", { desc = "First quickfix" })
map("n", "]Q", ":clast<CR>", { desc = "Last quickfix" })
-- Location list mappings
map("n", "<leader>Q", "<cmd>lua require'utils'.toggle_qf('l')<CR>",
  { desc = "toggle location list" })
map("n", "[l", ":lprevious<CR>", { desc = "Previous location" })
map("n", "]l", ":lnext<CR>", { desc = "Next location" })
map("n", "[L", ":lfirst<CR>", { desc = "First location" })
map("n", "]L", ":llast<CR>", { desc = "Last location" })

-- shortcut to view :messages
map({ "n", "v" }, "<leader>m", "<cmd>messages<CR>",
  { desc = "open :messages" })
map({ "n", "v" }, "<leader>M", [[<cmd>mes clear|echo "cleared :messages"<CR>]],
  { desc = "clear :messages" })

-- <leader>v|<leader>s act as <cmd-v>|<cmd-s>
-- <leader>p|P paste from yank register (0)
map({ "n", "v" }, "<leader>v", [["+p]], { desc = "paste AFTER from clipboard" })
map({ "n", "v" }, "<leader>V", [["+P]], { desc = "paste BEFORE from clipboard" })
map({ "n", "v" }, "<leader>s", [["*p]], { desc = "paste AFTER from primary" })
map({ "n", "v" }, "<leader>S", [["*P]], { desc = "paste BEFORE from primary" })
map({ "n", "v" }, "<leader>p", [["0p]], { desc = "paste AFTER  from yank (reg:0)" })
map({ "n", "v" }, "<leader>P", [["0P]], { desc = "paste BEFORE from yank (reg:0)" })

-- Overloads for 'd|c' that don't pollute the unnamed registers
map("n", "<leader>D", [["_D]], { desc = "blackhole 'D'" })
map("n", "<leader>C", [["_C]], { desc = "blackhole 'C'" })
map({ "n", "v" }, "<leader>c", [["_c]], { desc = "blackhole 'c'" })

-- keep visual selection when (de)indenting
map("v", "<", "<gv", {})
map("v", ">", ">gv", {})

-- Move selected lines up/down in visual mode
map("x", "K", ":move '<-2<CR>gv=gv", {})
map("x", "J", ":move '>+1<CR>gv=gv", {})

-- Select last pasted/yanked text
map("n", "g<C-v>", "`[v`]", { desc = "visual select last yank/paste" })

-- Keep matches center screen when cycling with n|N
map("n", "n", "nzzzv", { desc = "Fwd  search '/' or '?'" })
map("n", "N", "Nzzzv", { desc = "Back search '/' or '?'" })

-- Break undo chain on punctuation so we can
-- use 'u' to undo sections of an edit
-- DISABLED, ALL KINDS OF ODDITIES
--[[ for _, c in ipairs({',', '.', '!', '?', ';'}) do
   map('i', c, c .. "<C-g>u", {})
end --]]
-- any jump over 5 modifies the jumplist
-- so we can use <C-o> <C-i> to jump back and forth
for _, c in ipairs({
  { "k", "Line up" },
  { "j", "Line down" },
}) do
  map("n", c[1], ([[(v:count > 5 ? "m'" . v:count : "") . '%s']]):format(c[1]),
    { expr = true, silent = true, desc = c[2] })
end

-- move along visual lines, not numbered ones
-- without interferring with {count}<down|up>
for _, m in ipairs({ "n", "v" }) do
  for _, c in ipairs({
    { "<up>",   "k", "Visual line up" },
    { "<down>", "j", "Visual line down" }
  }) do
    map(m, c[1], ([[v:count == 0 ? 'g%s' : '%s']]):format(c[2], c[2]),
      { expr = true, silent = true, desc = c[3] })
  end
end

-- Search and Replace
-- 'c.' for word, 'c>' for WORD
-- 'c.' in visual mode for selection
map("n", "c.", [[:%s/\<<C-r><C-w>\>//g<Left><Left>]],
  { desc = "search and replace word under cursor" })
map("n", "c>", [[:%s/\V<C-r><C-a>//g<Left><Left>]],
  { desc = "search and replace WORD under cursor" })
map("x", "c.",
  [[:<C-u>%s/\V<C-r>=luaeval("require'utils'.get_visual_selection(true)")<CR>//g<Left><Left>]], {})

-- Turn off search matches with double-<Esc>
map("n", "<Esc><Esc>", "<Esc>:nohlsearch<CR>", { silent = true })

-- Toggle display of `listchars`
map("n", "<leader>'", "<Esc>:set list!<CR>",
  { silent = true, desc = "toggle 'listchars' on/off" })

-- Toggle colored column at 81
map("n", "<leader>|", function()
    vim.opt.colorcolumn = #vim.o.colorcolumn > 0 and ""
        or tostring(vim.g._colorcolumn)
  end,
  { silent = true, desc = "toggle color column on/off" })

-- Change current working dir (:pwd) to curent file's folder
map("n", "<leader>%", [[<Esc>:lua require"utils".set_cwd()<CR>]],
  { silent = true, desc = "smart set cwd (git|file parent)" })

-- Map <leader>o & <leader>O to newline without insert mode
map("n", "<leader>o",
  [[:<C-u>call append(line("."), repeat([""], v:count1))<CR>]],
  { silent = true, desc = "newline below (no insert-mode)" })
map("n", "<leader>O",
  [[:<C-u>call append(line(".")-1, repeat([""], v:count1))<CR>]],
  { silent = true, desc = "newline above (no insert-mode)" })

-- Use operator pending mode to visually select entire buffer, e.g.
--    d<A-a> = delete entire buffer
--    y<A-a> = yank entire buffer
--    v<A-a> = visual select entire buffer
map("o", "<A-a>", ":<C-U>normal! mzggVG<CR>`z")
map("x", "<A-a>", ":<C-U>normal! ggVG<CR>")
