local ok, jdtls = pcall(require, "jdtls")
if not ok then
  return
end

-- Detectar root del proyecto
local root = require("jdtls.setup").find_root({ "pom.xml", "build.gradle", ".git" })

-- Si NO existe un root_dir válido, usar la carpeta del archivo
if root == "" then
  root = vim.fn.expand("%:p:h")
end

-- Workspace único por proyecto/carpeta
local workspace = vim.fn.stdpath("data") .. "/jdtls/" .. vim.fn.fnamemodify(root, ":p:h:t")

jdtls.start_or_attach({
  cmd = {
    vim.fn.stdpath("data") .. "/mason/bin/jdtls",
    "-data", workspace,
  },
  root_dir = root,
  capabilities = require("cmp_nvim_lsp").default_capabilities(),
})


