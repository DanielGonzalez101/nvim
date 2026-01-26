return {
  {
    "XadillaX/vim-automata-theme",
    lazy = false,       -- carga el tema al inicio
    priority = 1000,    -- asegura que se cargue antes que otros plugins
    config = function()
      vim.opt.termguicolors = true
--      vim.cmd.colorscheme("automata")
    end,
  },
}
