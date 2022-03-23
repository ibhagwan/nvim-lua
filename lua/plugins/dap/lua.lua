local res, dap = pcall(require, "dap")
if not res then
  return
end

local uv = vim.loop

local nvim_server
local nvim_chanID

-- both deugging and execution is done on external headless instances
-- we start a headless instance and then call ("osv").launch() which
-- in turn starts another headless instance which will be the instance
-- we connect to
-- once the instance is running we can call `:luafile <file>` in order
-- to start debugging
local function dap_server(opts)

  assert(dap.adapters.nlua,
    "nvim-dap adapter configuration for nlua not found. "..
    "Please refer to the README.md or :help osv.txt")

  -- server already started?
  if nvim_chanID then
    local pid = vim.fn.jobpid(nvim_chanID)
    vim.fn.rpcnotify(nvim_chanID, "nvim_exec_lua", [[return require"osv".stop()]])
    vim.fn.jobstop(nvim_chanID)
    if type(uv.os_getpriority(pid)) == 'number' then
      uv.kill(pid, 9)
    end
    nvim_chanID = nil
  end

  nvim_chanID = vim.fn.jobstart({vim.v.progpath, '--embed', '--headless'}, {rpc = true})
  assert(nvim_chanID, "Could not create neovim instance with jobstart!")

  local mode = vim.fn.rpcrequest(nvim_chanID, "nvim_get_mode")
  assert(not mode.blocking, "Neovim is waiting for input at startup. Aborting.")

  -- make sure OSV is loaded
  vim.fn.rpcrequest(nvim_chanID, "nvim_command", "packadd one-small-step-for-vimkind")

  nvim_server = vim.fn.rpcrequest(nvim_chanID,
    "nvim_exec_lua",
    [[return require"osv".launch(...)]],
    { opts })

  vim.wait(100)

  -- print(("Server started on port %d, channel-id %d"):format(nvim_server.port, nvim_chanID))
  return nvim_server
end

dap.adapters.nlua = function(callback, config)
  if not config.port then
    local server = dap_server()
    config.host = server.host
    config.port = server.port
  end
  callback({ type = 'server', host = config.host, port = config.port })
  if type(config.post) == 'function' then
    config.post()
  end
end


dap.configurations.lua = {
  {
    type = "nlua",
    name = "Debug current file",
    request = "attach",
    -- we acquire host/port in the adapters function above
    -- host = function() end,
    -- port = function() end,
    post = function()
      dap.listeners.after['setBreakpoints']['osv'] = function(session, body)
        assert(nvim_chanID, "Fatal: neovim RPC channel is nil!")
        vim.fn.rpcnotify(nvim_chanID, "nvim_command", "luafile " .. vim.fn.expand("%:p"))
        -- clear the lisener or we get called in any dap-config run
        dap.listeners.after['setBreakpoints']['osv'] = nil
      end
      -- for k, v in pairs(dap.listeners.after) do
      --   v["test"] = function()
      --     print(k, "called")
      --   end
      -- end
    end
  },
  {
    type = 'nlua',
    request = 'attach',
    name = "Attach to running Neovim instance",
    host = function()
      local value = vim.fn.input('Host [127.0.0.1]: ')
      if value ~= "" then
        return value
      end
      return '127.0.0.1'
    end,
    port = function()
      local val = tonumber(vim.fn.input('Port: '))
      assert(val, "Please provide a port number")
      return val
    end,
  }
}
