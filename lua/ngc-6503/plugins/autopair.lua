-- plugin spec / config for nvim-autopairs + nvim-cmp integration
return {
  "windwp/nvim-autopairs",
  event = "InsertEnter",        -- lazy‑load on entering Insert mode
  dependencies = { "hrsh7th/nvim-cmp" },  -- ensure cmp is loaded too
  config = function()
    local status_ok, npairs = pcall(require, "nvim-autopairs")
    if not status_ok then
      vim.notify("nvim-autopairs not found", vim.log.levels.WARN)
      return
    end

    -- Basic autopairs setup
    npairs.setup({
      check_ts = true,  -- use Treesitter to avoid unwanted pair insertion
      ts_config = {
        lua        = { "string" },           -- don't auto‑pair inside Lua string nodes
        javascript = { "template_string" }, -- skip template strings in JS
        java       = false,
      },
    })

    -- Setup integration with nvim-cmp: after confirming a completion item, autopairs will trigger
    local cmp_autopairs = require("nvim-autopairs.completion.cmp")

    local cmp_ok, cmp = pcall(require, "cmp")
    if not cmp_ok then
      vim.notify("nvim-cmp not found — autopairs cmp integration skipped", vim.log.levels.WARN)
      return
    end

    cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
  end,
}

