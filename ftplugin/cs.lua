-- Configuración específica para C# / Unity
-- Este archivo se ejecuta automáticamente al abrir archivos .cs

local root_dir = vim.fs.dirname(vim.fs.find({ "*.sln", "*.csproj", "Assembly-CSharp.csproj" }, {
	upward = true,
})[1])

-- Solo configurar si estamos en un proyecto C#
if not root_dir then
	return
end

-- Función para verificar si es proyecto Unity
local function is_unity_project()
	local assets_dir = root_dir .. "/Assets"
	local project_settings = root_dir .. "/ProjectSettings"
	return vim.fn.isdirectory(assets_dir) == 1 and vim.fn.isdirectory(project_settings) == 1
end

-- Configurar OmniSharp
local omnisharp_bin = vim.fn.stdpath("data") .. "/mason/bin/omnisharp"

-- Verificar si OmniSharp está instalado
if vim.fn.executable(omnisharp_bin) == 0 then
	vim.notify("OmniSharp no encontrado. Instálalo con :Mason", vim.log.levels.WARN)
	return
end

local capabilities = require("cmp_nvim_lsp").default_capabilities()

-- Handlers para ventanas flotantes
local handlers = {
	["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" }),
	["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" }),
}

-- Configuración base de OmniSharp
local omnisharp_config = {
	cmd = { omnisharp_bin, "--languageserver", "--hostPID", tostring(vim.fn.getpid()) },
	capabilities = capabilities,
	handlers = handlers,
	enable_editorconfig_support = true,
	enable_ms_build_load_projects_on_demand = false,
	enable_roslyn_analyzers = true,
	organize_imports_on_format = true,
	enable_import_completion = true,
	sdk_include_prereleases = true,
	analyze_open_documents_only = false,
}

-- Configuración específica para Unity
if is_unity_project() then
	vim.notify("🎮 Proyecto Unity detectado", vim.log.levels.INFO)

	-- Configuración adicional para Unity
	omnisharp_config.cmd = {
		omnisharp_bin,
		"--languageserver",
		"--hostPID",
		tostring(vim.fn.getpid()),
		"--encoding",
		"utf-8",
		"--stdio",
	}

	-- Settings específicos de Unity
	omnisharp_config.settings = {
		FormattingOptions = {
			EnableEditorConfigSupport = true,
			OrganizeImports = true,
		},
		MsBuild = {
			LoadProjectsOnDemand = false,
		},
		RoslynExtensionsOptions = {
			EnableAnalyzersSupport = true,
			EnableImportCompletion = true,
			AnalyzeOpenDocumentsOnly = false,
		},
		Sdk = {
			IncludePrereleases = true,
		},
	}

	-- Keymaps específicos para Unity
	vim.keymap.set("n", "<leader>uc", function()
		vim.cmd("!open -a 'Unity'")
	end, { desc = "Abrir Unity", buffer = true })

	vim.keymap.set("n", "<leader>ur", function()
		vim.lsp.buf.code_action({
			filter = function(action)
				return action.title:match("Generate")
			end,
			apply = true,
		})
	end, { desc = "Unity: Generate code", buffer = true })
end

-- On_attach para C#
local on_attach = function(client, bufnr)
	local opts = { buffer = bufnr, silent = true }

	-- Keymaps estándar
	vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
	vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
	vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
	vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
	vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
	vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
	vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)
	vim.keymap.set("n", "gl", vim.diagnostic.open_float, opts)
	vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
	vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
	vim.keymap.set("n", "<leader>f", function()
		vim.lsp.buf.format({ async = true })
	end, opts)

	-- Keymaps específicos de C#
	vim.keymap.set("n", "<leader>cu", function()
		vim.lsp.buf.code_action({
			context = {
				only = { "source.addUsing" },
			},
			apply = true,
		})
	end, { desc = "Add using statement", buffer = bufnr })

	vim.keymap.set("n", "<leader>cU", function()
		vim.lsp.buf.code_action({
			context = {
				only = { "source.organizeUsings" },
			},
			apply = true,
		})
	end, { desc = "Organize usings", buffer = bufnr })

	-- Resaltar referencias
	if client.server_capabilities.documentHighlightProvider then
		local group = vim.api.nvim_create_augroup("lsp_document_highlight", { clear = false })
		vim.api.nvim_clear_autocmds({ buffer = bufnr, group = group })
		vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
			group = group,
			buffer = bufnr,
			callback = vim.lsp.buf.document_highlight,
		})
		vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
			group = group,
			buffer = bufnr,
			callback = vim.lsp.buf.clear_references,
		})
	end

	vim.diagnostic.enable(true, { bufnr = bufnr })

	-- Mensaje de confirmación
	if is_unity_project() then
		vim.notify("✅ OmniSharp activado para Unity", vim.log.levels.INFO)
	else
		vim.notify("✅ OmniSharp activado para C#", vim.log.levels.INFO)
	end
end

omnisharp_config.on_attach = on_attach

-- Iniciar OmniSharp
vim.lsp.start(omnisharp_config)

-- Configuración de Unity adicional
if is_unity_project() then
	-- Añadir paths comunes de Unity
	vim.opt_local.path:append(root_dir .. "/Assets/**")
	vim.opt_local.path:append(root_dir .. "/Library/ScriptAssemblies")

	-- Autocommands para Unity
	local unity_group = vim.api.nvim_create_augroup("UnityHelpers", { clear = true })

	-- Auto-reload cuando Unity regenera soluciones
	vim.api.nvim_create_autocmd({ "BufWritePost" }, {
		group = unity_group,
		pattern = "*.cs",
		callback = function()
			-- Pequeño delay antes de actualizar
			vim.defer_fn(function()
				vim.cmd("checktime")
			end, 100)
		end,
	})
end

-- Configuración de formateo para C#
vim.bo.tabstop = 4
vim.bo.shiftwidth = 4
vim.bo.expandtab = true
vim.bo.softtabstop = 4
