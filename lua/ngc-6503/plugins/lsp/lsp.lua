return {
    -- Mason
    {
        "williamboman/mason.nvim",
        config = function()
            require("mason").setup({
                ui = {
                    icons = {
                        package_installed   = "✓",
                        package_pending     = "➜",
                        package_uninstalled = "✗",
                    },
                },
            })
        end,
    },

    -- Mason <-> lspconfig bridge
    {
        "williamboman/mason-lspconfig.nvim",
        dependencies = { "neovim/nvim-lspconfig" },
        config = function()
            require("mason-lspconfig").setup({
                ensure_installed = {
                    "lua_ls",
                    "ts_ls",
                    "html",
                    "cssls",
                    "pyright",
                    "bashls",
                    "vimls",
                    "clangd",
                    "gopls",
                    "tailwindcss",
                    "astro",
                    "emmet_ls",
                },
                automatic_installation = true,
            })
        end,
    },

    -- Core LSP configuration
    {
        "neovim/nvim-lspconfig",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            { "antosha417/nvim-lsp-file-operations", config = true },
        },
        config = function()
            ------------------------------------------------------------------
            -- LSP keymaps
            ------------------------------------------------------------------
            vim.api.nvim_create_autocmd("LspAttach", {
                group = vim.api.nvim_create_augroup("UserLspConfig", {}),
                callback = function(ev)
                    local opts = { buffer = ev.buf, silent = true }

                    vim.keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", vim.tbl_extend("force", opts, { desc = "LSP references" }))
                    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, vim.tbl_extend("force", opts, { desc = "Go to declaration" }))
                    vim.keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", vim.tbl_extend("force", opts, { desc = "LSP definitions" }))
                    vim.keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", vim.tbl_extend("force", opts, { desc = "LSP implementations" }))
                    vim.keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", vim.tbl_extend("force", opts, { desc = "LSP type definitions" }))

                    vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, vim.tbl_extend("force", opts, { desc = "Code actions" }))
                    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, vim.tbl_extend("force", opts, { desc = "Rename symbol" }))

                    vim.keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", vim.tbl_extend("force", opts, { desc = "Buffer diagnostics" }))
                    vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, vim.tbl_extend("force", opts, { desc = "Line diagnostics" }))

                    vim.keymap.set("n", "K", vim.lsp.buf.hover, vim.tbl_extend("force", opts, { desc = "Hover documentation" }))
                    vim.keymap.set("n", "<leader>rs", "<cmd>LspRestart<CR>", vim.tbl_extend("force", opts, { desc = "Restart LSP" }))

                    vim.keymap.set("i", "<C-h>", vim.lsp.buf.signature_help, opts)
                end,
            })

            ------------------------------------------------------------------
            -- Diagnostics
            ------------------------------------------------------------------
            vim.diagnostic.config({
                signs = {
                    text = {
                        [vim.diagnostic.severity.ERROR] = " ",
                        [vim.diagnostic.severity.WARN]  = " ",
                        [vim.diagnostic.severity.HINT]  = "󰠠 ",
                        [vim.diagnostic.severity.INFO]  = " ",
                    },
                },
                virtual_text = true,
                underline = true,
                update_in_insert = false,
            })

            ------------------------------------------------------------------
            -- Capabilities
            ------------------------------------------------------------------
            local capabilities = require("cmp_nvim_lsp").default_capabilities()

            vim.lsp.config("*", {
                capabilities = capabilities,
            })

            ------------------------------------------------------------------
            -- Server-specific configuration
            ------------------------------------------------------------------
            local servers = {
                lua_ls = {
                    settings = {
                        Lua = {
                            diagnostics = { globals = { "vim" } },
                            completion = { callSnippet = "Replace" },
                            workspace = {
                                library = {
                                    [vim.fn.expand("$VIMRUNTIME/lua")] = true,
                                    [vim.fn.stdpath("config") .. "/lua"] = true,
                                },
                            },
                        },
                    },
                },

                ts_ls = {
                    filetypes = {
                        "javascript",
                        "javascriptreact",
                        "typescript",
                        "typescriptreact",
                    },
                    single_file_support = true,
                    init_options = {
                        preferences = {
                            includeCompletionsForModuleExports = true,
                            includeCompletionsForImportStatements = true,
                        },
                    },
                },

                gopls = {
                    settings = {
                        gopls = {
                            analyses = { unusedparams = true },
                            staticcheck = true,
                            gofumpt = true,
                        },
                    },
                },

                emmet_ls = {
                    filetypes = {
                        "html",
                        "typescriptreact",
                        "javascriptreact",
                        "css",
                        "sass",
                        "scss",
                        "less",
                        "svelte",
                    },
                },

                -- Flutter / Dart
                dartls = {
                    cmd = { "dart", "language-server", "--protocol=lsp" },
                    filetypes = { "dart" },
                    init_options = {
                        closingLabels = true,
                        flutterOutline = true,
                        onlyAnalyzeProjectsWithOpenFiles = true,
                        outline = true,
                        suggestFromUnimportedLibraries = true,
                    },
                    settings = {
                        dart = {
                            completeFunctionCalls = true,
                            showTodos = true,
                        },
                    },
                },
            }

            for server, config in pairs(servers) do
                vim.lsp.config(server, config)
                vim.lsp.enable(server)
            end

            -- Enable servers without extra config
            vim.lsp.enable({
                "html",
                "cssls",
                "pyright",
                "bashls",
                "vimls",
                "clangd",
                "astro",
            })
        end,
    },
}

