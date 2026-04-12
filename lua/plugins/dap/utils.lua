local utils = require("utils")

local M = {}

local BP_DB_PATH = vim.fn.stdpath("data") .. "/dap_bps.json"

M.load_bps = function()
  local fp = io.open(BP_DB_PATH, "r")
  if not fp then
    utils.info("No breakpoint json-db present.")
    return
  end
  local json = fp:read("*a")
  local ok, bps = pcall(vim.json.decode, json)
  if not ok or type(bps) ~= "table" then
    utils.warn("Error parsing breakpoint json-db: %s", bps)
    return
  end
  local path2bufnr = {}
  for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
    local path = vim.api.nvim_buf_get_name(bufnr)
    if type(bps[path]) == "table" and not vim.tbl_isempty(bps[path]) then
      path2bufnr[path] = bufnr
    end
  end
  if vim.tbl_isempty(path2bufnr) then return end
  local bp_count = 0
  for path, buf_bps in pairs(bps) do
    local bufnr = tonumber(path2bufnr[path])
    if bufnr then
      for _, bp in pairs(buf_bps) do
        bp_count = bp_count + 1
        local line = bp.line
        local opts = {
          condition = bp.condition,
          log_message = bp.logMessage,
          hit_condition = bp.hitCondition,
        }
        require("dap.breakpoints").set(opts, bufnr, line)
      end
    end
  end
  local session = require("dap").session()
  if session and bp_count > 0 then
    session:set_breakpoints(require("dap.breakpoints").get())
  end
  utils.info("Loaded %d breakpoints in %d bufers.", bp_count, vim.tbl_count(path2bufnr))
end

M.store_bps = function()
  local fp = io.open(BP_DB_PATH, "r")
  local json = fp and fp:read("*a") or "{}"
  local ok, bps = pcall(vim.json.decode, json)
  if not ok or type(bps) ~= "table" then
    bps = {}
  end
  local bp_count = 0
  local breakpoints_by_buf = require("dap.breakpoints").get()
  for bufnr, buf_bps in pairs(breakpoints_by_buf) do
    bp_count = bp_count + #buf_bps
    bps[vim.api.nvim_buf_get_name(bufnr)] = buf_bps
  end
  for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
    if not breakpoints_by_buf[bufnr] then
      local path = vim.api.nvim_buf_get_name(bufnr)
      bps[path] = nil
    end
  end
  fp = io.open(BP_DB_PATH, "w")
  if fp then
    fp:write(vim.json.encode(bps))
    fp:close()
    utils.info("Stored %d breakpoints in %d bufers.", bp_count, vim.tbl_count(breakpoints_by_buf))
  end
end

M.pick_exec = function()
  local fzf = require("fzf-lua")
  return coroutine.create(function(dap_co)
    local dap_abort = function() coroutine.resume(dap_co, require("dap").ABORT) end
    local dap_run = function(exec)
      if type(exec) == "string" and vim.uv.fs_stat(exec) then
        -- Make full path
        exec = vim.fn.fnamemodify(exec, ":p")
        coroutine.resume(dap_co, exec)
      else
        if exec ~= "" then
          require("utils").warn("'%s' is not executable, aborting.", exec)
        end
        dap_abort()
      end
    end
    fzf.files({
      cwd = vim.uv.cwd(),
      -- cwd_header = true,
      -- cwd_prompt = false,
      -- prompt = "DAP: Select Executable> ",
      git_icons = false,
      cmd = "fd --color=never --no-ignore --type x --hidden --follow --exclude .git",
      header = (":: %s to execute prompt"):format(fzf.utils.ansi_codes["yellow"]("<Ctrl-e>")),
      winopts = {
        width = 0.65,
        height = 0.45,
        preview = { hidden = "hidden" },
        title = { { " DAP: Select Executable to Debug ", "Cursor" } },
        title_pos = "center",
      },
      actions = {
        ["esc"] = dap_abort,
        ["ctrl-c"] = dap_abort,
        ["ctrl-g"] = false,
        ---@diagnostic disable-next-line: undefined-field
        ["ctrl-e"] = function(_, opts) dap_run(opts.last_query) end,
        ["default"] = function(sel)
          if not sel[1] then
            dap_abort()
          else
            dap_run(fzf.path.entry_to_file(sel[1]).path)
          end
        end,
      },
    })
  end)
end

M.pick_proc = function(fzflua_opts, getproc_opts)
  local fzf = require("fzf-lua")
  return coroutine.create(function(dap_co)
    local dap_abort = function() coroutine.resume(dap_co, require("dap").ABORT) end
    local procs = require("dap.utils").get_processes(getproc_opts)
    fzf.fzf_exec(
      function(fzf_cb)
        for _, p in pairs(procs) do
          fzf_cb(string.format("[%d] %s", p.pid, p.name))
        end
        fzf_cb()
      end,
      vim.tbl_deep_extend("keep", fzflua_opts or {}, {
        winopts = {
          preview = { hidden = "hidden" },
          title = { { " DAP: Select Process to Debug ", "Cursor" } },
          title_pos = "center",
        },
        actions = {
          ["esc"] = dap_abort,
          ["ctrl-c"] = dap_abort,
          ["default"] = function(sel)
            if not sel[1] then
              dap_abort()
            else
              local pid = tonumber(sel[1]:match("^%[(%d+)%]"))
              coroutine.resume(dap_co, pid)
            end
          end,
        },
      }))
  end)
end

return M
