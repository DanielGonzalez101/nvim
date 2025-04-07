return {
  "nvimtools/none-ls.nvim",
  dependencies = {
    "nvimtools/none-ls-extras.nvim",
  },
  config = function()
    local null_ls = require("null-ls")

    null_ls.setup({
      sources = {
        -- 🧼 FORMATTERS
        null_ls.builtins.formatting.stylua, -- Lua
        null_ls.builtins.formatting.prettier, -- JS, TS, HTML, CSS...
        null_ls.builtins.formatting.gofmt, -- Go

        -- ✍️ AUTOCOMPLETADO
        null_ls.builtins.completion.spell, -- Autocompletado de palabras
      },
    })

    -- 🔑 Formatear manualmente con <leader>f
    vim.keymap.set("n", "<leader>f", function()
      vim.lsp.buf.format({ async = true })
    end, {})

    -- 💾 Autoformateo al guardar archivos Go
    vim.api.nvim_create_autocmd("BufWritePre", {
      pattern = "*.go",
      callback = function()
        vim.lsp.buf.format({ async = false })
      end,
    })
  end,
}
