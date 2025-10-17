return {
    "mfussenegger/nvim-dap", 
    version = "4.0.0",
    dependencies = {'rcarriga/nvim-dap-ui', "nvim-neotest/nvim-nio"},
    config = function ()
        local dap = require('dap')

        local dapui = require('dapui')

        dapui.setup{}

        -- attach dapui to dap
        dap.listeners.before.attach.dapui_config = function()
            dapui.open()
        end
        dap.listeners.before.launch.dapui_config = function()
            dapui.open()
        end
        dap.listeners.before.event_terminated.dapui_config = function()
            dapui.close()
        end
        dap.listeners.before.event_exited.dapui_config = function()
            dapui.close()
        end

        dap.adapters.codelldb = {
            type = 'server',
            port = "${port}",
            executable = {
                -- CHANGE THIS to your path!
                command = 'codelldb',
                args = {"--port", "${port}"},

                -- On windows you may have to uncomment this:
                -- detached = false,
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

        -- some keymaps from vscode & vs
        local opts = { noremap=true, silent=true }
        vim.api.nvim_set_keymap('n', '<F9>', "<cmd>lua require'dap'.toggle_breakpoint()<CR>", opts)
        vim.api.nvim_set_keymap('n', '<F5>', "<cmd>lua require'dap'.continue()<CR>", opts)
        vim.api.nvim_set_keymap('n', '<F10>', "<cmd>lua require'dap'.step_over()<CR>", opts)
        vim.api.nvim_set_keymap('n', '<F11>', "<cmd>lua require'dap'.step_into()<CR>", opts)
    end
}
