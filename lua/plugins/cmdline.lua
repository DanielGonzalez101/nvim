return {
	"folke/noice.nvim",
	event = "VeryLazy",
	dependencies = {
		{
			"rcarriga/nvim-notify",
			config = function()
				require("notify").setup({
					background_colour = "#1e1e2e",
				})
			end,
		},
		"MunifTanjim/nui.nvim",
	},
	config = function()
		require("noice").setup({
			cmdline = {
				view = "cmdline_popup",
			},
			views = {
				cmdline_popup = {
					position = {
						row = 0, -- arriba del todo
						col = "50%", -- centrado
					},
					size = {
						width = 60,
						height = "auto",
					},
					border = {
						style = "rounded",
					},
					win_options = {
						winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
					},
				},
			},
			messages = {
				enabled = true,
			},
			popupmenu = {
				enabled = true,
			},
			lsp = {
				progress = {
					enabled = true,
				},
				hover = {
					enabled = true,
				},
				signature = {
					enabled = true,
				},
			},
		})
	end,
}
