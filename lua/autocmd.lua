local aucmd = vim.api.nvim_create_autocmd

local function augroup(name, fnc)
  fnc(vim.api.nvim_create_augroup(name, { clear = true }))
end

augroup("ibhagwan/FzfLuaCtrlC", function(g)
  aucmd("FileType",
    {
      group = g,
      pattern = "fzf",
      callback = function(e)
        vim.keymap.set("t", "<C-c>", "<C-c>", { buffer = e.buf, silent = true })
      end,
    })
end)

augroup("ibhagwan/StatusLineColors", function(g)
  aucmd("ColorScheme",
    {
      group = g,
      callback = function(_)
        -- fix 'listchars' highlight on nightfly
        if vim.g.colors_name == "nightfly" then
          vim.api.nvim_set_hl(0, "Whitespace", { default = false, link = "NonText" })
        end
        -- update heirline highlights, only do this after
        -- statusline is loaded or we lose the :intro screen
        if package.loaded.heirline then
          local utils = require("heirline.utils")
          local get_colors = require("plugins.heirline")._get_colors
          utils.on_colorscheme(get_colors)
        end
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

augroup("ibhagwan/ToggleColorcolumn", function(g)
  aucmd({ "VimResized", "WinEnter", "BufWinEnter" }, {
    group = g,
    callback = require("utils").toggle_colorcolumn
  })
end)

augroup("ibhagwan/ToggleSearchHL", function(g)
  aucmd("InsertEnter",
    {
      group = g,
      command = ":nohl | redraw"
    })
end)

augroup("ibhagwan/ActiveWinCursorLine", function(g)
  -- Highlight current line only on focused window
  aucmd({ "WinEnter", "BufEnter", "InsertLeave" }, {
    group = g,
    command = "if ! &cursorline && ! &pvw | setlocal cursorline | endif"
  })
  aucmd({ "WinLeave", "BufLeave", "InsertEnter" }, {
    group = g,
    command = "if &cursorline && ! &pvw | setlocal nocursorline | endif"
  })
end)

-- goto last location when opening a buffer
augroup("ibhagwan/BufLastLocation", function(g)
  aucmd("BufReadPost", {
    group = g,
    callback = function(args)
      local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
      local line_count = vim.api.nvim_buf_line_count(args.buf)
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
  local function is_float(winnr)
    local wincfg = vim.api.nvim_win_get_config(winnr)
    if wincfg and (wincfg.external or wincfg.relative and #wincfg.relative > 0) then
      return true
    end
    return false
  end

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
      if not is_float(to_win) and not is_float(from_win) then
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
        if not is_float(to_win) then
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
        -- exclude vim-fugitive buffers
        if vim.bo.filetype == "fugitive" or e.file:match("^fugitive:") then
          return
        end
        -- priortize LSP formatting as `gq`
        local lsp_has_formatting = false
        local lsp_clients = vim.lsp.get_active_clients()
        local lsp_keymap_set = function(m, c)
          vim.keymap.set(m, "gq", function()
            vim.lsp.buf.format({ async = true, bufnr = e.buf })
          end, {
            silent = true,
            buffer = e.buf,
            desc = string.format("format document [LSP:%s]", c.name)
          })
        end
        vim.tbl_map(function(c)
          if c.supports_method("textDocument/rangeFormatting", { bufnr = e.buf }) then
            lsp_keymap_set("x", c)
            lsp_has_formatting = true
          end
          if c.supports_method("textDocument/formatting", { bufnr = e.buf }) then
            lsp_keymap_set("n", c)
            lsp_has_formatting = true
          end
        end, lsp_clients)
        -- check conform.nvim for formatters:
        --   (1) if we have no LSP formatter map as `gq`
        --   (2) if LSP formatter exists, map as `gQ`
        local ok, conform = pcall(require, "conform")
        local formatters = ok and conform.list_formatters(e.buf) or {}
        if #formatters > 0 then
          vim.keymap.set("n", lsp_has_formatting and "gQ" or "gq", function()
            require("conform").format({ async = true, buffer = e.buf, lsp_fallback = false })
          end, {
            silent = true,
            buffer = e.buf,
            desc = string.format("format document [%s]", formatters[1].name)
          })
        end
      end,
    })
end)
