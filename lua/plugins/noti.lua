return {
  "linrongbin16/lsp-progress.nvim",
  config = function()
    local lsp_progress = require("lsp-progress")

    lsp_progress.setup({
      -- Aquí puedes poner configuración opcional.
      -- Ejemplo:
      -- spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" },
      -- decay = 1000,
    })

    -- 🔥 Necesario para que lualine se actualice al cambiar el progreso
    vim.api.nvim_create_autocmd("User", {
      pattern = "LspProgressStatusUpdated",
      callback = require("lualine").refresh,
    })
  end,
}

