-- UI plugins: lualine, tabline, devicons
--
-- LAZY STRATEGY:
-- - devicons: YES (lazy=true) - Only loaded as dependency when needed
-- - tabline: NO - Must be visible immediately on startup
-- - lualine: NO - Statusline must be visible immediately on startup

return {
    ----- nvim-web-devicons (loaded as dependency) {{{--------------------------------------------------------------
    {
        "nvim-tree/nvim-web-devicons",
        lazy = true,
    },
    --}}}-----------------------------------------------------------------------------------------------------------

    ----- Tabline {{{-----------------------------------------------------------------------------------------------
    {
        "kdheepak/tabline.nvim",
        lazy = false,
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            require("tabline").setup({
                enable = false,
                options = {
                    show_bufnr = true,
                },
            })
        end,
    },
    --}}}-----------------------------------------------------------------------------------------------------------

    ----- Lualine {{{-----------------------------------------------------------------------------------------------
    {
        "nvim-lualine/lualine.nvim",
        lazy = false,
        dependencies = {
            "nvim-tree/nvim-web-devicons",
            "kdheepak/tabline.nvim",
        },
        config = function()
            local function diff_source()
                local gitsigns = vim.b.gitsigns_status_dict
                if gitsigns then
                    return {
                        added = gitsigns.added,
                        modified = gitsigns.changed,
                        removed = gitsigns.removed,
                    }
                end
            end

            require("lualine").setup({
                options = {
                    theme = "catppuccin",
                },
                extensions = {
                    "fugitive",
                    "fzf",
                    "nvim-tree",
                },
                sections = {
                    lualine_b = {
                        { "b:gitsigns_head", icon = "" },
                        { "diff", source = diff_source },
                        "diagnostics",
                    },
                },
                tabline = {
                    lualine_a = {},
                    lualine_b = {},
                    lualine_c = { require("tabline").tabline_buffers },
                    lualine_x = { require("tabline").tabline_tabs },
                    lualine_y = {},
                    lualine_z = {},
                },
            })
        end,
    },
    --}}}-----------------------------------------------------------------------------------------------------------
}
