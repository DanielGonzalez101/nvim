return {
	{
		"williamboman/mason.nvim",
		lazy = false,
		config = function()
			require("mason").setup()
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		lazy = false,
		opts = {
			auto_install = true,
		},
	},
	{
		"neovim/nvim-lspconfig",
		lazy = false,
		config = function()
			local capabilities = require("cmp_nvim_lsp").default_capabilities()
			local lspconfig = require("lspconfig")

			lspconfig.tsserver.setup({ capabilities = capabilities })
			lspconfig.solargraph.setup({ capabilities = capabilities })
			lspconfig.html.setup({ capabilities = capabilities })
			lspconfig.lua_ls.setup({ capabilities = capabilities })
			lspconfig.gopls.setup({
				capabilities = capabilities,
				settings = {
					gopls = {
						completeUnimported = true,
						usePlaceholders = true,
						staticcheck = true,
					},
				},
			})

			-- Diagnóstico: mostrar errores a la derecha
			vim.diagnostic.config({
				virtual_text = {
					prefix = "●", -- o "»", "→", "■"
					spacing = 4,
				},
				signs = true,
				underline = false,
				update_in_insert = false,
				severity_sort = true,
			})

			-- Keymaps
			vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
			vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, {})
			vim.keymap.set("n", "<leader>gr", vim.lsp.buf.references, {})
			vim.keymap.set("n", "<C-.>", vim.lsp.buf.definition, { noremap = true, silent = true })
		end,
	},
}
