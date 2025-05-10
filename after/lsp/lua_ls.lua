-- Custom root dir function that ignores "$HOME/.git" for lua files in $HOME
-- which will then run the LSP in single file mdoe, otherwise will err with:
--   LSP[lua_ls] Your workspace is set to `$HOME`.
--   Lua language server refused to load this directory.
--   Please check your configuration.
--   [learn more here](https://luals.github.io/wiki/faq#why-is-the-server-scanning-the-wrong-folder)
-- Reuse ".../nvim-lspconfig/lua/lspconfig/configs/lua_ls"
local root_dir = function(...)
  local lua_ls = require "lspconfig.configs.lua_ls".default_config
  local root = lua_ls.root_dir(...)
  -- NOTE: although returning `nil` here does nullify the "rootUri" property lua_ls still
  -- displays the error, I'm not sure if returning an empty string is the correct move as
  -- it generates "rootUri = "file://" but it does seem to quiet lua_ls and make it work
  -- as if it was started in single file mode
  return root and root ~= vim.env.HOME and root or ""
end

return {
  -- on_attach = function() print("lua_ls attached") end,
  root_dir = function(bufnr, cb_root_dir)
    local bname = vim.api.nvim_buf_get_name(bufnr)
    local root = root_dir(#bname > 0 and bname or vim.uv.cwd())
    cb_root_dir(root)
  end,
  -- uncomment to enable trace logging into:
  -- "~/.local/share/nvim/mason/packages/lua-language-server/libexec/log/service.log"
  -- cmd = { "lua-language-server", "--loglevel=trace" },
  settings = {
    Lua = {
      telemetry = { enable = false },
      runtime = { version = "LuaJIT" },
      -- removes the annoying "Do you need to configure your work environment as"
      -- when opening a lua project that doesn't have a '.luarc.json'
      workspace = { checkThirdParty = false },
      diagnostics = {
        globals = {
          "vim",
          "require",
        },
      },
    }
  }
}
