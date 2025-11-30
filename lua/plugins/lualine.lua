
return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons", "linrongbin16/lsp-progress.nvim" },
	config = function()
		local devicons = require("nvim-web-devicons")
		local lsp_progress = require("lsp-progress")

		require("lualine").setup({
			sections = {
				lualine_a = { "mode" },
				lualine_b = { "branch" },
				lualine_c = { "filename" },
				lualine_x = {
					{
						"diagnostics",
						sources = { "nvim_diagnostic" },
						sections = { "error", "warn", "info", "hint" },
						symbols = { error = " ", warn = " ", info = " ", hint = " " },
						colored = true,
						update_in_insert = false,
						always_visible = false,
					},
					-- 🔥 Aquí va lsp-progress en tu lualine
					function()
						return lsp_progress.progress()
					end,
					function()
						local file = vim.fn.expand("%:t")
						local ext = vim.fn.expand("%:e")
						local icon = devicons.get_icon(file, ext, { default = true })
						return icon or ""
					end,
				},
				lualine_y = { "progress" },
				lualine_z = { "location" },
			},
		})

		-- 🔥 Necesario para refrescar la barra cuando cambie el progreso
		vim.api.nvim_create_autocmd("User", {
			pattern = "LspProgressStatusUpdated",
			callback = require("lualine").refresh,
		})
	end,
}

