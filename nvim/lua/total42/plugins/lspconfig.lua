return {
    "neovim/nvim-lspconfig",
    config = function()
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
    end,
}
