return {
  {
    "nvim-lua/plenary.nvim", -- Dummy plugin para que LazyVim lo cargue correctamente
    init = function()
      -- Alt+1 a Alt+9 para ir al buffer 1 a 9
      for i = 1, 9 do
        vim.api.nvim_set_keymap('n', '<A-' .. i .. '>', ':buffer ' .. i .. '<CR>', { noremap = true, silent = true })
      end
      -- Alt+0 para ir al último buffer
      vim.api.nvim_set_keymap('n', '<A-0>', ':<C-u>lua vim.cmd("buffer " .. vim.fn.bufnr("$"))<CR>', { noremap = true, silent = true })
    end,
  },
}

