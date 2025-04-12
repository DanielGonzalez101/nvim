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
				--Cursor = { fg = "#282828", bg = "#EBDBB2" }, -- puedes poner overrides si querés cambiar colores puntuales
				--String = {fg = "#8EC07C"}
			},
		})

		vim.cmd.colorscheme("gruvbox")
	end,
}
