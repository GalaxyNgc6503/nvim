return {
    -- Mason for managing LSP servers
    {
        "williamboman/mason.nvim",
        config = function()
            require("mason").setup({
                ui = {
                    icons = {
                        package_installed = "✓",
                        package_pending = "➜",
                        package_uninstalled = "✗",
                    },
                },
            })
        end,
    },

    -- Mason bridge for lspconfig
    {
        "williamboman/mason-lspconfig.nvim",
        dependencies = {
            "neovim/nvim-lspconfig",
        },
        config = function()
            require("mason-lspconfig").setup({
                ensure_installed = {
                    "ts_ls",
                    "html",
                    "cssls",
                    "pyright",
                    "bashls",
                    "lua_ls",
                    "vimls",
                    "clangd",
                },
                automatic_installation = true,
            })
        end,
    },

    -- LSP configs
    {
        "neovim/nvim-lspconfig",
        config = function()
            local lspconfig = require("lspconfig")

            -- Capabilities from nvim-cmp
            local capabilities = require("cmp_nvim_lsp").default_capabilities()
            capabilities.textDocument.positionEncoding = "utf-16"

            -- Your full keymap set
            local on_attach = function(_, bufnr)
                local opts = { buffer = bufnr }
                local keymap = vim.keymap.set

                -- LSP core navigation
                keymap("n", "K", vim.lsp.buf.hover, opts)
                keymap("n", "gd", vim.lsp.buf.definition, opts)
                keymap("n", "gD", vim.lsp.buf.declaration, opts)
                keymap("n", "gi", vim.lsp.buf.implementation, opts)
                keymap("n", "go", vim.lsp.buf.type_definition, opts)
                keymap("n", "gr", vim.lsp.buf.references, opts)
                keymap("n", "gs", vim.lsp.buf.signature_help, opts)

                -- LSP actions
                keymap("n", "<F2>", vim.lsp.buf.rename, opts)
                keymap({ "n", "x" }, "<F3>", function()
                    vim.lsp.buf.format({ async = true })
                end, opts)
                keymap("n", "<F4>", vim.lsp.buf.code_action, opts)
                keymap("n", "<leader>a", vim.lsp.buf.code_action, opts)

                -- Diagnostics
                keymap("n", "[d", vim.diagnostic.goto_prev, opts)
                keymap("n", "]d", vim.diagnostic.goto_next, opts)
                keymap("n", "<leader>e", vim.diagnostic.open_float, opts)
                keymap("n", "<leader>q", vim.diagnostic.setloclist, opts)
            end

            -- Servers
            local servers = {
                "ts_ls",
                "html",
                "cssls",
                "pyright",
                "bashls",
                "lua_ls",
                "vimls",
                "clangd",
            }

            for _, server in ipairs(servers) do
                lspconfig[server].setup({
                    on_attach = on_attach,
                    capabilities = capabilities,
                })
            end
        end,
    },
}

