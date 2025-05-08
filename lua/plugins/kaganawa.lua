return {
	"rebelot/kanagawa.nvim",
	lazy = false,
	priority = 1000,
	config = function()
		require("kanagawa").setup({
			keywordStyle = { italic = false },
			statementStyle = { italic = false },
			typeStyle = { italic = false },
			variablebuiltinStyle = { italic = false },
			specialReturn = false,
			specialException = false,
			commentStyle = { italic = false },

			overrides = function(colors)
				return {
					SignColumn = { bg = "#282727" },
				}
			end,
		})
		-- Puedes obtener estos desde la documentación del tema o usar :Inspect
		-- Aquí unos ejemplos comunes:
			vim.cmd("colorscheme kanagawa-dragon")
	end,
}
