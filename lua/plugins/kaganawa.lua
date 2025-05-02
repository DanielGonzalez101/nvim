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
		})
--		vim.cmd("colorscheme kanagawa")
	end,
}
