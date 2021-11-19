local res, diffview = pcall(require, "diffview")
if not res then
  return
end

diffview.setup {
  key_bindings = {
    view = { ["gq"] = "<CMD>DiffviewClose<CR>", },
    file_panel = { ["gq"] = "<CMD>DiffviewClose<CR>", }
  }
}
