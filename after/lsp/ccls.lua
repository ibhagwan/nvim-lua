return {
  on_attach = function() print("ccls attached") end,
  init_options = {
    codeLens = {
      enabled = false,
      renderInline = false,
      localVariables = false,
    }
  }
}
