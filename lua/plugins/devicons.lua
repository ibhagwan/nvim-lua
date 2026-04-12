return {
  src = "https://github.com/nvim-tree/nvim-web-devicons",
  data = {
    lazy = true,
    after = function()
      require("nvim-web-devicons").setup({
        override_by_extension = {
          sol = {
            -- icon = "♦",
            icon = "",
            color = "#a074c4",
            name = "Sol"
          },
          sh = {
            icon = "",
            color = "#89e051",
            cterm_color = "113",
            name = "Sh",
          },
          md = {
            icon = "󰍔",
            color = "#dddddd",
            cterm_color = "239",
            name = "Md",
          },
          norg = {
            icon = "",
            color = "#97eefc",
            name = "Neorg",
          },
        },
      })
    end,
  },
}
