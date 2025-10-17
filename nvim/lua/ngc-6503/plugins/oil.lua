return {
    'stevearc/oil.nvim',
    dependencies = { "nvim-tree/nvim-web-devicons" },
    lazy = false,
    config = function()
        require("oil").setup({
            default_file_explorer = true,
            columns = {
                "icon",
            },
            keymaps = {
                ["<C-h>"] = false,
                ["<C-c>"] = false,
                ["<C-v>"] = { "actions.select", opts = { vertical = true } },
                ["<C-h>"] = { "actions.select", opts = { horizontal = true } },
                ["<C-p>"] = "actions.preview",
                ["q"] = "actions.close",
            },
            delete_to_trash = true,
            view_options = {
                show_hidden = true,
            },
            skip_confirm_for_simple_acts = true,
            float = {
                border = "rounded",
            }
        })

        vim.keymap.set("n", "-", require("oil").toggle_float, { desc = "Open parent directory in float" })
    end,
}
