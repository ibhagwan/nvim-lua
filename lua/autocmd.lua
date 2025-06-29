local utils = require("utils")
local aucmd = vim.api.nvim_create_autocmd

local function augroup(name, fnc)
  fnc(vim.api.nvim_create_augroup(name, { clear = true }))
end

if utils.is_root() then
  augroup("ibhagwan/SmartTextYankPost", function(g)
    -- highlight yanked text and copy to system clipboard
    -- TextYankPost is also called on deletion, limit to
    -- yanks via v:operator
    -- if we are connected over ssh also copy using OSC52
    aucmd("TextYankPost", {
      group = g,
      pattern = "*",
      -- command = "if has('clipboard') && v:operator=='y' && len(@0)>0 | "
      --   .. "let @+=@0 | endif | "
      --   .. "lua vim.highlight.on_yank{higroup='IncSearch', timeout=2000}"
      desc = "Copy to clipboard/tmux/OSC52",
      callback = function()
        local ok, yank_data = pcall(vim.fn.getreg, "0")
        local valid_yank = ok and #yank_data > 0 and vim.v.operator == "y"
        if valid_yank and vim.fn.has("clipboard") == 1 then
          pcall(vim.fn.setreg, "+", yank_data)
        end
        -- $SSH_CONNECTION doesn't pass over to
        -- root when using `su -`, copy indiscriminately
        if valid_yank and (vim.env.SSH_CONNECTION or utils.is_root()) then
          utils.osc52printf(yank_data)
        end
        if valid_yank and vim.env.TMUX then
          -- we use `-w` to also copy to client's clipboard
          vim.system({ "tmux", "set-buffer", "-w", yank_data }):wait()
        end
        vim.highlight.on_yank({ higroup = "IncSearch", timeout = 1000 })
      end
    })
  end)
end

augroup("ibhagwan/ColorScheme", function(g)
  aucmd("ColorSchemePre", {
    group = g,
    callback = function(_)
      vim.g.fzf_colors = nil
    end
  })
  aucmd("ColorScheme", {
    group = g,
    callback = function(_)
      -- workaround for messed up block cursor on blink.sh
      vim.api.nvim_set_hl(0, "TermCursor", { default = false, reverse = true })
      -- fix 'listchars' highlight on nightfly
      if vim.g.colors_name == "nightfly" or "moonfly" then
        vim.api.nvim_set_hl(0, "Whitespace", { default = false, link = "NonText" })
        vim.api.nvim_set_hl(0, "FloatBorder", { default = false, link = "LineNr" })
        vim.api.nvim_set_hl(0, "WinSeparator", { default = false, link = "FloatBorder" })
        vim.api.nvim_set_hl(0, "ColorColumn", { default = false, link = "PmenuSbar" })
      elseif vim.g.colors_name:match("tokyonight") then
        vim.api.nvim_set_hl(0, "WinSeparator", { default = false, link = "FloatBorder" })
      end
      -- fzf-lua
      if type(vim.g.fzf_colors) == "table" then
        vim.g.fzf_colors = vim.tbl_deep_extend("keep",
          { ["bg+"] = { "bg", "Visual" } }, vim.g.fzf_colors)
      end
      vim.api.nvim_set_hl(0, "FzfLuaCursorLine", { default = false, link = "Visual" })
      vim.api.nvim_set_hl(0, "FzfLuaFzfCursorLine", { default = false, link = "Visual" })
      -- treesitter context
      vim.api.nvim_set_hl(0, "TreesitterContext", { default = false, link = "Visual" })
      vim.api.nvim_set_hl(0, "TreesitterContextBottom", { default = false, underline = true })
      -- render-markdown
      vim.api.nvim_set_hl(0, "RenderMarkdownCode", { default = false, link = "DiffChange" })
      vim.api.nvim_set_hl(0, "RenderMarkdownH1Bg", { default = false, link = "Visual" })
      vim.api.nvim_set_hl(0, "RenderMarkdownH2Bg", { default = false, link = "DiffText" })
      vim.api.nvim_set_hl(0, "RenderMarkdownH3Bg", { default = false, link = "DiffAdd" })
      vim.api.nvim_set_hl(0, "RenderMarkdownH4Bg", { default = false, link = "DiffAdd" })
      vim.api.nvim_set_hl(0, "RenderMarkdownH5Bg", { default = false, link = "DiffAdd" })
      vim.api.nvim_set_hl(0, "RenderMarkdownH6Bg", { default = false, link = "DiffAdd" })
    end,
  })
end)

-- disable mini.indentscope for certain filetype|buftype
augroup("ibhagwan/MiniIndentscopeDisable", function(g)
  aucmd("BufEnter", {
    group = g,
    callback = function(_)
      if vim.bo.filetype == "fzf"
          or vim.bo.filetype == "help"
          or vim.bo.buftype == "nofile"
          or vim.bo.buftype == "terminal"
      then
        vim.b.miniindentscope_disable = true
      end
    end,
  })
end)

augroup("ibhagwan/TermOptions", function(g)
  aucmd("TermOpen",
    {
      group = g,
      command = "setlocal listchars= nonumber norelativenumber"
    })
end)

augroup("ibhagwan/ResizeWindows", function(g)
  aucmd("VimResized",
    {
      group = g,
      command = "tabdo wincmd ="
    })
end)

augroup("ibhagwan/ToggleSearchHL", function(g)
  aucmd("InsertEnter", {
    group = g,
    callback = function()
      vim.schedule(function() vim.cmd("nohlsearch") end)
    end
  })
  aucmd("CursorMoved", {
    group = g,
    callback = function()
      --[[ -- No bloat lua adpatation of: https://github.com/romainl/vim-cool
      local view, rpos = vim.fn.winsaveview(), vim.fn.getpos(".")
      assert(view.lnum == rpos[2])
      assert(view.col + 1 == rpos[3])
      -- Move the cursor to a position where (whereas in active search) pressing `n`
      -- brings us to the original cursor position, in a forward search / that means
      -- one column before the match, in a backward search ? we move one col forward
      vim.cmd(string.format("silent! keepjumps go%s",
        (vim.fn.line2byte(view.lnum) + view.col + 1 - (vim.v.searchforward == 1 and 2 or 0))))
      -- Attempt to goto next match, if we're in an active search cursor position
      -- should be equal to original cursor position
      local ok, _ = pcall(vim.cmd, "silent! keepjumps norm! n")
      local insearch = ok and (function()
        local npos = vim.fn.getpos(".")
        return npos[2] == rpos[2] and npos[3] == rpos[3]
      end)()
      -- restore original view and position
      vim.fn.winrestview(view)
      if not insearch then
        vim.schedule(function() vim.cmd("nohlsearch") end)
      end ]]
      if vim.v.hlsearch == 1 and vim.fn.searchcount().exact_match == 0 then
        vim.schedule(function() vim.cmd.nohlsearch() end)
      end
    end
  })
end)

augroup("ibhagwan/ActiveWinCursorLine", function(g)
  -- Highlight current line only on focused window
  local callback = function()
    local curwin = vim.api.nvim_get_current_win()
    for _, w in ipairs(vim.api.nvim_list_wins()) do
      vim.wo[w].cursorline = w == curwin
    end
  end
  aucmd({ "WinEnter", "BufEnter", "InsertLeave" }, { group = g, callback = callback })
  aucmd({ "WinLeave", "BufLeave", "InsertEnter" }, { group = g, callback = callback })
end)

-- goto last location when opening a buffer
augroup("ibhagwan/BufLastLocation", function(g)
  aucmd("BufReadPost", {
    group = g,
    callback = function(e)
      -- skip fugitive commit message buffers
      local bufname = vim.api.nvim_buf_get_name(e.buf)
      if bufname:match("COMMIT_EDITMSG$") then return end
      local mark = vim.api.nvim_buf_get_mark(e.buf, '"')
      local line_count = vim.api.nvim_buf_line_count(e.buf)
      if mark[1] > 0 and mark[1] <= line_count then
        vim.cmd 'normal! g`"zz'
      end
    end,
  })
end)

-- auto-delete fugitive buffers
augroup("ibhagwan/Fugitive", function(g)
  aucmd("BufReadPost", {
    group = g,
    pattern = "fugitive:*",
    command = "set bufhidden=delete"
  })
end)

-- Solidity abi JSON
augroup("ibhagwan/SolidityABI", function(g)
  aucmd({ "BufRead", "BufNewFile" }, {
    group = g,
    pattern = "*.abi",
    command = "set filetype=jsonc"
  })
end)

-- Display help|man in vertical splits and map 'q' to quit
augroup("ibhagwan/Help", function(g)
  local function open_vert()
    -- do nothing for floating windows or if this is
    -- the fzf-lua minimized help window (height=1)
    local cfg = vim.api.nvim_win_get_config(0)
    if cfg and (cfg.external or cfg.relative and #cfg.relative > 0)
        or vim.api.nvim_win_get_height(0) == 1 then
      return
    end
    -- do not run if Diffview is open
    if vim.g.diffview_nvim_loaded and
        require "diffview.lib".get_current_view() then
      return
    end
    local width = math.floor(vim.o.columns * 0.75)
    vim.cmd("wincmd L")
    vim.cmd("vertical resize " .. width)
    vim.keymap.set("n", "q", "<CMD>q<CR>", { buffer = true })
  end

  aucmd("FileType", {
    group = g,
    pattern = "help,man",
    callback = open_vert,
  })
  -- we also need this auto command or help
  -- still opens in a split on subsequent opens
  aucmd("BufEnter", {
    group = g,
    pattern = "*.txt",
    callback = function()
      if vim.bo.buftype == "help" then
        open_vert()
      end
    end
  })
  aucmd("BufHidden", {
    group = g,
    pattern = "man://*",
    callback = function()
      if vim.bo.filetype == "man" then
        local bufnr = vim.api.nvim_get_current_buf()
        vim.defer_fn(function()
          if vim.api.nvim_buf_is_valid(bufnr) then
            vim.api.nvim_buf_delete(bufnr, { force = true })
          end
        end, 0)
      end
    end
  })
end)

-- https://vim.fandom.com/wiki/Avoid_scrolling_when_switch_buffers
augroup("ibhagwan/DoNotAutoScroll", function(g)
  aucmd("BufLeave", {
    group = g,
    desc = "Avoid autoscroll when switching buffers",
    callback = function()
      -- at this stage, current buffer is the buffer we leave
      -- but the current window already changed, verify neither
      -- source nor destination are floating windows
      local from_buf = vim.api.nvim_get_current_buf()
      local from_win = vim.fn.bufwinid(from_buf)
      local to_win = vim.api.nvim_get_current_win()
      if not utils.win_is_float(to_win) and not utils.win_is_float(from_win) then
        vim.b.__VIEWSTATE = vim.fn.winsaveview()
      end
    end
  })
  aucmd("BufEnter", {
    group = g,
    desc = "Avoid autoscroll when switching buffers",
    callback = function()
      if vim.b.__VIEWSTATE then
        local to_win = vim.api.nvim_get_current_win()
        if not utils.win_is_float(to_win) then
          vim.fn.winrestview(vim.b.__VIEWSTATE)
        end
        vim.b.__VIEWSTATE = nil
      end
    end
  })
end)

augroup("ibhagwan/GQFormatter", function(g)
  aucmd({ "FileType", "LspAttach" },
    {
      group = g,
      callback = function(e)
        -- execlude diffview and vim-fugitive
        if vim.bo.filetype == "fugitive"
            or e.file:match("^fugitive:")
            or require("plugins.diffview")._is_open() then
          return
        end
        require("plugins.conform")._set_gq_keymap(e)
      end,
    })
end)

augroup("ibhagwan/LspAttach", function(g)
  aucmd({ "LspAttach" },
    {
      group = g,
      callback = function(_)
        require("lsp.keymaps").setup()
      end,
    })
end)
