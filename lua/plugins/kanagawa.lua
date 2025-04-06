---@diagnostic disable: duplicate-index
return {
    "rebelot/kanagawa.nvim", -- El tema Kanagawa
    lazy = false,            -- Cargarlo inmediatamente
    priority = 1000,         -- Asegúrate de que se carga antes que otros
    config = function()
      vim.cmd("colorscheme kanagawa-dragon") -- Aplica el tema
    end,
    config = function()
--vim.cmd.colorscheme "kanagawa-dragon"
    end
}
