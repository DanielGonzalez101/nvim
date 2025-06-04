return {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
		"MunifTanjim/nui.nvim",
	},
	config = function()
		require("neo-tree").setup({
			filesystem = {
				filtered_items = {
					visible = true, -- mostrar archivos ocultos
					show_hidden_count = true,
					hide_dotfiles = false, -- NO ocultar los archivos que empiezan con `.`
					hide_gitignored = false, -- opcional: mostrar incluso los ignorados por git
				},
			},
			window = {
				position = "float",
				popup = {
					size = {
						height = "80%",
						width = "50%",
					},
					position = "50%",
					border = "single",
				},
			},
		})

		vim.api.nvim_set_keymap("n", "<C-b>", ":Neotree toggle<CR>", { noremap = true, silent = true })
	end,
}
