local M = {
  "nvim-tree/nvim-web-devicons",
}

function M.config()
  require("nvim-web-devicons").setup({
    override = {
      sol = {
        icon = "♦",
        color = "#a074c4",
        name = "Sol"
      },
      sh = {
        icon = "",
        color = "#89e051",
        cterm_color = "113",
        name = "Sh",
      }
    };
  })
end

return M
