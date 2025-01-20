-- Activar relative numbers en modo normal
vim.api.nvim_create_autocmd("InsertLeave", {
  pattern = "*",
  callback = function()
    vim.wo.relativenumber = true
  end,
})

-- Activar números absolutos en modo insert
vim.api.nvim_create_autocmd("InsertEnter", {
  pattern = "*",
  callback = function()
    vim.wo.relativenumber = false
  end,
})

-- Habilitar números absolutos al inicio
vim.opt.number = true
vim.opt.relativenumber = true



-- Global Keymaps
vim.api.nvim_set_keymap("n", "<C-s>", ":w<CR>", { noremap = true, silent = true })  -- Guardar archivo
vim.api.nvim_set_keymap("n", "<C-q>", ":q<CR>", { noremap = true, silent = true })  -- Cerrar archivo
vim.o.clipboard = "unnamedplus"

vim.opt.encoding = "utf-8"
vim.opt.fileencoding = "utf-8"

require('nvim-web-devicons').setup {
  default = true; -- Habilita íconos predeterminados
}

-- Mapeo de teclas para manejar ventanas divididas y terminal
-- Usa `vim.keymap.set` para definir mapeos de teclas en Neovim

-- Abrir una división horizontal
vim.keymap.set('n', '<leader>sh', ':split<CR>', { noremap = true, silent = true })

-- Abrir una división vertical
vim.keymap.set('n', '<leader>sv', ':vsplit<CR>', { noremap = true, silent = true })

-- Navegar entre ventanas
vim.keymap.set('n', '<C-h>', '<C-w>h', { noremap = true, silent = true })
vim.keymap.set('n', '<C-j>', '<C-w>j', { noremap = true, silent = true })
vim.keymap.set('n', '<C-k>', '<C-w>k', { noremap = true, silent = true })
vim.keymap.set('n', '<C-l>', '<C-w>l', { noremap = true, silent = true })

-- Cerrar la ventana actual
vim.keymap.set('n', '<leader>q', '<C-w>c', { noremap = true, silent = true })

-- Abrir terminal integrada
vim.keymap.set('n', '<leader>t', ':terminal<CR>', { noremap = true, silent = true })


-- Atajo para abrir terminal en una división horizontal
vim.keymap.set('n', '<leader>st', ':split | terminal<CR>', { noremap = true, silent = true })

-- Atajo para abrir terminal en una división vertical
vim.keymap.set('n', '<leader>vt', ':vsplit | terminal<CR>', { noremap = true, silent = true })

