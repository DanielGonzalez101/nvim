return {
  "nvim-neo-tree/neo-tree.nvim",
    	branch = "v3.x",
    	dependencies ={
	      "nvim-lua/plenary.nvim",
      	"nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
	      "MunifTanjim/nui.nvim",   
    	},
  config = function()
    vim.api.nvim_set_keymap("n", "<C-b>", ":Neotree toggle<CR>", { noremap = true, silent = true })
  end
}
