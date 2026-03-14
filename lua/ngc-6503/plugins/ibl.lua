return {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    ---@module "ibl"
    ---@type ibl.config
    opts = {
        scope = {
            show_start = true, -- Show the start of the scope block
            show_end = true,   -- Show the end of the scope block (like `end` keyword)
            -- Other scope options available via :help ibl.config.scope
        },
        indent = {
            char = "│",
        },
    },

    vim.api.nvim_set_hl(0, "IblIndent", { fg = "#403d52" }),  -- highlight_med
    vim.api.nvim_set_hl(0, "IblScope",  { fg = "#6e6a86" })  -- muted


}
