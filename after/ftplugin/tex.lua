--setlocal conceallevel=2 concealcursor=nv
vim.opt.conceallevel = 2

-- Sets the modes in which text in the cursor line can also be concealed.
vim.opt.concealcursor = 'nv'

-- nvim-cmp setup
local cmp = require 'cmp'
local lspkind = require 'lspkind'
cmp.setup {
    snippet = {
        expand = function(args)
              luasnip.lsp_expand(args.body)
        end,
    },
    window = {
        documentation = {
            border = 'rounded',
            max_height = 15,
            max_width = 50,
            zindex = 16,
        }
  },
    formatting = {
        fields = {'menu', 'abbr', 'kind'},
        format = lspkind.cmp_format({
            mode = 'symbol_text', -- show only symbol annotations
            maxwidth = 50, -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
            ellipsis_char = '...', -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)

            -- The function below will be called before any actual modifications from lspkind
            -- so that you can provide more controls on popup customization. (See [#30](https://github.com/onsails/lspkind-nvim/pull/30))
            before = function (entry, vim_item)
                vim_item.menu = ({
                    omni = (vim.inspect(vim_item.menu):gsub('%"', "")),
                    buffer = "[Buffer]",
                    -- formatting for other sources
                })[entry.source.name]
            ---...
            return vim_item
            end
        })
    },
    mapping = cmp.mapping.preset.insert({
        ['<C-d>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.abort(),
        ['<CR>'] = cmp.mapping.confirm {
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
        },
        ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
            else
                fallback()
            end
        end, { 'i', 's' }),
        ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end, { 'i', 's' }),
    }),
    sources = {
        { name = 'luasnip', keyword_length = 2 },
        { name = 'omni' },
        { name = 'nvim_lsp', keyword_length = 3 },
        { name = 'path' },
        { name = 'buffer', keyword_length = 3 }
    }
}
--}}}---------------------------------------------------------------------------------------------------------------
