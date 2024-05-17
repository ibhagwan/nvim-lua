local get_colors = function()
  local utils = require("heirline.utils")
  local is_nightfly = vim.g.colors_name == "nightfly"
  return {
    -- statusline_bg = utils.get_highlight("StatusLine").bg,
    red_fg = utils.get_highlight("ErrorMsg").fg,
    green_fg = is_nightfly
        and utils.get_highlight("NightflyTurquoise").fg
        or utils.get_highlight("diffAdded").fg
        or utils.get_highlight("Added").fg,
    yellow_fg = is_nightfly
        and utils.get_highlight("NightflyYellow").fg
        or utils.get_highlight("WarningMsg").fg,
    magenta_fg = is_nightfly
        and utils.get_highlight("NightflyViolet").fg
        or utils.get_highlight("WarningMsg").fg,
  }
end
return {
  "rebelot/heirline.nvim",
  -- enabled = false,
  event = "BufReadPost",
  config = function()
    require("heirline").setup({
      opts = { colors = get_colors },
      statusline = require("plugins.heirline.statusline"),
    })
  end,
  _get_colors = get_colors,
}
