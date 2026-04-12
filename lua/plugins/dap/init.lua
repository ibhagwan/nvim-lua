return {
  { src = "https://github.com/nvim-neotest/nvim-nio",             data = { lazy = true } },
  { src = "https://github.com/rcarriga/nvim-dap-ui",              data = { lazy = true } },
  { src = "https://github.com/theHamsta/nvim-dap-virtual-text",   data = { lazy = true } },
  { src = "https://github.com/jbyuki/one-small-step-for-vimkind", data = { lazy = true } },
  {
    src = "https://github.com/mfussenegger/nvim-dap",
    data = {
      lazy = true,
      beforeAll = function()
        local utils = require("utils")
        local map = function(modes, lhs, rhs, opts)
          vim.keymap.set(modes, lhs, function(...)
            require("lz.n").trigger_load("nvim-dap")
            rhs(...)
          end, opts)
        end
        -- DAP keymaps
        map({ "n", "v" }, "<F5>", function() require("dap").continue() end,
          { silent = true, desc = "DAP launch or continue" })
        -- <S-F5>
        map({ "n", "v" }, "<F17>", function() require("osv").launch({ port = 9090 }) end,
          { silent = true, desc = "Start OSV Lua Debug Server" })
        map({ "n", "v" }, "<F8>", function() require("plugins.dap.ui").toggle() end,
          { silent = true, desc = "DAP toggle UI" })
        -- <S-F8>
        map({ "n", "v" }, "<F20>", function() require("plugins.dap.ui").toggle(true, true) end,
          { silent = true, desc = "DAP toggle UI" })
        map({ "n", "v" }, "<F9>", function() require("dap").toggle_breakpoint() end,
          { silent = true, desc = "DAP toggle breakpoint" })
        map({ "n", "v" }, "<F10>", function() require("dap").step_over() end,
          { silent = true, desc = "DAP step over" })
        map({ "n", "v" }, "<F11>", function() require("dap").step_into() end,
          { silent = true, desc = "DAP step into" })
        map({ "n", "v" }, "<F12>", function() require("dap").step_out() end,
          { silent = true, desc = "DAP step out" })
        map({ "n", "v" }, "<F6>", function() require("dap").terminate() end,
          { silent = true, desc = "DAP Terminate" })
        map({ "n", "v" }, "<leader>dt", function() require("dap").terminate() end,
          { silent = true, desc = "DAP terminate" })
        map({ "n", "v" }, "<leader>dc",
          function() require("dap").set_breakpoint(utils.input("Breakpoint condition: ")) end,
          { silent = true, desc = "DAP: set breakpoint with condition" })
        map({ "n", "v" }, "<leader>dl",
          function() require("dap").set_breakpoint(nil, nil, utils.input("Log point message: ")) end,
          { silent = true, desc = "DAP: set breakpoint with log point message" })
        map({ "n", "v" }, "<leader>d-", function() require("plugins.dap.utils").load_bps() end,
          { silent = true, desc = "DAP load breakpoints" })
        map({ "n", "v" }, "<leader>d+", function() require("plugins.dap.utils").store_bps() end,
          { silent = true, desc = "DAP store breakpoints" })
        map({ "n", "v" }, "<leader>dr", function() require("dap").repl.toggle() end,
          { silent = true, desc = "DAP toggle debugger REPL" })
        map({ "n", "v" }, "<Leader>dk", function() require("dap.ui.widgets").hover() end,
          { silent = true, desc = "DAP Hover" })
        map({ "n", "v" }, "<Leader>dp", function() require("dap.ui.widgets").preview() end,
          { silent = true, desc = "DAP Preview" })
        map({ "n", "v" }, "<Leader>df", function()
          local widgets = require("dap.ui.widgets")
          widgets.centered_float(widgets.frames)
        end, { silent = true, desc = "DAP Frames" })
        map({ "n", "v" }, "<Leader>ds", function()
          local widgets = require("dap.ui.widgets")
          widgets.centered_float(widgets.scopes)
        end, { silent = true, desc = "DAP Scopes" })
        map({ "n", "v" }, "<leader>d?", function() require("fzf-lua").dap_commands() end,
          { silent = true, desc = "DAP: fzf nvim-dap builtin commands" })
        map({ "n", "v" }, "<leader>db",
          function() require("fzf-lua").dap_breakpoints() end,
          { silent = true, desc = "DAP: fzf breakpoint list" })
        map({ "n", "v" }, "<leader>dF", function() require("fzf-lua").dap_frames() end,
          { silent = true, desc = "DAP: fzf frames" })
        map({ "n", "v" }, "<leader>dv", function() require("fzf-lua").dap_variables() end,
          { silent = true, desc = "DAP: fzf variables" })
        map({ "n", "v" }, "<leader>dx",
          function() require("fzf-lua").dap_configurations() end,
          { silent = true, desc = "DAP: fzf debugger configurations" })
      end,
      before = function()
        ---@diagnostic disable-next-line: missing-fields
        require("lz.n").trigger_load({
          "nvim-dap-ui",
          "nvim-dap-virtual-text",
          "one-small-step-for-vimkind",
          "nvim-nio",
          -- Lazy load fzf-lua to register_ui_select
          "fzf-lua"
        })
      end,
      after = function()
        local dap = require("dap")

        -- Set logging level
        dap.set_log_level("DEBUG")

        -- Configure dap-ui and language adapters
        require("plugins.dap.ui").setup()
        require("plugins.dap.go")
        require("plugins.dap.lua")
        require("plugins.dap.python")
        require("plugins.dap.cpp_rust")

        -- Override the json decoder to support jsonc
        require("dap.ext.vscode").json_decode = require("lib.jsonc").decode
        -- Load configurations from .launch.jsonc
        -- require("dap.ext.vscode").load_launchjs(".launch.jsonc", {
        --   go = { "go" },
        --   python = { "py" },
        --   gdb = { "c", "cpp", "rust" },
        --   lldb = { "c", "cpp", "rust" },
        --   cppdbg = { "c", "cpp", "rust" },
        -- })

        -- Controls how stepping switches buffers
        dap.defaults.fallback.switchbuf = "useopen,uselast"

        -- Which terminal should be launched
        dap.defaults.fallback.external_terminal = {
          command = "/usr/bin/alacritty",
          args = { "-e" },
        }

        -- Highlight groups
        vim.api.nvim_set_hl(0, "NvimDapVirtualText", { link = "Comment" })
        vim.api.nvim_set_hl(0, "NvimDapVirtualTextInfo", { link = "DiagnosticInfo" })
        vim.api.nvim_set_hl(0, "NvimDapVirtualTextError", { link = "DiagnosticError" })
        vim.api.nvim_set_hl(0, "NvimDapVirtualTextChanged", { link = "DiagnosticWarn" })

        -- Configure nvim-dap-virtual-text
        local ok, dapvt = pcall(require, "nvim-dap-virtual-text")
        if ok and dapvt then
          ---@diagnostic disable-next-line: need-check-nil
          dapvt.setup({ virt_text_pos = "eol" })
        end
      end,
    },
  }
}
