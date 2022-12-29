local M = {
  "jose-elias-alvarez/null-ls.nvim",
}

M.config = function()
  local null_ls = require("null-ls")
  null_ls.setup({
    sources = {
      null_ls.builtins.formatting.prettier.with({
        extra_filetypes = { "toml" },
      }),
    },
    on_attach = function(_, bufnr)
      vim.keymap.set("n", "gq",
        [[<cmd>lua vim.lsp.buf.format({async=true,name="null-ls"})<CR>]],
        { silent = true, buffer = bufnr, desc = "format document [null-ls]" })
    end
  })
end

return M
