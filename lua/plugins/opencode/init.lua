return {
  src = "https://github.com/NickvanDyke/opencode.nvim",
  data = {
    lazy = true,
    beforeAll = function()
      local map = function(modes, lhs, rhs, opts)
        vim.keymap.set(modes, lhs, function(...)
          require("lz.n").trigger_load("opencode.nvim")
          rhs(...)
        end, opts)
      end
      -- Opencode keymaps
      map({ "n", "x" }, "<leader>oa",
        function() require("opencode").ask("@this: ", { submit = true }) end,
        { desc = "Ask opencode" })
      map({ "n", "x" }, "<leader>o?",
        function() require("opencode").select() end,
        { desc = "Execute opencode action…" })
      map({ "n", "x" }, "<leader>ox",
        function() require("opencode").stop() end,
        { desc = "Execute opencode action…" })
      map({ "n", "t" }, "<leader>op",
        function() require("opencode").prompt() end,
        { desc = "Prompt opencode" })
      map({ "n", "t" }, "<leader>oo",
        function() require("opencode").toggle() end,
        { desc = "Toggle opencode" })
      map({ "n", "x" }, "<leader>ov",
        function() return require("opencode").operator("@this ") end,
        { expr = true, desc = "Add range to opencode" })
      map("n", "<leader>ol",
        function() return require("opencode").operator("@this ") .. "_" end,
        { expr = true, desc = "Add line to opencode" })
      map({ "n", "x" }, "<leader>ou",
        function() require("opencode").command("session.half.page.up") end,
        { desc = "opencode half page up" })
      map({ "n", "x" }, "<leader>od",
        function() require("opencode").command("session.half.page.down") end,
        { desc = "opencode half page down" })
      map({ "n", "x" }, "<leader>ob",
        function() require("opencode").command("session.page.up") end,
        { desc = "opencode page up" })
      map({ "n", "x" }, "<leader>of",
        function() require("opencode").command("session.page.down") end,
        { desc = "opencode half page down" })
      map({ "n", "x" }, "<leader>on",
        function() require("opencode").command("session.new") end,
        { desc = "opencode new session" })
      map({ "n", "x" }, "<leader>os",
        function() require("opencode").command("session.list") end,
        { desc = "opencode session list" })
      map({ "n", "x" }, "<leader>ou",
        function() require("opencode").command("session.undo") end,
        { desc = "opencode session undo" })
      map({ "n", "x" }, "<leader>or",
        function() require("opencode").command("session.redo") end,
        { desc = "opencode session redo" })
      map({ "n", "x" }, "<leader>oc",
        function() require("opencode").command("session.compact") end,
        { desc = "opencode session compact" })
    end,
    after = function()
      vim.g.opencode_opts = {
        server = require("plugins.opencode.tmux"),
      }
      -- Required for opts.events.reload
      vim.o.autoread = true
    end,
  },
}
