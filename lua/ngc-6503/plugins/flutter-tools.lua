return {
  "akinsho/flutter-tools.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "stevearc/dressing.nvim",    -- optional for vim.ui
  },
  config = function()

    require("flutter-tools").setup {
      ui = {
        border = "rounded",
      },

      decorations = {
        statusline = {
          app_version = true,
          device      = true,
        },
      },

      debugger = {
        enabled = true,       -- integrates with nvim-dap
        run_via_dap = true,   -- run via dap
      },

      dev_log = {
        enabled = true,
        open_cmd = "15split",  -- open log in split
      },

      outline = {
        open_cmd = "30vnew",
        auto_open = false,
      },

      dev_tools = {
        autostart = false,
        auto_open_browser = false,
      },

      lsp = {
        color = {
          enabled = true,
          virtual_text = true,
        },
        settings = {
          showTodos = true,
          completeFunctionCalls = true,
          renameFilesWithClasses = "prompt",
        },
      },
    }

    -- Flutter commands keymaps
    vim.keymap.set("n", "<leader>fr", ":FlutterRun<CR>")
    vim.keymap.set("n", "<leader>fd", ":FlutterDevices<CR>")
    vim.keymap.set("n", "<leader>fe", ":FlutterEmulators<CR>")
    vim.keymap.set("n", "<leader>fl", ":FlutterLogToggle<CR>")

    -- Hot reload / restart
    vim.keymap.set("n", "<leader>r", ":FlutterReload<CR>")
    vim.keymap.set("n", "<leader>R", ":FlutterRestart<CR>")

  end,
}

