return {
  "lukas-reineke/indent-blankline.nvim",
  main = "ibl",
  opts = {
    indent = {
      char = "│", -- Podés usar "┊", "┆", "¦", "·", etc.
    },
    scope = {
      enabled = true, -- esto activa el resaltado del nivel de indent actual
      show_start = false,
      show_end = false,
    },
    exclude = {
      filetypes = { "help", "terminal", "dashboard", "lazy", "mason" },
    },
  },
}
