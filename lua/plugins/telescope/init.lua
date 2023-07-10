local M = {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && "
          .. "cmake --build build --config Release && "
          .. "cmake --install build --prefix build"
    }
  },
}

function M.init()
  require("plugins.telescope.mappings")
end

function M.config()
  require("plugins.telescope.cmds")
  require("plugins.telescope.setup").setup()
end

return M
