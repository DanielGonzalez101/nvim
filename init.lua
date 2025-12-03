-- Configuración de opciones básicas
vim.cmd("set expandtab")
vim.cmd("set tabstop=2")
vim.cmd("set softtabstop=2")
vim.cmd("set shiftwidth=2")
vim.g.mapleader = " "
vim.opt.termguicolors = true
vim.opt.signcolumn = "yes"
vim.o.scrolloff = 8
vim.opt.swapfile = false

-- Columna de signos igual al fondo
vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "*",
  callback = function()
    vim.cmd("highlight! link SignColumn Normal")
  end,
})

-- Ruta para Lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Colores para identación y estilos
--vim.api.nvim_set_hl(0, "IblIndent", { fg = "#504945" }) -- gris suave de gruvbox
--vim.api.nvim_set_hl(0, "Comment", { italic = false })
--vim.api.nvim_set_hl(0, "Function", { italic = false })
--vim.api.nvim_set_hl(0, "Type", { italic = false })
--vim.api.nvim_set_hl(0, "Identifier", { italic = false })
--vim.api.nvim_set_hl(0, "Keyword", { italic = false })

-- Plugins
require("lazy").setup("plugins")
require("vim-options")

-- Formatear archivos Go antes de guardar
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.go",
  callback = function()
    vim.lsp.buf.format({ async = false })
  end,
})

-- 🔥 Esto lo forza incluso si otro plugin intenta sobrescribirlo
--vim.api.nvim_set_hl(0, "SignColumn", { bg = "#121212" })
-- Configurar diagnósticos (sin signos en la columna)
vim.diagnostic.config({
  signs = false,
})

-- Asegurar buffers modificables y formato unix
vim.api.nvim_create_autocmd("BufReadPost", {
  pattern = "*",
  callback = function()
    if not vim.bo.readonly and not vim.bo.modifiable then
      vim.bo.modifiable = true
    end
    vim.bo.fileformat = "unix"
  end,
})

-- Estilos para ventanas flotantes
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "#282828" })
vim.api.nvim_set_hl(0, "FloatBorder", { fg = "#a89984", bg = "#282828" })

-- Cargar snippets desde carpeta personalizada
require("luasnip.loaders.from_lua").load({ paths = "~/.config/nvim/lua/snippets" })
