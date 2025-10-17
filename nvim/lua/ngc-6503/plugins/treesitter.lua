return {
    "nvim-treesitter/nvim-treesitter",
    event = { "BufReadPre", "BufNewFile" },
    build = ":TSUpdate",
    config = function()
        -- import nvim-treesitter plugin
        local treesitter = require("nvim-treesitter.configs")

        -- configure treesitter
        treesitter.setup({  
            highlight = { enable = true },
            indent = { enable = true },

            -- ensure these languages parsers are installed
            ensure_installed = {
                "json",
                "javascript",
                "typescript",
                "tsx",
                "html",
                "css",
                "python",
                "http",
                "markdown",
                "bash",
                "lua",
                "vim",
                "gitignore",
                "c",
                "cpp",
            },
        })
    end,
}
