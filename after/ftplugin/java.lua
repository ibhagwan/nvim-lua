if not pcall(require, "jdtls") then
  return
end

local root_dir = require("jdtls.setup").find_root({ ".git", "mvnw", "gradlew" })

local config = {
  -- https://github.com/eclipse/eclipse.jdt.ls#running-from-the-command-line
  cmd = {
    "java",
    "-Declipse.application=org.eclipse.jdt.ls.core.id1",
    "-Dosgi.bundles.defaultStartLevel=4",
    "-Declipse.product=org.eclipse.jdt.ls.core.product",
    "-Dlog.protocol=true",
    "-Dlog.level=ALL",
    "-Xms1g",
    "--add-modules=ALL-SYSTEM",
    "--add-opens", "java.base/java.util=ALL-UNNAMED",
    "--add-opens", "java.base/java.lang=ALL-UNNAMED",
    "-jar", vim.fn.glob(vim.fn.stdpath("data") ..
    "/mason/packages/jdtls/plugins/org.eclipse.equinox.launcher_*.jar"),
    "-configuration", vim.fn.stdpath("data") .. "/mason/packages/jdtls/config_linux",
    "-data", (root_dir or vim.loop.cwd()) .. "/.jdtls",
  },
  root_dir = root_dir
}

-- `:help vim.lsp.start_client`
require("jdtls").start_or_attach(config)
