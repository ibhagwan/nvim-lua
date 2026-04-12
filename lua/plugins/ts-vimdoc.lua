return {
  src = require("utils").exists("~/Sources/nvim/ts-vimdoc.nvim")
      or "https://github.com/ibhagwan/ts-vimdoc.nvim",
  data = {
    cmd = { "DocgenREADME", "DocgenOPTIONS" },
    beforeAll = function()
      local function docgen(opts)
        require("lz.n").trigger_load("ts-vimdoc.nvim")
        local vimdoc = require("ts-vimdoc")
        opts.project_name = opts.project_name
            or vim.fn.fnamemodify(vim.uv.cwd() --[[@as string]], ":t:r")
        opts.input_file = vim.fn.fnamemodify(opts.input_file, ":p")
        opts.output_file = opts.output_file or
            vim.fn.fnamemodify(string.format("doc/%s.txt", opts.project_name), ":p")
        if not vim.uv.fs_stat(opts.input_file) then
          require("utils").warn("'%s' is inaccessible", vim.fn.fnamemodify(opts.input_file, ":."))
          return
        end
        if not vim.uv.fs_stat("doc") then
          vim.fn.mkdir("doc", "p")
        end
        vimdoc.docgen(vim.tbl_extend("keep", opts, { version = "For Neovim >= 0.9.0" }))
        require("utils").info(("Successfully generated %s")
          :format(vim.fn.fnamemodify(opts.output_file, ":.")))
      end

      vim.api.nvim_create_user_command("DocgenREADME", function()
        docgen({
          input_file = "README.md",
          table_of_contents_lvl_min = 2,
          table_of_contents_lvl_max = 4,
        })
      end, {})

      vim.api.nvim_create_user_command("DocgenOPTIONS", function()
        docgen({
          input_file = "OPTIONS.md",
          output_file = "doc/fzf-lua-opts.txt",
          project_name = "fzf-lua-opts",
          table_of_contents_lvl_min = 2,
          table_of_contents_lvl_max = 3,
        })
      end, {})
    end,
  },
}
