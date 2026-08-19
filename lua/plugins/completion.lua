-- Completion, snippets, and LSP plugins
--
-- LAZY STRATEGY:
-- - mason: YES (cmd) - Package manager UI only when running :Mason
-- - mason-lspconfig: Loaded as dependency of lspconfig
-- - LuaSnip: Loaded as dependency of nvim-cmp
-- - nvim-cmp: YES (InsertEnter) - Completion only needed in insert mode
-- - lsp_signature: YES (LspAttach) - Only after LSP connects to buffer
-- - clangd_extensions: YES (ft) - Only for C/C++ files
-- - ltex-extra: YES (ft) - Only for tex/markdown files
-- - trouble: YES (cmd/keys) - Diagnostics panel only when invoked
-- - lspconfig: YES (BufReadPre) - LSP only when opening files

return {
    ----- Mason {{{-------------------------------------------------------------------------------------------------
    {
        "williamboman/mason.nvim",
        cmd = "Mason",
        build = ":MasonUpdate",
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
    --}}}-----------------------------------------------------------------------------------------------------------

    ----- Mason-lspconfig {{{---------------------------------------------------------------------------------------
    {
        "williamboman/mason-lspconfig.nvim",
        lazy = true,
        dependencies = { "williamboman/mason.nvim" },
        config = function()
            require("mason-lspconfig").setup()
        end,
    },
    --}}}-----------------------------------------------------------------------------------------------------------

    ----- LuaSnip {{{-----------------------------------------------------------------------------------------------
    {
        "L3MON4D3/LuaSnip",
        lazy = true,
        dependencies = {
            "rafamadriz/friendly-snippets",
        },
        config = function()
            require("luasnip.loaders.from_vscode").lazy_load()
        end,
    },
    --}}}-----------------------------------------------------------------------------------------------------------

    ----- nvim-cmp {{{----------------------------------------------------------------------------------------------
    {
        "hrsh7th/nvim-cmp",
        event = "InsertEnter",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-omni",
            "saadparwaiz1/cmp_luasnip",
            "onsails/lspkind.nvim",
            "L3MON4D3/LuaSnip",
        },
        config = function()
            local cmp = require("cmp")
            local luasnip = require("luasnip")
            local lspkind = require("lspkind")

            cmp.setup({
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end,
                },
                window = {
                    documentation = {
                        border = "rounded",
                        max_height = 15,
                        max_width = 50,
                        zindex = 16,
                    },
                },
                formatting = {
                    fields = { "menu", "abbr", "kind" },
                    format = lspkind.cmp_format({
                        mode = "symbol_text",
                        maxwidth = 50,
                        ellipsis_char = "...",
                        before = function(entry, vim_item)
                            return vim_item
                        end,
                    }),
                },
                mapping = cmp.mapping.preset.insert({
                    ["<C-d>"] = cmp.mapping.scroll_docs(-4),
                    ["<C-f>"] = cmp.mapping.scroll_docs(4),
                    ["<C-Space>"] = cmp.mapping.complete(),
                    ["<C-e>"] = cmp.mapping.abort(),
                    ["<CR>"] = cmp.mapping.confirm({
                        behavior = cmp.ConfirmBehavior.Replace,
                        select = true,
                    }),
                    ["<Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_next_item()
                        elseif luasnip.expand_or_jumpable() then
                            luasnip.expand_or_jump()
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                    ["<S-Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item()
                        elseif luasnip.jumpable(-1) then
                            luasnip.jump(-1)
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                }),
                sources = {
                    { name = "luasnip", keyword_length = 2 },
                    { name = "nvim_lsp", keyword_length = 3 },
                    { name = "path" },
                    { name = "omni" },
                    { name = "buffer", keyword_length = 3 },
                },
            })
        end,
    },
    --}}}-----------------------------------------------------------------------------------------------------------

    ----- lsp_signature {{{-----------------------------------------------------------------------------------------
    {
        "ray-x/lsp_signature.nvim",
        event = "LspAttach",
        config = function()
            require("lsp_signature").setup({
                bind = true,
                doc_lines = 2,
                floating_window = true,
                fix_pos = false,
                hint_enable = true,
                hint_prefix = "🐼 ",
                hint_scheme = "String",
                use_lspsaga = false,
                hi_parameter = "Search",
                max_height = 12,
                max_width = 120,
                transpancy = 10,
                handler_opts = {
                    border = "rounded",
                },
                trigger_on_newline = false,
                extra_trigger_chars = {},
                zindex = 200,
                debug = false,
                log_path = "debug_log_file_path",
                padding = "",
                shadow_blend = 36,
                shadow_guibg = "Black",
                toggle_key = "<M-o>",
            })
        end,
    },
    --}}}-----------------------------------------------------------------------------------------------------------

    ----- clangd_extensions {{{-------------------------------------------------------------------------------------
    {
        "p00f/clangd_extensions.nvim",
        ft = { "c", "cpp" },
    },
    --}}}-----------------------------------------------------------------------------------------------------------

    ----- ltex-extra {{{--------------------------------------------------------------------------------------------
    {
        "barreiroleo/ltex-extra.nvim",
        ft = { "tex", "bib", "markdown" },
    },
    --}}}-----------------------------------------------------------------------------------------------------------

    ----- Trouble {{{-----------------------------------------------------------------------------------------------
    {
        "folke/trouble.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        cmd = { "Trouble", "TroubleToggle" },
        keys = {
            { "<leader>d", "<cmd>TroubleToggle<cr>", desc = "Toggle Trouble" },
            { "tt", "<cmd>TroubleToggle<cr>", desc = "Toggle Trouble" },
        },
        config = function()
            require("trouble").setup()
        end,
    },
    --}}}-----------------------------------------------------------------------------------------------------------

    ----- nvim-lspconfig {{{----------------------------------------------------------------------------------------
    {
        "neovim/nvim-lspconfig",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = {
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
            "hrsh7th/cmp-nvim-lsp",
            "folke/trouble.nvim",
            "barreiroleo/ltex-extra.nvim",
        },
        config = function()
            require("config.lsp")
        end,
    },
    --}}}-----------------------------------------------------------------------------------------------------------
}
