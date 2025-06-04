return {
	"ellisonleao/gruvbox.nvim",
	priority = 1000, -- Para que se cargue primero
	config = function()
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
		vim.cmd.colorscheme("gruvbox") -- Aplica el tema Gruvbox
	end,
}
