local kind_icons = {
  Text          = "󰉿", -- nf-md-text
  Method        = "󰊕", -- nf-md-function_variant
  Function      = "󰊕", -- same as method
  Constructor   = "󰒓", -- nf-md-plus_circle
  Field         = "󰜢", -- nf-md-code_tags
  Variable      = "󰀫", -- nf-md-variable
  Class         = "󰠱", -- nf-md-alpha_c_box
  Interface     = "󰠱", -- same icon for now
  Module        = "󰏗", -- nf-md-view_module
  Property      = "󰖷", -- nf-md-home_variant
  Unit          = "󰑭", -- nf-md-ruler
  Value         = "󰎠", -- nf-md-decimal
  Enum          = "󰕘", -- nf-md-format_list_numbers
  Keyword       = "󰌋", -- nf-md-key_variant
  Snippet       = "󰘍", -- nf-md-code_braces
  Color         = "󰏘", -- nf-md-palette
  File          = "󰈙", -- nf-md-file
  Reference     = "󰈇", -- nf-md-link_variant
  Folder        = "󰉋", -- nf-md-folder
  EnumMember    = "󰕘", -- nf-md-format_list_numbers
  Constant      = "󰏿", -- nf-md-alpha_c
  Struct        = "󰙅", -- nf-md-code_braces_box
  Event         = "󰉁", -- nf-md-calendar
  Operator      = "󰆕", -- nf-md-plus
  TypeParameter = "󰊄", -- nf-md-code_string
}

return {
    -- Autocompletion
    'hrsh7th/nvim-cmp',
    dependencies = {
        'hrsh7th/cmp-nvim-lsp',
        'hrsh7th/cmp-buffer',
        'hrsh7th/cmp-path',
        'hrsh7th/cmp-cmdline',
        'L3MON4D3/LuaSnip',
        'saadparwaiz1/cmp_luasnip',
        'rafamadriz/friendly-snippets',
    },
    config = function()
        local cmp = require('cmp')
        local luasnip = require('luasnip')

        -- Load VSCode-style snippets
        require("luasnip.loaders.from_vscode").lazy_load()

        cmp.setup({
            snippet = {
                expand = function(args)
                    luasnip.lsp_expand(args.body)
                end,
            },
            window = {
                completion = cmp.config.window.bordered(),
                documentation = cmp.config.window.bordered(),
            },
            mapping = cmp.mapping.preset.insert({
                ['<C-b>'] = cmp.mapping.scroll_docs(-4),
                ['<C-f>'] = cmp.mapping.scroll_docs(4),
                ['<C-Space>'] = cmp.mapping.complete(),
                ['<C-e>'] = cmp.mapping.abort(),
                ['<CR>'] = cmp.mapping.confirm({ select = true }),
                ['<Tab>'] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_next_item()
                    elseif luasnip.expand_or_jumpable() then
                        luasnip.expand_or_jump()
                    else
                        fallback()
                    end
                end, { "i", "s" }),
                ['<S-Tab>'] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_prev_item()
                    elseif luasnip.jumpable(-1) then
                        luasnip.jump(-1)
                    else
                        fallback()
                    end
                end, { "i", "s" }),
            }),
            sources = cmp.config.sources({
                { name = 'nvim_lsp' },
                { name = 'luasnip' },
            }, {
                { name = 'buffer' },
                { name = 'path' },
            }),

            -- Add icons
            formatting = {
                format = function(entry, vim_item)
                    vim_item.kind = string.format("%s %s", kind_icons[vim_item.kind] or "", vim_item.kind)
                    vim_item.menu = ({
                        nvim_lsp = "[LSP]",
                        luasnip  = "[Snip]",
                        buffer   = "[Buf]",
                        path     = "[Path]",
                    })[entry.source.name]
                    return vim_item
                end,
            },
        })

        -- Use buffer source for `/` and `?`
        cmp.setup.cmdline({ '/', '?' }, {
            mapping = cmp.mapping.preset.cmdline(),
            sources = {
                { name = 'buffer' }
            }
        })

        -- Use cmdline & path source for ':'
        cmp.setup.cmdline(':', {
            mapping = cmp.mapping.preset.cmdline(),
            sources = cmp.config.sources({
                { name = 'path' }
            }, {
                { name = 'cmdline' }
            }),
            matching = { disallow_symbol_nonprefix_matching = false }
        })
    end
}

