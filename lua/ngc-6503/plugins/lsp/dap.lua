return {
    "mfussenegger/nvim-dap", 
    version = "4.0.0",
    dependencies = {
        "rcarriga/nvim-dap-ui",
        "nvim-neotest/nvim-nio",
    },
    config = function ()
        local dap = require('dap')
        local dapui = require('dapui')

        -- DAP UI setup
        dapui.setup{}

        -- Open UI automatically on start, close on exit/terminate
        dap.listeners.before.attach.dapui_config = function() dapui.open() end
        dap.listeners.before.launch.dapui_config = function() dapui.open() end
        dap.listeners.before.event_terminated.dapui_config = function() dapui.close() end
        dap.listeners.before.event_exited.dapui_config = function() dapui.close() end

        --
        -- ─── C/C++/RUST ADAPTERS ─────────────────────────────────────────────────────
        --

        dap.adapters.codelldb = {
            type = 'server',
            port = "${port}",
            executable = {
                command = 'codelldb',   -- your codelldb binary
                args = {"--port", "${port}"},
            }
        }

        dap.configurations.cpp = {
            {
                name = "Launch file",
                type = "codelldb",
                request = "launch",
                program = function()
                    return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
                end,
                cwd = '${workspaceFolder}',
                stopOnEntry = false,
            },
        }
        dap.configurations.c = dap.configurations.cpp
        dap.configurations.rust = dap.configurations.cpp

        --
        -- ─── DART / FLUTTER ADAPTERS ────────────────────────────────────────────────
        --

        -- Dart/Flutter adapter using Flutter debug_adapter
        dap.adapters.dart = {
            type = "executable",
            command = "flutter",
            args = { "debug_adapter" },
        }

        dap.configurations.dart = {
            {
                name = "Launch Flutter",
                type = "dart",
                request = "launch",
                program = "${workspaceFolder}/lib/main.dart",
                cwd = "${workspaceFolder}",
            },
            {
                name = "Launch Dart File",
                type = "dart",
                request = "launch",
                program = "${file}",
                cwd = "${workspaceFolder}",
            },
        }

        --
        -- ─── GLOBAL DEBUG KEYMAPS ────────────────────────────────────────────────────
        --

        local opts = { noremap = true, silent = true }
        vim.api.nvim_set_keymap('n', '<F9>',  "<cmd>lua require'dap'.toggle_breakpoint()<CR>", opts)
        vim.api.nvim_set_keymap('n', '<F5>',  "<cmd>lua require'dap'.continue()<CR>",         opts)
        vim.api.nvim_set_keymap('n', '<F10>', "<cmd>lua require'dap'.step_over()<CR>",       opts)
        vim.api.nvim_set_keymap('n', '<F11>', "<cmd>lua require'dap'.step_into()<CR>",       opts)
        vim.api.nvim_set_keymap('n', '<F12>', "<cmd>lua require'dap'.step_out()<CR>",        opts)

    end
}

