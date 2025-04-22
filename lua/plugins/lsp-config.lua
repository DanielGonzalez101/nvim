return {
	{
		"williamboman/mason.nvim",
		lazy = false,
		config = function()
			require("mason").setup({
				-- Configuración recomendada para instalación automática
				ui = {
					check_outdated_packages_on_open = true,
					auto_update = true,
				},
			})
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		lazy = false,
		config = function() -- Cambiado de 'opts' a 'config' para configuración adecuada
			-- En tu configuración de nvim-lspconfig (dentro del config function)
			local notify = vim.notify
			vim.notify = function(msg, ...)
				if type(msg) == "string" and msg:find("client%.request") then
					return
				end
				return notify(msg, ...)
			end

			-- Sobrescribir el handler de logs de LSP
			local lsp_log_handler = vim.lsp.handlers["window/logMessage"]
			vim.lsp.handlers["window/logMessage"] = function(err, result, ...)
				if result.message:find("deprecated") then
					return
				end
				return lsp_log_handler(err, result, ...)
			end

			-- Configuración adicional para silenciar completamente warnings LSP
			vim.lsp.set_log_level("error")

			require("mason-lspconfig").setup({
				-- Lista de servidores LSP para instalar automáticamente
				ensure_installed = {
					"ts_ls",
					--"solargraph",
					"html",
					"lua_ls",
					"gopls",
				},
				-- Configuración para instalación automática
				automatic_installation = true,
			})
		end,
	},
	{
		"neovim/nvim-lspconfig",
		lazy = false,
		dependencies = { -- Añadida dependencia necesaria
			"hrsh7th/cmp-nvim-lsp",
		},
		config = function()
			-- Configuración de notificaciones mejorada
			local original_notify = vim.notify
			vim.notify = function(msg, level, opts)
				if type(msg) == "string" and msg:find("client%.request") then
					return
				end
				return original_notify(msg, level, opts)
			end

			-- Configurar capacidades mejoradas
			local capabilities = require("cmp_nvim_lsp").default_capabilities()
			local lspconfig = require("lspconfig")

			-- Configuración común para todos los servidores
			local common_setup = {
				capabilities = capabilities,
				on_attach = function(client, bufnr)
					-- Mapeos de teclas específicos por buffer
					local opts = { buffer = bufnr, silent = true }

					vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
					vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts) -- Mejor atajo
					vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
					vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
				end,
			}

			-- Configuraciones específicas de cada servidor
			lspconfig.ts_ls.setup(common_setup)
			lspconfig.solargraph.setup(common_setup)
			lspconfig.html.setup(common_setup)

			-- Configuración especial para Lua
			lspconfig.lua_ls.setup(vim.tbl_deep_extend("force", common_setup, {
				settings = {
					Lua = {
						runtime = { version = "LuaJIT" },
						diagnostics = { globals = { "vim" } },
						workspace = {
							library = vim.api.nvim_get_runtime_file("", true),
							checkThirdParty = false,
						},
						telemetry = { enable = false },
					},
				},
			}))

			-- Configuración especial para Go
			lspconfig.gopls.setup(vim.tbl_deep_extend("force", common_setup, {
				settings = {
					gopls = {
						completeUnimported = true,
						usePlaceholders = true,
						staticcheck = true,
						analyses = {
							unusedparams = true,
						},
					},
				},
			}))

			-- Configuración de diagnóstico mejorada
			vim.diagnostic.config({
				virtual_text = {
					prefix = "●", -- Símbolo más universal
					spacing = 4,
				},
				signs = true,
				underline = true, -- Mejor para identificar errores
				update_in_insert = false,
				severity_sort = true,
				float = {
					border = "rounded",
					source = "always",
				},
			})

			-- Mejor manejo de los signos de diagnóstico
			local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
			for type, icon in pairs(signs) do
				local hl = "DiagnosticSign" .. type
				vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
			end
		end,
	},
}
