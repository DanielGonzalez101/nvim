-- Configuración moderna de LSP y Mason (Neovim 0.11+)
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
          "lua_ls",
          "ts_ls",
          "angularls",
          "html",
          "cssls",
          "emmet_ls",
          "tailwindcss",
          "pyright",
          "omnisharp",
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
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      -- On_attach mejorado
      local common_on_attach = function(client, bufnr)
        local opts = { buffer = bufnr, silent = true }

        -- Keymaps optimizados
        local keymap = vim.keymap.set
        keymap("n", "K", vim.lsp.buf.hover, opts)
        keymap("n", "gd", vim.lsp.buf.definition, opts)
        keymap("n", "gD", vim.lsp.buf.declaration, opts)
        keymap("n", "gi", vim.lsp.buf.implementation, opts)
        keymap("n", "gr", vim.lsp.buf.references, opts)
        keymap("n", "<leader>rn", vim.lsp.buf.rename, opts)
        keymap({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)
        keymap("n", "gl", vim.diagnostic.open_float, opts)
        keymap("n", "[d", vim.diagnostic.goto_prev, opts)
        keymap("n", "]d", vim.diagnostic.goto_next, opts)
        keymap("n", "<leader>f", function()
          vim.lsp.buf.format({ async = true })
        end, opts)

        -- Resaltar referencias automáticamente
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
      end

      -- Configuración de diagnósticos
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
          header = "",
          prefix = "",
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

      -- Handlers para ventanas flotantes con bordes
      local handlers = {
        ["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" }),
        ["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
          border = "rounded",
        }),
      }

      -- ========================================
      -- Configuración de cada LSP
      -- ========================================

      -- Lua
      vim.lsp.config("lua_ls", {
        cmd = { vim.fn.stdpath("data") .. "/mason/bin/lua-language-server" },
        filetypes = { "lua" },
        root_markers = { ".luarc.json", ".luarc.jsonc", ".luacheckrc", ".stylua.toml", ".git" },
        capabilities = capabilities,
        on_attach = common_on_attach,
        handlers = handlers,
        settings = {
          Lua = {
            runtime = { version = "LuaJIT" },
            diagnostics = {
              globals = { "vim" },
              disable = { "missing-fields" },
            },
            workspace = {
              library = vim.api.nvim_get_runtime_file("", true),
              checkThirdParty = false,
            },
            telemetry = { enable = false },
            hint = {
              enable = true,
              setType = true,
            },
            format = {
              enable = true,
              defaultConfig = {
                indent_style = "space",
                indent_size = "2",
              },
            },
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
        handlers = handlers,
        settings = {
          typescript = {
            inlayHints = {
              includeInlayParameterNameHints = "all",
              includeInlayFunctionParameterTypeHints = true,
              includeInlayVariableTypeHints = true,
              includeInlayPropertyDeclarationTypeHints = true,
              includeInlayFunctionLikeReturnTypeHints = true,
            },
          },
          javascript = {
            inlayHints = {
              includeInlayParameterNameHints = "all",
              includeInlayFunctionParameterTypeHints = true,
              includeInlayVariableTypeHints = true,
              includeInlayPropertyDeclarationTypeHints = true,
              includeInlayFunctionLikeReturnTypeHints = true,
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
        handlers = handlers,
      })

      -- CSS
      vim.lsp.config("cssls", {
        cmd = { "vscode-css-language-server", "--stdio" },
        filetypes = { "css", "scss", "less" },
        root_markers = { ".git", "package.json" },
        capabilities = capabilities,
        on_attach = common_on_attach,
        handlers = handlers,
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
        handlers = handlers,
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
        handlers = handlers,
        settings = {
          tailwindCSS = {
            validate = true,
            classAttributes = { "class", "className", "classList", "ngClass" },
            experimental = {
              classRegex = {
                { "cva\\(([^)]*)\\)", "[\"'`]([^\"'`]*).*?[\"'`]" },
                { "cx\\(([^)]*)\\)", "(?:'|\"|`)([^']*)(?:'|\"|`)" },
              },
            },
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
        handlers = handlers,
        settings = {
          python = {
            analysis = {
              typeCheckingMode = "basic",
              autoSearchPaths = true,
              useLibraryCodeForTypes = true,
              diagnosticMode = "workspace",
              autoImportCompletions = true,
            },
          },
        },
      })

      -- C# / Unity (OmniSharp)
      vim.lsp.config("omnisharp", {
        cmd = {
          vim.fn.stdpath("data") .. "/mason/packages/omnisharp/omnisharp",
        },
        filetypes = { "cs" },
        root_markers = { "*.sln", "*.csproj", ".git" },
        capabilities = capabilities,
        on_attach = common_on_attach,
        handlers = handlers,
        settings = {
          FormattingOptions = {
            EnableEditorConfigSupport = true,
            OrganizeImports = true,
          },
          MsBuild = {
            LoadProjectsOnDemand = true,
          },
          RoslynExtensionsOptions = {
            EnableAnalyzersSupport = true,
            EnableImportCompletion = true,
          },
          Sdk = {
            IncludePrereleases = true,
          },
        },
      })

      -- Angular
      vim.lsp.config("angularls", {
        filetypes = { "typescript", "html", "typescriptreact", "typescript.tsx" },
        root_markers = { "angular.json", "project.json" },
        capabilities = capabilities,
        on_attach = common_on_attach,
        handlers = handlers,
      })

      -- ========================================
      -- Habilitar todos los LSP
      -- ========================================

      vim.lsp.enable("lua_ls")
      vim.lsp.enable("ts_ls")
      vim.lsp.enable("html")
      vim.lsp.enable("cssls")
      vim.lsp.enable("emmet_ls")
      vim.lsp.enable("tailwindcss")
      vim.lsp.enable("pyright")
--      vim.lsp.enable("angularls")
      vim.lsp.enable("omnisharp")
    end,
  },
}
