return {
	"nvimtools/none-ls.nvim",
  dependencies = {
    "nvimtools/none-ls-extras.nvim",
  },
	config = function()
		local null_ls = require("null-ls")
		null_ls.setup({
			sources = {
				null_ls.builtins.formatting.stylua,
				null_ls.builtins.formatting.prettier, -- Para JavaScript, TypeScript, HTML, CSS, etc.

				-- Autocompletado
				null_ls.builtins.completion.spell, -- Autocompletado de palabras

				-- Diagnósticos
        -- null_ls.builtins.diagnostics.eslint_d,
        --require("none-ls.diagnostics.eslint_d"),
			},
		})
		vim.keymap.set("n", "<leader>f", vim.lsp.buf.format, {})
	end,
}
