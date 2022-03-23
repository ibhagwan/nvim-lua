local res, dapui = pcall(require, "dapui")
if not res then
  return
end


dapui.setup({
  sidebar = {
    size = 40,
    position = "right",
  }
})
