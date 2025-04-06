return {
	"windwp/nvim-autopairs",
	event = "InsertEnter",
	opts = {
		check_ts = true, -- Usa treesitter para no cerrar cosas en comentarios o strings
		fast_wrap = {},
		disable_filetype = { "TelescopePrompt", "vim" },
	},
}
