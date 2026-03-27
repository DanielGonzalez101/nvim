return {
	"mg979/vim-visual-multi",
	branch = "master",
	init = function()
		-- Cambia el atajo principal a Ctrl+d (igual que VS Code)
		vim.g.VM_maps = {
			["Find Under"] = "<C-d>",
			["Find Subword Under"] = "<C-d>",
		}
	end,
}
