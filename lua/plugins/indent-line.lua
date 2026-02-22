return {
"lukas-reineke/indent-blankline.nvim",
main = "ibl",
config = function()
  local hooks = require("ibl.hooks")
  
  hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
    vim.api.nvim_set_hl(0, "IblIndent", { fg = "#666666" })
    vim.api.nvim_set_hl(0, "IblScope", { fg = "#d79921", bold = true })
  end)

  require("ibl").setup({
    indent = {
      char = "│",
      tab_char = "│",
      highlight = "IblIndent",
    },
    scope = {
      enabled = true,
      char = "│",
      show_start = false,
      show_end = false,
      highlight = "IblScope",
    },
    exclude = {
      filetypes = { 
        "help", 
        "terminal", 
        "dashboard", 
        "lazy", 
        "mason",
        "neo-tree",
        "lspinfo",
        "TelescopePrompt",
      },
    },
  })
end,
}
