return {
	"akinsho/toggleterm.nvim",
	version = "*",
	config = function()
		require("toggleterm").setup({
			direction = "float",
			float_opts = {
				border = "single", -- puedes cambiar a "single", "double", etc.
				width = 80,
				height = 20,
				winblend = 1, -- transparencia
			},
			open_mapping = [[<C-t>]],
			shade_terminals = true, -- para ver el código detrás
		})
	end,
}
