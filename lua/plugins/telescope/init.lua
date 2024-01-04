local M = {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    require("utils").IS_WINDOWS
    and { "nvim-telescope/telescope-fzy-native.nvim" }
    or {
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
