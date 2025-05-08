return {
    {
        "nvim-telescope/telescope.nvim",
        tag = "0.1.8",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            local telescope = require("telescope")
            local builtin = require("telescope.builtin")

            telescope.setup({
                defaults = {
                    border = true, -- sin bordes
                    prompt_prefix = " ", -- ícono opcional para que se vea más moderno
                    selection_caret = " ",
                    entry_prefix = "  ",
                    layout_strategy = "horizontal",
                    --sorting_strategy = "ascending",
                    layout_config = {
                        horizontal = {
                            prompt_position = "bottom",
                            preview_width = 0.45,
                            results_width = 0.55,
                        },
                        --width = 0.95,
                        --height = 0.85,
                        preview_cutoff = 0, -- muestra siempre el preview
                    },
                    color_devicons = true,
                },
            })

            vim.keymap.set("n", "<C-p>", function()
                builtin.find_files({ hidden = true })
            end, {})
            vim.keymap.set("n", "<leader>fg", builtin.live_grep, {})
        end,
    },
    {
        "nvim-telescope/telescope-ui-select.nvim",
        config = function()
            require("telescope").setup({
                extensions = {
                    ["ui-select"] = {
                        require("telescope.themes").get_dropdown({
                            border = false,
                        }),
                    },
                },
            })
            require("telescope").load_extension("ui-select")
        end,
    },
    -- Después de telescope.setup({...})
    vim.api.nvim_set_hl(0, "TelescopeResultsNormal", { bg = "#1E1C1A" }),
    vim.api.nvim_set_hl(0, "TelescopePreviewNormal", { bg = "#1e1e1e" }),
    -- Eliminar cualquier borde o línea separadora entre resultados y preview
    vim.api.nvim_set_hl(0, "TelescopeBorder", { bg = "#2e2e2e", fg = "#2e2e2e" }),
    vim.api.nvim_set_hl(0, "TelescopePromptNormal", { bg = "#2e2e2e", fg = "#767F7E" }),
    vim.api.nvim_set_hl(0, "TelescopePromptBorder", { bg = "#2e2e2e", fg = "#2e2e2e" }),
    vim.api.nvim_set_hl(0, "TelescopeResultsBorder", { bg = "#1E1C1A", fg = "#1E1C1A" }),
    vim.api.nvim_set_hl(0, "TelescopePreviewBorder", { bg = "#1E1E1E", fg = "#1E1E1E" }),
}
