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
            window = {
                position = "float", -- ventana flotante en vez de a la izquierda/derecha
                popup = {
                    size = {
                        height = "80%",
                        width = "50%",
                    },
                    border = "solid",
                    position = "50%", -- centrado
                },
            },
        })

        vim.api.nvim_set_keymap("n", "<C-b>", ":Neotree toggle<CR>", { noremap = true, silent = true })
    end,
}
