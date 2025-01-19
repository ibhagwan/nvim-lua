local M = {}

M._key = "<C-\\>"
M._desc = "Toggle terminal"
M._hl = "iBhagwanTerm"
M._size = 0.4

local function ensure_hl()
  if vim.tbl_isempty(vim.api.nvim_get_hl(0, { name = M._hl })) then
    local norm = vim.api.nvim_get_hl(0, { name = "Normal" })
    vim.api.nvim_set_hl(0, M._hl, {
      default = false, fg = norm.fg, bg = "#1b2738", ctermfg = norm.ctermfg, ctermbg = "NONE"
    })
  end
  return M._hl
end

local termopen = vim.fn.has("nvim-0.11") ~= 1 and vim.fn.termopen
    or function(cmd, opts)
      opts = opts or {}
      opts.term = true
      return vim.fn.jobstart(cmd, opts)
    end

M.toggleterm = function()
  if not M._buf or not vim.api.nvim_buf_is_valid(M._buf) then
    M._buf = vim.api.nvim_create_buf(false, false)
  end

  M._win = vim.iter(vim.fn.win_findbuf(M._buf)):find(function(b_wid)
    return vim.iter(vim.api.nvim_tabpage_list_wins(0)):any(function(t_wid)
      return b_wid == t_wid
    end)
  end) or (function()
    M._new = true
    local height = math.floor(vim.o.lines * M._size)
    vim.cmd("botright split | resize " .. tostring(height))
    local win = vim.api.nvim_get_current_win()
    vim.api.nvim_win_set_buf(win, M._buf)
    local hl = ensure_hl()
    vim.wo[win].winhl = string.format("Normal:%s,NormalNC:%s", hl, hl)
    return win
  end)()

  if M._new or vim.api.nvim_win_get_config(M._win).hide then
    M._new = nil
    vim.api.nvim_win_set_config(M._win, { hide = false })
    vim.api.nvim_set_current_win(M._win)
    if vim.bo[M._buf].channel <= 0 then
      termopen({ vim.o.shell })
      vim.keymap.set({ "n", "t" }, M._key, M.toggleterm, { buffer = M._buf, desc = M._desc })
    end
    vim.cmd("startinsert")
  else
    vim.api.nvim_win_call(M._win, function()
      vim.cmd.hide()
    end)
    vim.api.nvim_set_current_win(vim.fn.win_getid(vim.fn.winnr("#")))
  end
end

vim.keymap.set("n", M._key, M.toggleterm, { desc = M._desc })


return M
