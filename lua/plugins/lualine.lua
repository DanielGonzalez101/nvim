return {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
        local devicons = require("nvim-web-devicons")

        require("lualine").setup({
            options = {
                theme = "auto",
            },
            sections = {
                lualine_a = { "mode" },
                lualine_b = { "branch" },
                lualine_c = { "filename" },
                lualine_x = {
                    function()
                        local file = vim.fn.expand("%:t")
                        local ext = vim.fn.expand("%:e")
                        local icon, _ = devicons.get_icon(file, ext, { default = true })
                        return icon or ""
                    end,
                },
                lualine_y = { "progress" },
                lualine_z = { "location" },
            },
        })
    end,
}
