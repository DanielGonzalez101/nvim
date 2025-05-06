return {
	"ellisonleao/gruvbox.nvim",
	priority = 1000, -- Para que se cargue primero
	config = function()
		-- Lee la variable de entorno NVIM_THEME
		--local theme = os.getenv("NVIM_THEME") or "dark" -- Si no está configurada, usa 'dark' por defecto
		vim.o.background = "dark"
		-- Configuración del plugin Gruvbox
		require("gruvbox").setup({
			terminal_colors = true,
			contrast = "medium", -- o "soft" o "medium"
			italic = {
				strings = false,
				comments = false,
				operators = false,
				folds = false,
			},
			bold = false, -- Desactiva el bold
		})
--		vim.cmd.colorscheme("gruvbox") -- Aplica el tema Gruvbox
	end,
}
