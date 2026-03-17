---@class opencode.provider.tmux.Opts
---@field options? string
---@field focus? boolean
---@field allow_passthrough? boolean

---@class opencode.provider.Tmux : opencode.Provider
---@field opts opencode.provider.tmux.Opts
---@field pane_id? string
---@field opencode_pid? number

---@param args string[]
---@return string
local function sys(args)
  return vim.trim(assert(vim.system(args):wait().stdout))
end

---@param pid integer
---@return [integer, string][]
local function get_process_tree(pid)
  local tree = {}
  local children = vim.api.nvim_get_proc_children(pid)
  table.insert(children, 1, pid)
  for _, child_pid in ipairs(children) do
    local ps_cmd = jit.os == "OSX"
        and { "ps", "-p", tostring(child_pid), "-o", "args=" }
        or { "ps", "-p", tostring(child_pid), "-o", "command=" }
    table.insert(tree, { child_pid, sys(ps_cmd) or "<unknown>" })
  end
  return tree
end

---@param pid integer
---@return string[]
local function get_process_commands(pid)
  return vim.tbl_map(function(x) return x[2] end, get_process_tree(pid))
end

---@param pane_pid string|nil
---@return number|nil
local function get_opencode_pid(pane_pid)
  local pid = tonumber(pane_pid)
  if not pid then return nil end

  for _, e in ipairs(get_process_tree(pid --[[@as integer]])) do
    if e[2]:match("opencode") then
      return e[1]
    end
  end

  return nil
end

local SHELLS = {
  zsh = true,
  bash = true,
  sh = true,
  fish = true,
  dash = true,
  ksh = true,
}

---@param pane_pid string|nil
---@return boolean
local function is_shell_process(pane_pid)
  local pid = tonumber(pane_pid)
  if not pid then
    return false
  end

  for _, comm in ipairs(get_process_commands(pid --[[@as integer]])) do
    local basename = comm:match("%a+$") or comm
    if not SHELLS[basename] then
      return false
    end
  end
  return true
end

---@param pane_id string
---@return boolean
local function validate_pane(pane_id)
  local pane_pid = sys({ "tmux", "display-message", "-p", "-t", pane_id, "#{pane_pid}" })
  local pid = tonumber(pane_pid)
  if not pid then
    return false
  end

  local procs = get_process_commands(pid --[[@as integer]])
  if not is_shell_process(pane_pid) then
    vim.notify(string.format(
        "Other pane has existing process [%s], close it or use a different pane.",
        table.concat(procs, ", ")),
      vim.log.levels.ERROR, { title = "opencode" })
    return false
  end
  return true
end

---@return string|nil, number|nil
local function find_opencode()
  local neovim_pane = sys({ "tmux", "display-message", "-p", "#{pane_id}" })
  local panes_output = sys({ "tmux", "list-panes", "-F", "#{pane_id}" })
  local panes = vim.split(panes_output, "\n")
  local other_pane = nil
  for _, pane in ipairs(panes) do
    pane = vim.trim(pane)
    if pane ~= neovim_pane and pane ~= "" then
      other_pane = pane
      break
    end
  end

  if not other_pane then
    return nil, nil
  end

  local pane_pid = sys({ "tmux", "display-message", "-p", "-t", other_pane, "#{pane_pid}" })
  local opencode_pid = get_opencode_pid(pane_pid)

  return other_pane, opencode_pid
end

---Provide `opencode` in a [`tmux`](https://github.com/tmux/tmux) pane in the current window.
local Tmux = {}
Tmux.__index = Tmux
Tmux.name = "tmux"
Tmux.cmd = "opencode --port"

Tmux.start = function() return Tmux:_start() end
Tmux.stop = function() return Tmux:_stop() end
Tmux.toggle = function() return Tmux:_toggle() end

---@param opts? opencode.provider.tmux.Opts
---@return opencode.provider.Tmux
function Tmux.new(opts)
  local self = setmetatable({}, Tmux)
  self.opts = opts or {}
  self.pane_id = nil
  self.opencode_pid = nil
  return self
end

---@return boolean|string, string[]?
function Tmux.health()
  if vim.fn.executable("tmux") ~= 1 then
    return "`tmux` executable not found in `$PATH`.", {
      "Install `tmux` and ensure it's in your `$PATH`.",
    }
  end

  if not vim.env.TMUX then
    return "Not running in a `tmux` session.", {
      "Launch Neovim in a `tmux` session.",
    }
  end

  return true
end

function Tmux:_start()
  local other_pane, opencode_pid = find_opencode()

  if opencode_pid then
    self.pane_id = other_pane
    self.opencode_pid = opencode_pid
    return
  end

  if not other_pane then
    other_pane = sys({ "tmux", "split-window", "-P", "-F", "#{pane_id}", "-h" })
  end

  if not other_pane or other_pane == "" then
    vim.notify("Failed create tmux pane", vim.log.levels.ERROR, { title = "opencode" })
    return
  end

  if not validate_pane(other_pane) then
    return
  end

  self.pane_id = other_pane
  sys({ "tmux", "send-keys", "-t", other_pane, " " .. self.cmd, "C-m" })

  vim.defer_fn(function()
    local _, new_pid = find_opencode()
    self.opencode_pid = new_pid
  end, 500)
end

function Tmux:_stop()
  local pane_id, opencode_pid = find_opencode()
  if not pane_id or not opencode_pid then
    self.pane_id = nil
    self.opencode_pid = nil
    return
  end

  sys({ "tmux", "send-keys", "-t", pane_id, "C-c" })
  vim.defer_fn(function()
    sys({ "tmux", "send-keys", "-t", pane_id, "C-c" })
  end, 100)

  self.pane_id = nil
  self.opencode_pid = nil
end

function Tmux:_toggle()
  local pane_id, opencode_pid = find_opencode()

  if pane_id and not opencode_pid and not validate_pane(pane_id) then
    return
  end

  if not pane_id or not opencode_pid then
    self:_start()
  else
    self.pane_id = pane_id
    self.opencode_pid = opencode_pid
    sys({ "tmux", "resize-pane", "-Z" })
  end
end

return Tmux
