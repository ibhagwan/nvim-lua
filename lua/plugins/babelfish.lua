require'utils'.command({ "-nargs=*", "DocgenREADME",
  function()
    local module = 'babelfish'
    local res, docgen = pcall(require, module)
    if not res then
      require('packer').loader("nvim-treesitter")
      require('packer').loader(module..".nvim")
      res, docgen = pcall(require, module)
    end
    if not res then return end
    local cwd = vim.loop.cwd()
    local input_file = cwd.."/README.md"
    local project_name = 'fzf-lua'
    if vim.loop.fs_stat(input_file) then
      local metadata = {
        project_name      = project_name,
        input_file        = input_file,
        output_file       = ("%s/doc/%s.txt"):format(cwd, project_name),
        handlers          = { ["html_block"] = false },
        -- header_count_lvl  = 1,
      }
      docgen.generate_readme(metadata)
      require'utils'.info(("Successfully generated %s")
        :format(vim.fn.shellescape(metadata.output_file)))
    else
      require'utils'.warn(("%s is inaccessible")
        :format(vim.fn.shellescape(input_file)))
    end
  end})
