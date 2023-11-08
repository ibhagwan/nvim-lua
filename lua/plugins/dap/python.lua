local res, dap = pcall(require, "dap")
if not res then
  return
end

local prefix = ""

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

require("dap-python").setup(prefix .. "/bin/python")
require("dap-python").test_runner = prefix .. "/bin/pytest"
