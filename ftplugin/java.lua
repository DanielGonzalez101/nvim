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



local function open_run_terminal(cmd)
  -- Abrir una terminal flotante
  vim.cmd("botright split term://" .. cmd)
  vim.cmd("resize 15") -- tamaño de la terminal
end

vim.keymap.set("n", "<leader>r", function()
  local has_maven = vim.fn.filereadable("pom.xml") == 1
  local has_gradle = vim.fn.filereadable("build.gradle") == 1 or vim.fn.filereadable("build.gradle.kts") == 1

  if has_maven then
    open_run_terminal("mvn spring-boot:run")
    return
  end

  if has_gradle then
    open_run_terminal("./gradlew bootRun")
    return
  end

  -- Java puro
  local file = vim.fn.expand("%:p")
  local dir = vim.fn.expand("%:p:h")
  local main = vim.fn.expand("%:t:r")
  open_run_terminal("bash -c 'javac " .. file .. " && java -cp " .. dir .. " " .. main .. "'")
end, { buffer = true, desc = "Run Java Project" })

