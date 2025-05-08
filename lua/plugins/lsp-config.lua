return {
	{
		"williamboman/mason.nvim",
		lazy = false,
		config = function()
			require("mason").setup({
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
		config = function()
			local notify = vim.notify
			vim.notify = function(msg, ...)
				if type(msg) == "string" and msg:find("client%.request") then
					return
				end
				return notify(msg, ...)
			end

			local lsp_log_handler = vim.lsp.handlers["window/logMessage"]
			vim.lsp.handlers["window/logMessage"] = function(err, result, ...)
				if result.message:find("deprecated") then
					return
				end
				return lsp_log_handler(err, result, ...)
			end

			vim.lsp.set_log_level("error")

			require("mason-lspconfig").setup({
				ensure_installed = {
					"ts_ls",
					"html",
					"lua_ls",
					"gopls",
					"jdtls", -- 👈 agregado soporte para Java
					"angularls",
				},
				automatic_installation = true,
			})
		end,
	},
	{
		"neovim/nvim-lspconfig",
		lazy = false,
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
		},
		config = function()
			local original_notify = vim.notify
			vim.notify = function(msg, level, opts)
				if type(msg) == "string" and msg:find("client%.request") then
					return
				end
				return original_notify(msg, level, opts)
			end

			local capabilities = require("cmp_nvim_lsp").default_capabilities()
			local lspconfig = require("lspconfig")

			local common_setup = {
				capabilities = capabilities,
				on_attach = function(client, bufnr)
					local opts = { buffer = bufnr, silent = true }
					vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
					vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
					vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
					vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
				end,
			}

			lspconfig.ts_ls.setup(common_setup)
			-- Angular (angular-language-server)
			lspconfig.angularls.setup({
				on_new_config = function(new_config, _)
					new_config.cmd = {
						"ngserver",
						"--stdio",
						"--tsProbeLocations",
						"",
						"--ngProbeLocations",
						"",
					}
				end,
				filetypes = { "typescript", "html", "typescriptreact", "typescript.tsx" },
				root_dir = lspconfig.util.root_pattern("angular.json", "project.json"),
			})
			lspconfig.solargraph.setup(common_setup)
			lspconfig.html.setup(common_setup)

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

			-- 🚀 Configuración para Java (JDTLS)
			lspconfig.jdtls.setup(vim.tbl_deep_extend("force", common_setup, {
				cmd = { "jdtls" },
				root_dir = require("lspconfig.util").root_pattern(".git", "mvnw", "gradlew", "pom.xml", "build.gradle"),
			}))

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

			local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
			for type, icon in pairs(signs) do
				local hl = "DiagnosticSign" .. type
				vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
			end

			local lspconfig = require("lspconfig")
			local util = require("lspconfig.util")

			lspconfig.angularls.setup({
				cmd = {
					"node",
					vim.fn.stdpath("data")
						.. "/mason/packages/angular-language-server/node_modules/@angular/language-server/bin/ngserver",
					"--stdio",
					"--tsProbeLocations",
					vim.fn.stdpath("data") .. "/mason/packages/angular-language-server/node_modules",
					"--ngProbeLocations",
					vim.fn.stdpath("data") .. "/mason/packages/angular-language-server/node_modules",
				},
				filetypes = { "typescript", "html", "typescriptreact", "typescript.tsx" },
				root_dir = util.root_pattern("angular.json", "project.json", "tsconfig.json"),
			})
		end,
	},
}
