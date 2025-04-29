-- 📁 lua/plugins/java_runner.lua
local Terminal = require("toggleterm.terminal").Terminal

local function run_in_toggleterm(cmd)
    local term = Terminal:new({
        cmd = cmd,
        hidden = true,
        direction = "float",
        close_on_exit = false,
    })
    term:toggle()
end

vim.api.nvim_create_user_command("JavaBuild", function()
    local file = vim.fn.expand("%:p")
    if file:sub(-5) ~= ".java" then
        print("Este no es un archivo .java")
        return
    end
    local cmd = "javac " .. file
    run_in_toggleterm(cmd)
end, {})

vim.api.nvim_create_user_command("JavaRun", function()
    local file = vim.fn.expand("%:p")
    if file:sub(-5) ~= ".java" then
        print("Este no es un archivo .java")
        return
    end
    local filename = vim.fn.expand("%:t:r")
    local dir = vim.fn.expand("%:p:h")
    local cmd = string.format("cd %s && javac %s.java && java %s", dir, filename, filename)
    run_in_toggleterm(cmd)
end, {})
