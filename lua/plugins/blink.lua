local _use_lua = not require("utils").cargo_has_nightly()
    or require "utils".is_NetBSD()
    or require "utils".is_iSH()

local M = {
  "saghen/blink.cmp",
  enabled = true,
  build = not _use_lua and "cargo +nightly build --release",
  event = { "InsertEnter", "CmdLineEnter" },
  opts = {
    fuzzy = { implementation = _use_lua and "lua" or nil },
    sources = {
      default = { "lazydev", "lsp", "path", "snippets", "buffer" },
      providers = {
        lazydev = {
          name = "LazyDev",
          module = "lazydev.integrations.blink",
          -- make lazydev completions top priority (see `:h blink.cmp`)
          score_offset = 100,
        },
      },
    },
    keymap = {
      ["<CR>"] = { "accept", "fallback" },
      -- ["<Esc>"] = { "hide", "fallback" },
      -- ["<C-c>"] = { "cancel", "fallback" },
      ["<Up>"] = { "select_prev", "fallback" },
      ["<Down>"] = { "select_next", "fallback" },
      ["<C-e>"] = { "cancel", "show", "fallback" },
      ["<C-p>"] = { "select_prev", "fallback" },
      ["<C-n>"] = { "select_next", "fallback" },
      ["<C-y>"] = { "select_and_accept" },
      ["<C-k>"] = { "show", "show_documentation", "hide_documentation" },
      ["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
      ["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
      ["<S-up>"] = { "scroll_documentation_up", "fallback" },
      ["<S-down>"] = { "scroll_documentation_down", "fallback" },
    },
    cmdline = {
      enabled = true,
      completion = {
        menu = { auto_show = true },
        list = { selection = { preselect = false, auto_insert = true } },
      },
      keymap = {
        ["<CR>"] = { "accept", "fallback" },
        ["<Esc>"] = { "hide", "fallback" },
        ["<Tab>"] = { "select_next", "fallback" },
        ["<S-Tab>"] = { "select_prev", "fallback" },
        ["<C-e>"] = { "cancel", "fallback" },
        ["<C-y>"] = { "select_and_accept" },
      }
    },
    completion = {
      list = { selection = { preselect = false, auto_insert = true } },
      trigger = { show_in_snippet = false },
      accept = {
        create_undo_point = true,
        auto_brackets = { enabled = true },
      },
      menu = {
        draw = {
          treesitter = { "lsp" },
          columns = function(ctx)
            local ret = { { "kind_icon" }, { "label", "label_description", gap = 1 } } -- default
            -- Add kind, source to INSERT mode
            if ctx.mode ~= "cmdline" then
              table.insert(ret, { "kind", "source_name", gap = 1 })
            end
            return ret
          end,
        }
      },
      documentation = {
        auto_show = true,
        auto_show_delay_ms = 100,
      },
      ghost_text = { enabled = true },
    },
    signature = { enabled = true }
  },
}

return M
