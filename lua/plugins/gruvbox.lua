return {
	"ellisonleao/gruvbox.nvim",
	priority = 1000, -- Para que se cargue primero
	config = function()
		require("gruvbox").setup({
			contrast = "medium", -- o "soft" o "medium"
			italic = {
				strings = false,
				comments = false,
				operators = false,
				folds = false,
			},
			overrides = {
				-- puedes poner overrides si querés cambiar colores puntuales
			},
		})

		vim.cmd.colorscheme("gruvbox")
	end,
}
