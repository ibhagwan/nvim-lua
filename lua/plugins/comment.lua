local res, comment = pcall(require, "Comment")
if not res then
  return
end

comment.setup({

    opleader = {
        line = 'gl',
        block = 'gc',
    },

    pre_hook = nil,
    post_hook = nil,
})
