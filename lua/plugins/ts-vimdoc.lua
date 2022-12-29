local M = {
  "ibhagwan/ts-vimdoc.nvim",
  dev = require("utils").is_dev("ts-vimdoc.nvim"),
  dependencies = { "nvim-treesitter" },
}

M.init = function()
  vim.api.nvim_create_user_command("DocgenREADME",
    function()
      local docgen = require("ts-vimdoc")
      local cwd = vim.loop.cwd()
      local input_file = cwd .. "/README.md"
      local project_name = "fzf-lua"
      if vim.loop.fs_stat(input_file) then
        local metadata = {
          project_name = project_name,
          input_file   = input_file,
          output_file  = ("%s/doc/%s.txt"):format(cwd, project_name),
          -- handlers          = { ["html_block"] = false },
          -- header_count_lvl  = 1,
        }
        docgen.docgen(metadata)
        require "utils".info(("Successfully generated %s")
          :format(vim.fn.shellescape(metadata.output_file)))
      else
        require "utils".warn(("%s is inaccessible")
          :format(vim.fn.shellescape(input_file)))
      end
    end,
    { nargs = "*" }
  )
end

return M
