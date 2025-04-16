local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node

return {
    -- Snippet para Makefile de proyecto Go
    s("makego", {
        t({
            "# Ruta al punto de entrada de la app",
            "CMD_PATH := ./cmd/app",
            "OUTPUT := bin/app",
            "",
            "# Ejecuta la app",
            "run:",
            "\tgo run $(CMD_PATH)",
            "",
            "# Compila para el sistema actual",
            "build:",
            "\t@mkdir -p bin",
            "\tgo build -o $(OUTPUT) $(CMD_PATH)",
            "",
            "# Compila un .exe para Windows (desde Linux o Mac)",
            "build-win:",
            "\t@mkdir -p bin",
            "\tGOOS=windows GOARCH=amd64 go build -o $(OUTPUT).exe $(CMD_PATH)",
            "",
            "# Ejecuta los tests",
            "test:",
            "\tgo test ./...",
            "",
            "# Limpia binarios",
            "clean:",
            "\trm -rf bin/*",
        }),
    }),
}
