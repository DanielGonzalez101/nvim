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

			overrides = function()
				return {
					SignColumn = { bg = "#2A2A37" },
				}
			end,
		})
		-- Puedes obtener estos desde la documentación del tema o usar :Inspect
		-- Aquí unos ejemplos comunes:
--		vim.cmd("colorscheme kanagawa-wave")
		--vim.api.nvim_set_hl(0, "LineNr", { bg = "#2A2A37" })
--		vim.api.nvim_set_hl(0, "SignColumn", { bg = "#2A2A37" })
		--vim.api.nvim_set_hl(0, "FoldColumn", { bg = "#2A2A37" })
	end,
}
