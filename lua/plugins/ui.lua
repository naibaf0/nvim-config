-- UI plugins: lualine, tabline, devicons
return {
    -- File icons
    {
        "nvim-tree/nvim-web-devicons",
        lazy = true,
    },

    -- Tabline
    {
        "kdheepak/tabline.nvim",
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

    -- Status line
    {
        "nvim-lualine/lualine.nvim",
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
}
