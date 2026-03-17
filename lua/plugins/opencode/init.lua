local M = {
  "NickvanDyke/opencode.nvim",
  dependencies = {},
}

M.init = function()
  vim.keymap.set({ "n", "x" }, "<leader>oa",
    function() require("opencode").ask("@this: ", { submit = true }) end, { desc = "Ask opencode" })
  vim.keymap.set({ "n", "x" }, "<leader>o?", function() require("opencode").select() end,
    { desc = "Execute opencode action…" })
  vim.keymap.set({ "n", "x" }, "<leader>ox", function() require("opencode").stop() end,
    { desc = "Execute opencode action…" })
  vim.keymap.set({ "n", "t" }, "<leader>op", function() require("opencode").prompt() end,
    { desc = "Prompt opencode" })
  vim.keymap.set({ "n", "t" }, "<leader>oo", function() require("opencode").toggle() end,
    { desc = "Toggle opencode" })

  vim.keymap.set({ "n", "x" }, "<leader>ov",
    function() return require("opencode").operator("@this ") end,
    { expr = true, desc = "Add range to opencode" })
  vim.keymap.set("n", "<leader>ol",
    function() return require("opencode").operator("@this ") .. "_" end,
    { expr = true, desc = "Add line to opencode" })

  vim.keymap.set({ "n", "x" }, "<leader>ou",
    function() require("opencode").command("session.half.page.up") end,
    { desc = "opencode half page up" })
  vim.keymap.set({ "n", "x" }, "<leader>od",
    function() require("opencode").command("session.half.page.down") end,
    { desc = "opencode half page down" })
  vim.keymap.set({ "n", "x" }, "<leader>ob",
    function() require("opencode").command("session.page.up") end,
    { desc = "opencode page up" })
  vim.keymap.set({ "n", "x" }, "<leader>of",
    function() require("opencode").command("session.page.down") end,
    { desc = "opencode half page down" })


  vim.keymap.set({ "n", "x" }, "<leader>on",
    function() require("opencode").command("session.new") end,
    { desc = "opencode new session" })
  vim.keymap.set({ "n", "x" }, "<leader>os",
    function() require("opencode").command("session.list") end,
    { desc = "opencode session list" })
  vim.keymap.set({ "n", "x" }, "<leader>ou",
    function() require("opencode").command("session.undo") end,
    { desc = "opencode session undo" })
  vim.keymap.set({ "n", "x" }, "<leader>or",
    function() require("opencode").command("session.redo") end,
    { desc = "opencode session redo" })
  vim.keymap.set({ "n", "x" }, "<leader>oc",
    function() require("opencode").command("session.compact") end,
    { desc = "opencode session compact" })
end

M.config = function()
  ---@type opencode.Opts
  vim.g.opencode_opts = {
    server = require("plugins.opencode.tmux"),
  }

  -- required for `opts.events.reload`.
  vim.o.autoread = true
end

return M
