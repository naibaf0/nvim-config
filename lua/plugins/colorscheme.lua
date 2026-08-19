-- Catppuccin Colorscheme
--
-- LAZY: NO - Colorscheme must load immediately at startup to avoid
-- visual flash/flicker. The `priority = 1000` ensures it loads before
-- any other plugin that might depend on highlight groups.

return {
    ----- Catppuccin {{{--------------------------------------------------------------------------------------------
    {
        "catppuccin/nvim",
        name = "catppuccin",
        priority = 1000,
        lazy = false,
        config = function()
            require("catppuccin").setup({
                flavour = "macchiato", -- latte, frappe, macchiato, mocha
                transparent_background = false,
                show_end_of_buffer = false,
                term_colors = true,
                kitty = true, -- workaround for kitty transparency issue
                dim_inactive = {
                    enabled = true,
                    shade = "dark",
                    percentage = 0.15,
                },
                integrations = {
                    cmp = true,
                    gitsigns = true,
                    leap = true,
                    lsp_trouble = true,
                    mason = true,
                    nvimtree = true,
                    treesitter = true,
                    which_key = true,
                },
            })
            vim.cmd.colorscheme("catppuccin")
        end,
    },
    --}}}-----------------------------------------------------------------------------------------------------------
}
