local res, dap_python = pcall(require, "dap-python")
if not res then
  return
end

local prefix = ""
local bin_python = "/bin/python"

if vim.fn.executable("pyenv") == 1 then
  local out = vim.fn.systemlist({ "pyenv", "prefix" })
  if vim.v.shell_error == 0 and type(out[1]) == "string" then
    -- nvim-dap-python uses `os.getenv("VIRTUAL_ENV")`
    prefix = out[1]
    vim.env.VIRTUAL_ENV = out[1]
  end
else
  -- check mason registry
  local ok, pkg = pcall(function()
    return require("mason-registry").get_package("debugpy")
  end)
  if ok and pkg and pkg:is_installed() then
    prefix = pkg:get_install_path() .. "/venv"
  end
end

dap_python.setup(prefix .. bin_python)
dap_python.test_runner = prefix .. "/bin/pytest"

local function getpid()
  local pid = require("dap.utils").pick_process({ filter = "python" })
  if type(pid) == "thread" then
    -- returns a coroutine.create due to it being run from fzf-lua ui.select
    -- start the coroutine and wait for `coroutine.resume` (user selection)
    coroutine.resume(pid)
    pid = coroutine.yield(pid)
  end
  return pid
end

table.insert(require("dap").configurations.python, 4, {
  type = "python",
  request = "attach",
  name = "Attach to process",
  connect = function()
    -- https://github.com/microsoft/debugpy/#attaching-to-a-running-process-by-id
    local port = 5678
    local pid = getpid()
    local out = vim.fn.systemlist({ prefix .. bin_python, "-m", "debugpy",
      "--listen", "localhost:" .. tostring(port), "--pid", tostring(pid) })
    assert(vim.v.shell_error == 0, table.concat(out, "\n"))
    return { port = port }
  end,
})
