return {
	"nvim-java/nvim-java",
	dependencies = {
		"nvim-java/lua-async-await",
		"nvim-java/nvim-java-core",
		"nvim-java/nvim-java-test",
		"nvim-java/nvim-java-dap",
		--"nvim-java/nvim-java-manager", -- ⬅️ Este es el que falta
		"MunifTanjim/nui.nvim",
		"neovim/nvim-lspconfig",
		"mfussenegger/nvim-dap",
		"mfussenegger/nvim-jdtls",
	},
	ft = { "java" },
	config = function()
		local bundles = {
			vim.fn.glob(
				"~/.local/share/nvim-java/bundles/java-debug/com.microsoft.java.debug.plugin/target/com.microsoft.java.debug.plugin.jar",
				1
			),
		}

		vim.list_extend(
			bundles,
			vim.split(vim.fn.glob("~/.local/share/nvim-java/bundles/vscode-java-test/server/*.jar", 1), "\n")
		)

		require("jdtls").start_or_attach({
			cmd = { "java-lsp" },
			root_dir = vim.fn.getcwd(),
			init_options = {
				bundles = bundles,
			},
		})

		require("java").setup({
			jdk = { auto_install = true },
			jdtls = {
				settings = {
					java = {
						configuration = {
							updateBuildConfiguration = "interactive",
							runtimes = {
								{
									name = "JavaSE-17",
									path = "/usr/lib/jvm/java-17-openjdk-amd64", -- ajusta este path
								},
							},
						},
					},
				},
				init_options = {
					bundles = require("java").get_bundles(),
				},
			},
		})
	end,
}
