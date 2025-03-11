return {
    "mfussenegger/nvim-dap",
    dependencies = {
        "rcarriga/nvim-dap-ui",
        "theHamsta/nvim-dap-virtual-text",
        "nvim-neotest/nvim-nio",
    },
    config = function()
        local dap = require('dap')
        local dapui = require('dapui')
        local dap_virtual_text = require("nvim-dap-virtual-text")

        -- Configuração do adaptador para C#
        dap.adapters.coreclr = {
            type = 'executable',
            command = 'C:\\Users\\leand\\AppData\\Local\\netcoredbg\\netcoredbg.exe',
            args = { '--interpreter=vscode' },
        }

        -- Configurações específicas para C#
        dap.configurations.cs = {
            {
                type = 'coreclr',
                request = 'launch',
                name = 'Debug .NET Core',
                program = function()
                    return vim.fn.input('Caminho para o DLL: ', vim.fn.getcwd() .. '\\bin\\Debug\\net8.0\\', 'file')
                end,
            },
        }

        -- Configuração da UI do Debugger
        dapui.setup()
        dap_virtual_text.setup()

        -- Abrir e fechar automaticamente a UI do Debugger
        dap.listeners.after.event_initialized["dapui_config"] = function()
            dapui.open()
        end
        dap.listeners.before.event_terminated["dapui_config"] = function()
            dapui.close()
        end
        dap.listeners.before.event_exited["dapui_config"] = function()
            dapui.close()
        end

        -- Mapeamento de teclas para o Debugger
        local opts = { noremap = true, silent = true }
        vim.keymap.set('n', '<Leader>dd', dap.continue, { desc = "Iniciar/Continuar Debug", unpack(opts) })
        vim.keymap.set('n', '<Leader>db', dap.toggle_breakpoint, { desc = "Adicionar/Remover Breakpoint", unpack(opts) })
        vim.keymap.set('n', '<Leader>dn', dap.step_over, { desc = "Avançar (Step Over)", unpack(opts) })
        vim.keymap.set('n', '<Leader>di', dap.step_into, { desc = "Entrar na Função (Step Into)", unpack(opts) })
        vim.keymap.set('n', '<Leader>do', dap.step_out, { desc = "Sair da Função (Step Out)", unpack(opts) })
        vim.keymap.set('n', '<Leader>dr', dap.repl.open, { desc = "Abrir Console do Debugger", unpack(opts) })
        vim.keymap.set('n', '<Leader>dx', dap.terminate, { desc = "Parar Debug", unpack(opts) })
        vim.keymap.set('n', '<Leader>du', dapui.toggle, { desc = "Abrir/Fechar UI do Debugger", unpack(opts) })
    end,
}
