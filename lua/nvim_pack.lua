local uv = vim.uv
local utils = require("utils")

local PLUGS = {}
local LOCK = nil
local LOCK_UPDATE = nil

--- @param prefix string?
--- @return string
local function get_plug_dir(prefix)
  return vim.fs.joinpath(vim.fn.stdpath("data") --[[@as string]],
    "site", "pack", prefix or "core", "opt")
end

--- @return string
local function lock_get_path()
  return vim.fs.joinpath(vim.fn.stdpath("config") --[[@as string]], "nvim-pack-lock.json")
end

local function lock_read()
  local fd = uv.fs_open(lock_get_path(), "r", 438)
  if fd then
    local stat = assert(uv.fs_fstat(fd))
    local data = assert(uv.fs_read(fd, stat.size, 0))
    assert(uv.fs_close(fd))
    LOCK = vim.json.decode(data)
  else
    LOCK = { plugins = {} }
  end
end

local function lock_write()
  if not LOCK or not LOCK_UPDATE then return end
  local path = lock_get_path()
  local fd = uv.fs_open(path, "w", 438)
  if not fd then return end
  local data = vim.json.encode(LOCK, { indent = "  ", sort_keys = true })
  assert(uv.fs_write(fd, data .. "\n"))
  assert(uv.fs_close(fd))
end

---@param spec vim.pack.Spec
---@param remote table<string, vim.pack.Spec>
---@param dev table<string, lz.n.Spec>
local function add_plugin_spec(spec, remote, dev)
  assert(type(spec) == "table" and type(spec.src) == "string")
  if spec.data and spec.data.enabled == false then return end
  local plug_name = spec.name or vim.fs.basename(spec.src)
  local stat = not spec.src:match("://") and uv.fs_stat(spec.src) or nil
  if stat then
    -- symlink local plugins
    local plug_dir = vim.fs.joinpath(get_plug_dir(), plug_name)
    -- remove vim.pack managed dir/symlink
    if uv.fs_stat(plug_dir) then vim.fs.rm(plug_dir, { recursive = true }) end
    -- ensure dev plugin dir exists and link
    local dev_dir = get_plug_dir("dev")
    if not uv.fs_stat(dev_dir) then vim.fn.mkdir(dev_dir, "p") end
    uv.fs_symlink(spec.src, vim.fs.joinpath(dev_dir, plug_name), { dir = true })
    -- setup lazy loading for local packages
    table.insert(dev, vim.tbl_extend("keep", { plug_name }, spec.data))
    -- remove from "nvim-pack-lock.json" if needed
    -- this avoids the download prompt for local plugins that were cloned
    -- on a different machine (and thus stored in the lockfile)
    if LOCK and LOCK.plugins[plug_name] then
      LOCK.plugins[plug_name] = nil
      LOCK_UPDATE = true
    end
  else
    table.insert(remote, spec)
    -- plugin tbl for Pack cmd completion (local plugins excluded)
    table.insert(PLUGS, plug_name)
  end
end

---@param modname string
---@param remote table<string, vim.pack.Spec>
---@param dev table<string, lz.n.Spec>
local function import_modname(modname, remote, dev)
  local ok, mod = pcall(require, modname)
  if not ok then
    local err = type(mod) == "string" and ": " .. mod or ""
    utils.warn("Failed to load module '" .. modname .. err)
    return
  end
  if type(mod) ~= "table" then
    utils.error("Invalid plugin spec module '" .. modname .. "' of type '" .. type(mod) .. "'")
    return
  end
  if mod.src then
    add_plugin_spec(mod, remote, dev)
  else
    -- Nested plugin setup
    vim.iter(mod):each(function(sp) add_plugin_spec(sp, remote, dev) end)
  end
end

---Import plugin specs from the "plugins" directory
---returns separate vim.pack for remote plugins (git/http/ssh) and lz.n.Spec for local
---filesystem (dev) plugins, removes stale remote plugins if they exist locally, this
---prevents a vim.pack popup for downloading the plugin or a "corrupted loc data" msg
---@return vim.pack.Spec[], lz.n.Spec[]
local function enum_plugin_specs()
  lock_read()
  local remote, dev = {}, {}
  local modpath = vim.fs.joinpath(unpack(vim.split("plugins", ".", { plain = true })) --[[@as string]])
  local import_root = vim.api.nvim_get_runtime_file(vim.fs.joinpath("lua", modpath .. ".lua"), true)
  if #import_root == 1 then
    import_modname(modpath, remote, dev)
  end
  local import_dir = vim.api.nvim_get_runtime_file(vim.fs.joinpath("lua", modpath), true)
  if #import_dir > 0 then
    local dir = import_dir[1]
    local handle = uv.fs_scandir(dir)
    while handle do
      local name, ty = uv.fs_scandir_next(handle)
      if not name then break end
      local path = vim.fs.joinpath(dir, name)
      ty = ty or assert(uv.fs_stat(path)).type
      if not name then
        break
        -- XXX: "link" is required to support Nix.
        -- It seems to break in tests with with local symlinks
      elseif (ty == "file" or ty == "link") and name:sub(-4) == ".lua" then
        local submodname = name:sub(1, -5)
        import_modname(modpath .. "." .. submodname, remote, dev)
      elseif ty == "directory" and uv.fs_stat(vim.fs.joinpath(path, "init.lua")) then
        import_modname(modpath .. "." .. name, remote, dev)
      end
    end
  end
  lock_write()
  return remote, dev
end

-- Read the plugin specs before we add the first package so
-- we remove the local dev packages from the lockfile
local pack_plugs, dev_plugs = enum_plugin_specs()

-- Bootstrap lz.n via vim.pack
vim.pack.add({ "https://github.com/lumen-oss/lz.n" })

-- Verify the user elected to install lz.n and it can be loaded
local ok, lzn = pcall(require, "lz.n") ---@cast lzn lz.n.PluginBase
if not ok then return end

---@diagnostic disable-next-line: param-type-mismatch, need-check-nil
if #dev_plugs > 0 then lzn.load(dev_plugs) end

vim.pack.add(pack_plugs, { load = lzn.load } --[[@as vim.pack.keyset.add]])

-- vim.pack management user command
vim.api.nvim_create_user_command("Pack", function(e)
  local cmd = #e.fargs > 0 and table.remove(e.fargs, 1) or "status"
  local plugins = #e.fargs > 0 and e.fargs or nil
  if cmd == "status" or cmd == "st" then
    vim.pack.update(plugins, { offline = true })
  elseif cmd == "update" or cmd == "up" then
    vim.pack.update(plugins, {})
  elseif cmd == "restore" or cmd == "rs" then
    vim.pack.update(plugins, { target = "lockfile" })
  elseif cmd == "remove" or cmd == "rm" or cmd == "delete" or cmd == "del" then
    if plugins and #plugins > 0 then
      vim.pack.del(plugins)
    else
      utils.warn("must specify plugin(s)", cmd)
    end
  else
    utils.warn("unknown command '%s'", cmd)
  end
end, {
  nargs = "*",
  range = true,
  complete = function(_, line)
    local fargs = vim.split(line, "%s+")
    if #fargs[#fargs] == 0 then table.remove(fargs) end
    return #fargs > 1 and PLUGS or { "status", "update", "restore", "remove", "delete" }
  end
})
