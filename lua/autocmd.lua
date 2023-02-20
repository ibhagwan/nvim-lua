local aucmd = vim.api.nvim_create_autocmd

local function augroup(name, fnc)
  fnc(vim.api.nvim_create_augroup(name, { clear = true }))
end

augroup("FzfLuaCtrlC", function(g)
  aucmd("FileType",
    {
      group = g,
      pattern = "fzf",
      callback = function()
        vim.api.nvim_buf_del_keymap(0, "t", "<C-c>")
      end,
    })
end)

augroup("SmartTextYankPost", function(g)
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
      if valid_yank and (vim.env.SSH_CONNECTION or
          -- $SSH_CONNECTION doesn't pass over to
          -- root when using `su -`, copy indiscriminately
          require "utils".is_root()) then
        require "utils".osc52printf(yank_data)
      end
      if valid_yank and vim.env.TMUX then
        -- we use `-w` to also copy to client's clipboard
        vim.fn.system({ "tmux", "set-buffer", "-w", yank_data })
      end
      vim.highlight.on_yank({ higroup = "IncSearch", timeout = 1000 })
    end
  })
end)

-- disable mini.indentscope for certain filetype|buftype
augroup("MiniIndentscopeDisable", function(g)
  aucmd("BufEnter", {
    group = g,
    pattern = "*",
    command = "if index(['fzf', 'help'], &ft) >= 0 "
    .. "|| index(['nofile', 'terminal'], &bt) >= 0 "
    .. "| let b:miniindentscope_disable=v:true | endif"
  })
end)

augroup("NewlineNoAutoComments", function(g)
  aucmd("BufEnter", {
    group = g,
    pattern = "*",
    command = "setlocal formatoptions-=o"
  })
end)

augroup("TermOptions", function(g)
  aucmd("TermOpen",
    {
      group = g,
      pattern = "*",
      command = "setlocal listchars= nonumber norelativenumber"
    })
end)

augroup("ResizeWindows", function(g)
  aucmd("VimResized",
    {
      group = g,
      pattern = "*",
      command = "tabdo wincmd ="
    })
end)

augroup("ToggleColorcolumn", function(g)
  aucmd({ "VimResized", "WinEnter", "BufWinEnter" }, {
    group = g,
    pattern = "*",
    command = 'lua require"utils".toggle_colorcolumn()',
  })
end)

augroup("ToggleSearchHL", function(g)
  aucmd("InsertEnter",
    {
      group = g,
      pattern = "*",
      command = ":nohl | redraw"
    })
end)

augroup("ActiveWinCursorLine", function(g)
  -- Highlight current line only on focused window
  aucmd({ "WinEnter", "BufEnter", "InsertLeave" }, {
    group = g,
    pattern = "*",
    command = "if ! &cursorline && ! &pvw | setlocal cursorline | endif"
  })
  aucmd({ "WinLeave", "BufLeave", "InsertEnter" }, {
    group = g,
    pattern = "*",
    command = "if &cursorline && ! &pvw | setlocal nocursorline | endif"
  })
end)

-- auto-delete fugitive buffers
augroup("Fugitive", function(g)
  aucmd("BufReadPost,", {
    group = g,
    pattern = "fugitive://*",
    command = "set bufhidden=delete"
  })
end)

-- Solidity abi JSON
augroup("SolidityABI", function(g)
  aucmd({ "BufRead", "BufNewFile" }, {
    group = g,
    pattern = "*.abi",
    command = "set filetype=jsonc"
  })
end)

-- Display help|man in vertical splits and map 'q' to quit
augroup("Help", function(g)
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
augroup("DoNotAutoScroll", function(g)
  local function is_float(winnr)
    local wincfg = vim.api.nvim_win_get_config(winnr)
    if wincfg and (wincfg.external or wincfg.relative and #wincfg.relative > 0) then
      return true
    end
    return false
  end

  aucmd("BufLeave", {
    group = g,
    pattern = "*",
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
    pattern = "*",
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
