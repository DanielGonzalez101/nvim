vim.cmd("set expandtab")
vim.cmd("set tabstop=2")
vim.cmd("set softtabstop=2")
vim.cmd("set shiftwidth=2")
vim.g.mapleader = " "
vim.opt.termguicolors = true
vim.opt.signcolumn = "no"

-- Ruta para Lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- Última versión estable
		lazypath,
	})
end

vim.opt.swapfile = false
vim.opt.rtp:prepend(lazypath)

-- Colores para identación y otros elementos
vim.api.nvim_set_hl(0, "IblIndent", { fg = "#504945" }) -- gris suave de gruvbox
vim.api.nvim_set_hl(0, "Comment", { italic = false })
vim.api.nvim_set_hl(0, "Function", { italic = false })
vim.api.nvim_set_hl(0, "Type", { italic = false })
vim.api.nvim_set_hl(0, "Identifier", { italic = false })
vim.api.nvim_set_hl(0, "Keyword", { italic = false })

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

-- Asegurarse de que los buffers sean modificables antes de cambiar el formato
vim.api.nvim_create_autocmd("BufReadPost", {
	pattern = "*",
	callback = function()
		if not vim.bo.readonly and not vim.bo.modifiable then
			vim.bo.modifiable = true
		end
		vim.bo.fileformat = "unix"
	end,
})
