if not pcall(require, "jdtls") then
  return
end

-- `:help vim.lsp.start_client`
require("jdtls").start_or_attach({
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
    "-jar",
    -- vim.fn.stdpath("data") ..
    -- "/mason/packages/jdtls/plugins/org.eclipse.equinox.launcher_1.6.400.v20210924-0641.jar",
    vim.fn.glob(vim.fn.stdpath("data") ..
      "/mason/packages/jdtls/plugins/org.eclipse.equinox.launcher_*.jar"),
    "-configuration",
    vim.fn.stdpath("data") .. "/mason/packages/jdtls/plugins/config_linux",
    "-data",
    vim.fn.expand("$XDG_DATA_HOME/eclipse/") .. vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
  },
  root_dir = require("jdtls.setup").find_root({ ".git", "mvnw", "gradlew" }),
})
