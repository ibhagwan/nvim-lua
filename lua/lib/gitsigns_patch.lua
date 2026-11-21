-- Runtime patch for gitsigns clean-filter support (git-crypt etc.).
--
-- Gitsigns compares the working tree against raw index blobs. When a clean
-- filter is configured, the index holds transformed data and every line
-- appears modified. These patches mirror the fix in commit 23b6a5d and are
-- applied at runtime so the fix works when gitsigns is loaded from upstream.
-- The loaded API is checked first and a warning is emitted instead of applying
-- the patch when upstream has changed in a way the patch does not expect.
local M = {}

---Recover the path from a "<rev>:<path>" git object spec.
---@param object string?
---@return string?
local function infer_path(object)
  if type(object) ~= "string" then
    return
  end

  if object:sub(1, 1) == ":" then
    -- Index stage spec, e.g. ":0:path".
    local path = object:match("^:%d+:(.+)$")
    if path then
      return path
    end
    -- Bare index spec, e.g. ":path". Exclude ":/message" rev searches.
    if object:sub(1, 2) ~= ":/" then
      return object:sub(2)
    end
    return
  end

  -- Revision spec, e.g. "HEAD:path" or "sha:path". Git refs cannot contain
  -- colons, so the first colon separates the revision from the path.
  return object:match("^[^:]+:(.+)$")
end

---@param issues string[]
---@param fmt string
local function add_issue(issues, fmt, ...)
  issues[#issues + 1] = string.format(fmt, ...)
end

---@param issues string[]
---@param name string
---@return table?
local function require_module(issues, name)
  local ok, mod = pcall(require, name)
  if not ok then
    add_issue(issues, "cannot load %s: %s", name, tostring(mod))
    return
  end
  if type(mod) ~= "table" then
    add_issue(issues, "%s did not return a table", name)
    return
  end
  return mod
end

---Verify a replaced function still has the fixed signature the patch expects.
---@param issues string[]
---@param label string
---@param tbl table?
---@param name string
---@param max_params integer Maximum number of parameters, including `self`.
local function expect_function(issues, label, tbl, name, max_params)
  local fn = tbl and tbl[name]
  if type(fn) ~= "function" then
    add_issue(issues, "%s is missing", label)
    return
  end

  local info = debug.getinfo(fn, "u")
  if not info then
    return
  end

  if info.isvararg then
    add_issue(issues, "%s is variadic; patch expects a fixed signature", label)
  end

  if info.nparams and info.nparams > max_params then
    add_issue(
      issues, "%s accepts %d parameters; patch expects at most %d", label, info.nparams, max_params
    )
  end
end

---Verify a function the patch calls still exists.
---@param issues string[]
---@param label string
---@param tbl table?
---@param name string
local function expect_function_exists(issues, label, tbl, name)
  if type(tbl and tbl[name]) ~= "function" then
    add_issue(issues, "%s is missing", label)
  end
end

---Check the loaded gitsigns API against the assumptions in this patch.
---@return string[] issues Empty when the patch is compatible.
function M.check()
  local issues = {}

  local git = require_module(issues, "gitsigns.git")
  local Repo = require_module(issues, "gitsigns.git.repo")
  local cache = require_module(issues, "gitsigns.cache")
  local actions = require_module(issues, "gitsigns.actions")
  local async = require_module(issues, "gitsigns.async")
  local manager = require_module(issues, "gitsigns.manager")
  local message = require_module(issues, "gitsigns.message")
  local util = require_module(issues, "gitsigns.util")
  local hunks = require_module(issues, "gitsigns.hunks")
  local unified = require_module(issues, "gitsigns.unified")
  local diffthis = require_module(issues, "gitsigns.actions.diffthis")
  local log = require_module(issues, "gitsigns.debug.log")
  local errors = require_module(issues, "gitsigns.git.errors")

  local Obj = git and git.Obj
  local CacheEntry = cache and cache.CacheEntry

  if git and type(Obj) ~= "table" then
    add_issue(issues, "gitsigns.git Obj is missing")
  end
  if cache and type(CacheEntry) ~= "table" then
    add_issue(issues, "gitsigns.cache CacheEntry is missing")
  end

  if Repo then
    expect_function(issues, "Repo:command", Repo, "command", 3)
    expect_function(issues, "Repo:get_show_text", Repo, "get_show_text", 4)
    expect_function(issues, "Repo:get_show_text_at_revision", Repo, "get_show_text_at_revision", 4)
    expect_function(issues, "Repo:check_attr", Repo, "check_attr", 3)
    expect_function(issues, "Repo:hash_object", Repo, "hash_object", 3)
    expect_function(issues, "Repo:update_index", Repo, "update_index", 5)
    expect_function(issues, "Repo:diff_rename_status", Repo, "diff_rename_status", 3)
    expect_function(issues, "Repo:log_rename_status", Repo, "log_rename_status", 3)
  end

  if Obj then
    expect_function(issues, "Obj:get_show_text", Obj, "get_show_text", 3)
    expect_function(issues, "Obj:stage_hunks", Obj, "stage_hunks", 3)
    expect_function(issues, "Obj:ensure_file_in_index", Obj, "ensure_file_in_index", 1)
  end

  if CacheEntry then
    expect_function(issues, "CacheEntry:get_hunk", CacheEntry, "get_hunk", 4)
    expect_function(issues, "CacheEntry:wait_for_hunks", CacheEntry, "wait_for_hunks", 2)
    expect_function(issues, "CacheEntry:get_hunks", CacheEntry, "get_hunks", 3)
    expect_function(issues, "CacheEntry:get_cursor_hunk", CacheEntry, "get_cursor_hunk", 2)
    expect_function(issues, "CacheEntry:schedule", CacheEntry, "schedule", 2)
    expect_function(issues, "CacheEntry:invalidate", CacheEntry, "invalidate", 2)
  end

  if actions then
    expect_function(issues, "actions.stage_buffer", actions, "stage_buffer", 1)
  end

  if async then
    expect_function_exists(issues, "async.run", async, "run")
    expect_function(issues, "async.wrap", async, "wrap", 2)
  end

  if manager then
    expect_function_exists(issues, "manager.update", manager, "update")
  end

  if message then
    expect_function_exists(issues, "message.error", message, "error")
  end

  if util then
    expect_function(issues, "util.buf_lines", util, "buf_lines", 2)
    expect_function(issues, "util.iconv", util, "iconv", 3)
    if type(util.Path) ~= "table" then
      add_issue(issues, "gitsigns.util Path is missing")
    else
      expect_function(issues, "util.Path.exists", util.Path, "exists", 1)
    end
  end

  if hunks then
    expect_function(issues, "hunks.apply_to_text", hunks, "apply_to_text", 3)
    expect_function(issues, "hunks.create_partial_hunk", hunks, "create_partial_hunk", 3)
  end

  if unified then
    expect_function(issues, "unified.is_active", unified, "is_active", 2)
  end

  if diffthis then
    expect_function_exists(issues, "actions.diffthis.update", diffthis, "update")
  end

  if log then
    expect_function_exists(issues, "log.dprint", log, "dprint")
    expect_function_exists(issues, "log.dprintf", log, "dprintf")
  end

  if errors then
    if type(errors.e) ~= "table" then
      add_issue(issues, "gitsigns.git.errors e table is missing")
    else
      for _, key in ipairs({ "path_does_not_exist", "path_exist_on_disk_but_not_in" }) do
        if type(errors.e[key]) ~= "string" then
          add_issue(issues, "gitsigns.git.errors.e.%s is missing", key)
        end
      end
    end
  end

  return issues
end

local function patch_repo()
  local Repo = require("gitsigns.git.repo")
  ---@diagnostic disable-next-line: undefined-field
  if Repo._filter_patch then
    return
  end
  ---@diagnostic disable-next-line: inject-field
  Repo._filter_patch = true

  local errors = require("gitsigns.git.errors")
  local log = require("gitsigns.debug.log")
  local util = require("gitsigns.util")

  ---@async
  ---@param object string
  ---@param encoding? string
  ---@param path? string Working tree path used to resolve attributes and filters.
  ---@return string[] stdout
  ---@return string? stderr
  ---@return boolean filtered True when git filters were applied.
  ---@diagnostic disable-next-line: duplicate-set-field
  function Repo:get_show_text(object, encoding, path)
    -- Some upstream call sites pass only "<rev>:<path>". Recover the path so
    -- git can resolve the matching attributes and filters.
    path = path or infer_path(object)

    local stdout, stderr
    local filtered = false

    if path then
      stdout, stderr = self:command(
        { "cat-file", "--filters", "--path=" .. path, object },
        { text = false, ignore_error = true }
      )
      if stderr then
        -- Fall back to the raw blob when filters cannot be applied (for
        -- example when the working tree is not available).
        stdout, stderr = self:command({ "show", object }, { text = false, ignore_error = true })
      else
        filtered = true
      end
    else
      stdout, stderr = self:command({ "show", object }, { text = false, ignore_error = true })
    end

    if encoding and encoding ~= "" and encoding ~= "utf-8" then
      -- Decode line endings with the text before splitting into UTF-8 lines.
      local text = util.iconv(table.concat(stdout, "\n"), encoding, "utf-8")
      stdout = vim.split(text, "\n")
    end

    return stdout, stderr, filtered
  end

  ---@async
  ---@param revision string
  ---@param relpath string
  ---@param encoding? string
  ---@return string[] stdout
  ---@return string? stderr
  ---@return boolean filtered
  ---@diagnostic disable-next-line: duplicate-set-field
  function Repo:get_show_text_at_revision(revision, relpath, encoding)
    ---@diagnostic disable: redundant-parameter
    local stdout, stderr, filtered = self:get_show_text(
      revision .. ":" .. relpath, encoding, relpath
    )
    ---@diagnostic enable: redundant-parameter

    if stderr
      and (stderr:match(errors.e.path_does_not_exist)
        or stderr:match(errors.e.path_exist_on_disk_but_not_in)) then
      log.dprintf("%s not found in %s looking for renames", relpath, revision)
      local old_path = self:diff_rename_status(revision, true)[relpath]
        or self:log_rename_status(revision, relpath)
      if old_path then
        log.dprintf("found rename %s -> %s", old_path, relpath)
        ---@diagnostic disable: redundant-parameter
        stdout, stderr, filtered = self:get_show_text(
          revision .. ":" .. old_path, encoding, old_path
        )
        ---@diagnostic enable: redundant-parameter
      end
    end

    ---@cast filtered boolean
    return stdout, stderr, filtered
  end
end

local function patch_obj()
  local Obj = require("gitsigns.git").Obj
  if Obj._filter_patch then
    return
  end
  Obj._filter_patch = true

  local async = require("gitsigns.async")
  local log = require("gitsigns.debug.log")

  ---@async
  ---@param revision? string
  ---@param relpath? string
  ---@return string[] stdout
  ---@return string? stderr
  ---@return boolean? filtered
  ---@diagnostic disable-next-line: duplicate-set-field
  function Obj:get_show_text(revision, relpath)
    relpath = relpath or self.relpath
    if revision and not relpath then
      log.dprint("no relpath")
      return {}
    end

    if not revision and (self.object_missing or not self.object_name) then
      log.dprint("no base object")
      return { "" }
    end

    local stdout, stderr, filtered
    ---@cast stdout string[]
    local encoding = self.encoding
    ---@cast encoding string
    if revision then
      stdout, stderr, filtered = self.repo:get_show_text_at_revision(
        revision, assert(relpath), encoding
      )
    else
      ---@diagnostic disable: redundant-parameter
      stdout, stderr, filtered = self.repo:get_show_text(
        assert(self.object_name), encoding, self.relpath
      )
      ---@diagnostic enable: redundant-parameter
    end

    if not filtered and not self.i_crlf and self.w_crlf then
      -- Add cr, but not to the newline at the end of file.
      for i = 1, #stdout - 1 do
        stdout[i] = stdout[i] .. "\r"
      end
    end

    return stdout, stderr, filtered
  end

  local function autocmd_changed(file)
    vim.schedule(function()
      vim.api.nvim_exec_autocmds("User", {
        pattern = "GitSignsChanged",
        modeline = false,
        data = { file = file },
      })
    end)
  end

  local sleep = async.wrap(2, function(duration, cb)
    vim.defer_fn(cb, duration)
  end)

  ---Stage hunks for files that have a clean filter. The index contains the
  ---filtered blob, so patches cannot be applied to it directly. Instead, apply
  ---the hunks to the smudged index text and let `hash-object --path` run the
  ---clean filter again when writing the new object.
  ---@async
  ---@private
  ---@param hunks Gitsigns.Hunk.Hunk[]
  ---@param invert? boolean
  ---@return string? err
  ---@diagnostic disable-next-line: duplicate-set-field
  function Obj:stage_hunks_filtered(hunks, invert)
    local relpath = assert(self.relpath)
    local text, stderr, filtered = self:get_show_text()

    if not filtered then
      return stderr or "failed to apply git filters"
    end

    local Hunks = require("gitsigns.hunks")

    local ok, err = pcall(function()
      -- Hunks are ordered by their position in the original text. Apply them in
      -- reverse so earlier changes do not shift the ranges of later hunks.
      for i = #hunks, 1, -1 do
        text = Hunks.apply_to_text(text, hunks[i], invert)
      end

      local new_object = self.repo:hash_object(relpath, text)
      self.repo:update_index(self.mode_bits, new_object, relpath)
    end)

    if not ok then
      return tostring(err)
    end

    -- Staging operations cause IO of the git directory so wait some time
    -- for the changes to settle.
    sleep(100)

    autocmd_changed(self.file)
  end

  local stage_hunks = Obj.stage_hunks

  ---@async
  ---@param hunks Gitsigns.Hunk.Hunk[]
  ---@param invert? boolean
  ---@return string? err
  ---@diagnostic disable-next-line: duplicate-set-field
  function Obj:stage_hunks(hunks, invert)
    self:ensure_file_in_index()

    local relpath = assert(self.relpath)
    local attrs = self.repo:check_attr("filter", { relpath })
    ---@cast attrs table<string, string>
    ---@diagnostic disable-next-line: undefined-field
    local filter = attrs[relpath]

    if filter and filter ~= "unspecified" and filter ~= "unset" then
      return self:stage_hunks_filtered(hunks, invert)
    end

    return stage_hunks(self, hunks, invert)
  end
end

local function patch_cache()
  local CacheEntry = require("gitsigns.cache").CacheEntry
  if CacheEntry._filter_patch then
    return
  end
  CacheEntry._filter_patch = true

  local util = require("gitsigns.util")

  ---@async
  ---@param range? [integer, integer]
  ---@param greedy? boolean
  ---@param staged? boolean
  ---@return Gitsigns.Hunk.Hunk?
  function CacheEntry:get_hunk(range, greedy, staged)
    local Hunks = require("gitsigns.hunks")

    if not self:wait_for_hunks(staged) then
      return
    end

    local hunks = self:get_hunks(greedy, staged)

    if not range then
      return (self:get_cursor_hunk(hunks))
    end

    table.sort(range)
    local top, bot = range[1], range[2]
    local partial_hunks = hunks or {}
    ---@cast partial_hunks Gitsigns.Hunk.Hunk[]
    local hunk = Hunks.create_partial_hunk(partial_hunks, top, bot)
    if not hunk then
      return
    end

    local compare_text = assert(self.compare_text)

    if staged then
      ---@type integer
      local staged_top = top
      ---@type integer
      local staged_bot = bot
      for _, h in ipairs(assert(self.hunks)) do
        if top > h.vend then
          staged_top = (staged_top - (h.added.count - h.removed.count)) --[[@as integer]]
        end
        if bot > h.vend then
          staged_bot = (staged_bot - (h.added.count - h.removed.count)) --[[@as integer]]
        end
      end

      hunk.added.lines = vim.list_slice(compare_text, staged_top, staged_bot)
      hunk.removed.lines = vim.list_slice(
        assert(self.compare_text_head), hunk.removed.start,
        hunk.removed.start + hunk.removed.count - 1
      )
    else
      -- Use util.buf_lines() rather than nvim_buf_get_lines() so CR is retained
      -- for dos buffers.
      hunk.added.lines = vim.list_slice(util.buf_lines(self.bufnr), top, bot)
      hunk.removed.lines = vim.list_slice(
        compare_text, hunk.removed.start, hunk.removed.start + hunk.removed.count - 1
      )
    end
    return hunk
  end
end

local function patch_actions()
  local actions = require("gitsigns.actions")
  ---@diagnostic disable-next-line: undefined-field
  if actions._filter_patch then
    return
  end
  ---@diagnostic disable-next-line: inject-field
  actions._filter_patch = true

  local async = require("gitsigns.async")
  local cache = require("gitsigns.cache").cache
  local manager = require("gitsigns.manager")
  local message = require("gitsigns.message")
  local util = require("gitsigns.util")

  local api = vim.api

  local function async_run(callback, func, ...)
    local task = async.run(func, ...)
    if callback and type(callback) == "function" then
      task:await(callback)
    else
      task:raise_on_error()
    end
    return task
  end

  ---@async
  ---@param bufnr integer
  local function update(bufnr)
    local bcache = cache[bufnr]
    if not bcache then
      return
    end

    manager.update(bufnr)
    if not bcache:schedule() then
      return
    end
    if vim.wo.diff or require("gitsigns.unified").is_active(bufnr) then
      require("gitsigns.actions.diffthis").update(bufnr)
    end
  end

  ---Stage all hunks in current buffer.
  ---
  ---Attributes:
  ---- {async}
  ---
  ---@param callback? fun(err?: string)
  ---@diagnostic disable-next-line: duplicate-set-field
  function actions.stage_buffer(callback)
    async_run(callback, function()
      local bufnr = api.nvim_get_current_buf()
      local bcache = cache[bufnr]
      if not bcache then
        return
      end

      bcache.git_obj:lock(function()
        -- Only process files with existing hunks
        local hunks = bcache.hunks
        if not hunks or #hunks == 0 then
          print("No unstaged changes in file to stage")
          return
        end

        if not util.Path.exists(bcache.git_obj.file) then
          print("Error: Cannot stage file. Please add it to the working tree.")
          return
        end

        local err = bcache.git_obj:stage_hunks(hunks)
        if err then
          message.error(err)
          return
        end

        for _, hunk in ipairs(hunks) do
          table.insert(bcache.staged_diffs, hunk)
        end

        -- Everything was staged, so the index now matches the buffer.
        if bcache.compare_text then
          bcache.compare_text = util.buf_lines(bufnr)
        end
      end)

      bcache:invalidate()
      update(bufnr)
    end)
  end
end

function M.apply()
  if M._applied then
    return true
  end

  local issues = M.check()
  if #issues > 0 then
    local u = require("utils")
    u.warn(
      "gitsigns clean-filter patch not applied; upstream API is incompatible:\n%s\n"
        .. "Update lua/lib/gitsigns_patch.lua.", table.concat(issues, "\n")
    )
    return false
  end

  patch_repo()
  patch_obj()
  patch_cache()
  patch_actions()
  M._applied = true
  return true
end

return M
