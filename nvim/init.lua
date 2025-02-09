-- ==============================
-- 📌 Configuração da Leader Key
-- ==============================
vim.g.mapleader = ","  -- Define "," como Leader Key
vim.g.maplocalleader = ","

-- ==============================
-- 📌 Substituir ESC por "jk" ou "jj"
-- ==============================
vim.keymap.set('i', 'jk', '<Esc>', { noremap = true, silent = true, desc = "Sair do modo inserção" })
    vim.keymap.set('i', 'jj', '<Esc>', { noremap = true, silent = true, desc = "Sair do modo inserção" })
    

-- ==============================
-- 📌 Gerenciador de Plugins (Lazy.nvim)
-- ==============================
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git", lazypath
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  -- 🔹 LSP e Autocomplete
  "neovim/nvim-lspconfig",
  "hrsh7th/nvim-cmp",
  "hrsh7th/cmp-nvim-lsp",
  "hrsh7th/cmp-buffer",
  "hrsh7th/cmp-path",
  "hrsh7th/cmp-cmdline",
  "hrsh7th/cmp-vsnip",
  "hrsh7th/vim-vsnip",
  
  -- 🔹 Depuração
  "mfussenegger/nvim-dap",
  "rcarriga/nvim-dap-ui", -- GUI do Debugger
  "theHamsta/nvim-dap-virtual-text", -- Exibir valores inline
  "nvim-neotest/nvim-nio", -- Dependência necessária para dap-ui
})

-- ==============================
-- 📌 Configuração do LSP para C#
-- ==============================
local lspconfig = require('lspconfig')

lspconfig.omnisharp.setup {
    cmd = { "C:\\Users\\leand\\AppData\\Local\\omnisharp\\OmniSharp.exe" },
    root_dir = lspconfig.util.root_pattern("*.sln", ".git"),
    on_attach = function(client, bufnr)
        local opts = { noremap=true, silent=true, buffer=bufnr }
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
        vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    end,
}

-- ==============================
-- 📌 Configuração do Autocomplete
-- ==============================
local cmp = require('cmp')

cmp.setup({
    snippet = {
        expand = function(args)
            vim.fn["vsnip#anonymous"](args.body)
        end,
    },
    mapping = {
        ['<C-n>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
        ['<C-p>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
        ['<C-y>'] = cmp.mapping.confirm({ select = true }),
        ['<C-Space>'] = cmp.mapping.complete(),
    },
    sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'buffer' },
        { name = 'path' },
    }),
})

-- ==============================
-- 📌 Configuração do Debugger (DAP) para C#
-- ==============================
local dap = require('dap')
local dapui = require('dapui')
local dap_virtual_text = require("nvim-dap-virtual-text")

dap.adapters.coreclr = {
    type = 'executable',
    command = 'C:\\Users\\leand\\AppData\\Local\\netcoredbg\\netcoredbg.exe',
    args = { '--interpreter=vscode' },
}

dap.configurations.cs = {
    {
        type = 'coreclr',
        request = 'launch',
        name = 'Debug .NET Core',
        program = function()
            return vim.fn.input('Path to DLL: ', vim.fn.getcwd() .. '\\bin\\Debug\\net8.0\\', 'file')
        end,
    },
}

-- ==============================
-- 📌 Mapeamento de Teclas para o Debugger
-- ==============================
local opts = { noremap = true, silent = true, desc = "" }

vim.keymap.set('n', '<Leader>dd', function() dap.continue() end, { desc = "Iniciar/Continuar Debug" })
vim.keymap.set('n', '<Leader>db', function() dap.toggle_breakpoint() end, { desc = "Adicionar/Remover Breakpoint" })
vim.keymap.set('n', '<Leader>dn', function() dap.step_over() end, { desc = "Avançar (Step Over)" })
vim.keymap.set('n', '<Leader>di', function() dap.step_into() end, { desc = "Entrar na Função (Step Into)" })
vim.keymap.set('n', '<Leader>do', function() dap.step_out() end, { desc = "Sair da Função (Step Out)" })
vim.keymap.set('n', '<Leader>dr', function() dap.repl.open() end, { desc = "Abrir Console do Debugger" })
vim.keymap.set('n', '<Leader>dx', function() dap.terminate() end, { desc = "Parar Debug" })
vim.keymap.set('n', '<Leader>du', function() dapui.toggle() end, { desc = "Abrir/Fechar UI do Debugger" })

-- ==============================
-- 📌 Configuração da UI do Debugger
-- ==============================
dapui.setup()
dap_virtual_text.setup()

dap.listeners.after.event_initialized["dapui_config"] = function()
  dapui.open()
end

dap.listeners.before.event_terminated["dapui_config"] = function()
  dapui.close()
end

dap.listeners.before.event_exited["dapui_config"] = function()
  dapui.close()
end
