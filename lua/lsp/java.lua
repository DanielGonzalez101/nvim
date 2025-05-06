-- ~/.config/nvim/lua/lsp/java.lua
local jdtls = require("lsp-config").jdtls

jdtls.setup({
	cmd = { "jdtls" },
	root_dir = require("lspconfig.util").root_pattern("pom.xml", ".git"),
	settings = {
		java = {
			signatureHelp = { enabled = true },
			contentProvider = { preferred = "fernflower" },
			completion = {
				favoriteStaticMembers = {
					"org.junit.Assert.*",
					"org.junit.Assume.*",
				},
			},
		},
	},
	on_attach = function(client, bufnr)
		vim.diagnostic.enable(true)
		vim.diagnostic.show(nil, bufnr)
		vim.lsp.codelens.refresh()

		-- Opcional: tus mappings aquí
	end,
})
vim.diagnostic.config({
	virtual_text = {
		prefix = "●",
		spacing = 4,
	},
	signs = true,
	underline = true,
	update_in_insert = false,
	severity_sort = true,
	float = {
		border = "rounded",
		source = "always",
	},
})
