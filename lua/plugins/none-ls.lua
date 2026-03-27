return {
	"stevearc/conform.nvim",
	event = { "BufWritePre" },
	config = function()
		local conform = require("conform")
		conform.setup({
			formatters_by_ft = {
				lua = { "stylua" },
				javascript = { "prettier" },
				typescript = { "prettier" },
				html = { "prettier" },
				css = { "prettier" },
				scss = { "prettier" },
				json = { "prettier" },
				go = { "gofmt" },
				python = { "isort", "black" },
				--cs = { "lsp" },
			},
			format_on_save = {
				go = { timeout_ms = 500, lsp_fallback = true },
			},
		})
		vim.keymap.set("n", "<leader>f", function()
			conform.format({ async = true, lsp_fallback = true })
		end, {}) -- Autoformateo al guardar archivos Go
		vim.api.nvim_create_autocmd("BufWritePre", {
			pattern = "*.go",
			callback = function()
				conform.format({ async = false })
			end,
		})
	end,
}
