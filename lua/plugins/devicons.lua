local res, devicons = pcall(require, "nvim-web-devicons")

if not res then
  return
end

devicons.setup({
  override = {
    sol = {
      icon = "♦",
      color = "#a074c4",
      name = "Sol"
    }
  };
})
