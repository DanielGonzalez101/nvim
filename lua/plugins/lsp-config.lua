-- Configuración moderna de LSP y Mason (Neovim 0.11+)
-- Sin Java (se maneja aparte)
return {
	{
		"williamboman/mason.nvim",
		lazy = false,
		config = function()
			require("mason").setup({
				ui = {
					check_outdated_packages_on_open = true,
					border = "rounded",
					icons = {
						package_installed = "✓",
						package_pending = "➜",
						package_uninstalled = "✗",
					},
				},
			})
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		lazy = false,
		dependencies = { "mason.nvim" },
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = {
					"lua_ls", -- Lua
					"ts_ls", -- TypeScript/JavaScript
					"angularls", -- Angular
					"html", -- HTML
					"cssls", -- CSS
					"emmet_ls", -- Emmet
					"tailwindcss", -- Tailwind CSS
					"pyright", -- Python
				},
				automatic_installation = true,
			})
		end,
	},
	{
		"neovim/nvim-lspconfig",
		lazy = false,
		dependencies = {
			"mason-lspconfig.nvim",
			"hrsh7th/cmp-nvim-lsp",
		},
		config = function()
			-- Capabilities con soporte de nvim-cmp
			local capabilities = require("cmp_nvim_lsp").default_capabilities()

			-- On_attach común para todos los LSP
			local common_on_attach = function(client, bufnr)
				local opts = { buffer = bufnr, silent = true }

				-- Keymaps
				vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
				vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
				vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
				vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
				vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
				vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
				vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
				vim.keymap.set("n", "gl", vim.diagnostic.open_float, opts)
				vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
				vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
				vim.keymap.set("n", "<leader>f", function()
					vim.lsp.buf.format({ async = true })
				end, opts)

				-- Habilitar diagnósticos
				vim.diagnostic.enable(true, { bufnr = bufnr })
			end

			-- Configuración de diagnósticos global
			vim.diagnostic.config({
				virtual_text = {
					prefix = "■",
					spacing = 4,
				},
				signs = true,
				underline = true,
				update_in_insert = false,
				severity_sort = true,
				float = {
					border = "rounded",
					source = "always",
				},
			})

			-- Íconos de diagnósticos
			local signs = {
				Error = " ",
				Warn = " ",
				Hint = " ",
				Info = " ",
			}
			for type, icon in pairs(signs) do
				local hl = "DiagnosticSign" .. type
				vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
			end

			-- ========================================
			-- Configuración de cada LSP usando vim.lsp.config()
			-- ========================================

			-- Lua
			vim.lsp.config("lua_ls", {
				cmd = { vim.fn.stdpath("data") .. "/mason/bin/lua-language-server" },
				filetypes = { "lua" },
				root_markers = { ".luarc.json", ".luarc.jsonc", ".luacheckrc", ".stylua.toml", ".git" },
				capabilities = capabilities,
				on_attach = common_on_attach,
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
			})

			-- TypeScript/JavaScript
			vim.lsp.config("ts_ls", {
				cmd = { "typescript-language-server", "--stdio" },
				filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
				root_markers = { "package.json", "tsconfig.json", "jsconfig.json", ".git" },
				capabilities = capabilities,
				on_attach = common_on_attach,
				settings = {
					typescript = {
						inlayHints = {
							includeInlayParameterNameHints = "all",
							includeInlayFunctionParameterTypeHints = true,
							includeInlayVariableTypeHints = true,
						},
					},
					javascript = {
						inlayHints = {
							includeInlayParameterNameHints = "all",
							includeInlayFunctionParameterTypeHints = true,
							includeInlayVariableTypeHints = true,
						},
					},
				},
			})

			-- HTML
			vim.lsp.config("html", {
				cmd = { "vscode-html-language-server", "--stdio" },
				filetypes = { "html" },
				root_markers = { ".git", "package.json" },
				capabilities = capabilities,
				on_attach = common_on_attach,
			})

			-- CSS
			vim.lsp.config("cssls", {
				cmd = { "vscode-css-language-server", "--stdio" },
				filetypes = { "css", "scss", "less" },
				root_markers = { ".git", "package.json" },
				capabilities = capabilities,
				on_attach = common_on_attach,
				settings = {
					css = {
						validate = true,
						lint = { unknownAtRules = "ignore" },
					},
					scss = {
						validate = true,
						lint = { unknownAtRules = "ignore" },
					},
					less = {
						validate = true,
						lint = { unknownAtRules = "ignore" },
					},
				},
			})

			-- Emmet
			vim.lsp.config("emmet_ls", {
				cmd = { "emmet-ls", "--stdio" },
				filetypes = {
					"html",
					"css",
					"scss",
					"javascript",
					"javascriptreact",
					"typescript",
					"typescriptreact",
				},
				root_markers = { ".git", "package.json" },
				capabilities = capabilities,
				on_attach = common_on_attach,
			})

			-- Tailwind CSS
			vim.lsp.config("tailwindcss", {
				cmd = { "tailwindcss-language-server", "--stdio" },
				filetypes = {
					"html",
					"css",
					"scss",
					"javascript",
					"javascriptreact",
					"typescript",
					"typescriptreact",
				},
				root_markers = { "tailwind.config.js", "tailwind.config.ts", ".git" },
				capabilities = capabilities,
				on_attach = common_on_attach,
				settings = {
					tailwindCSS = {
						validate = true,
						classAttributes = { "class", "className", "classList", "ngClass" },
					},
				},
			})

			-- Python
			vim.lsp.config("pyright", {
				cmd = { "pyright-langserver", "--stdio" },
				filetypes = { "python" },
				root_markers = {
					"pyproject.toml",
					"setup.py",
					"setup.cfg",
					"requirements.txt",
					"Pipfile",
					".git",
				},
				capabilities = capabilities,
				on_attach = common_on_attach,
				settings = {
					python = {
						analysis = {
							typeCheckingMode = "basic",
							autoSearchPaths = true,
							useLibraryCodeForTypes = true,
							diagnosticMode = "workspace",
						},
					},
				},
			})

			--Angular (comentado, descomenta solo en proyectos Angular)
			vim.lsp.config("angularls", {
				cmd = {
					"ngserver",
					"--stdio",
					"--tsProbeLocations",
					vim.fn.getcwd() .. "/node_modules",
					"--ngProbeLocations",
					vim.fn.getcwd() .. "/node_modules",
				},
				filetypes = { "typescript", "html", "typescriptreact" },
				root_markers = { "angular.json", "project.json" },
				capabilities = capabilities,
				on_attach = common_on_attach,
			})

			-- ========================================
			-- Habilitar todos los LSP
			-- Nota: Java (jdtls) se maneja en ftplugin/java.lua
			-- ========================================

			vim.lsp.enable("lua_ls")
			vim.lsp.enable("ts_ls")
			vim.lsp.enable("html")
			vim.lsp.enable("cssls")
			vim.lsp.enable("emmet_ls")
			vim.lsp.enable("tailwindcss")
			vim.lsp.enable("pyright")
			vim.lsp.enable("angularls")  -- Descomenta si usas Angular
		end,
	},
}
