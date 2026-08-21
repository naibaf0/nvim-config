-- Treesitter syntax highlighting and parsing
--
-- LAZY: YES (BufReadPost/BufNewFile) - Treesitter is only needed when
-- actually viewing file content. No need to load on empty nvim startup.
-- Using BufReadPost (after file is read) to ensure file content exists.

return {
    ----- Treesitter {{{--------------------------------------------------------------------------------------------
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        event = { "BufReadPost", "BufNewFile" },
        config = function()
            require("nvim-treesitter").setup({
                highlight = {
                    enable = true,
                },
                incremental_selection = {
                    enable = true,
                    keymaps = {
                        init_selection = "ga",
                        node_incremental = "ga",
                        node_decremental = "gz",
                    },
                },
                textobjects = {
                    select = {
                        enable = true,
                        lookahead = true,
                        keymaps = {
                            ["af"] = "@function.outer",
                            ["if"] = "@function.inner",
                            ["ac"] = "@class.outer",
                            ["ic"] = "@class.inner",
                            ["ia"] = "@parameter.inner",
                        },
                    },
                    swap = {
                        enable = true,
                        swap_previous = {
                            ["{a"] = "@parameter.inner",
                        },
                        swap_next = {
                            ["}a"] = "@parameter.inner",
                        },
                    },
                    move = {
                        enable = true,
                        set_jumps = true,
                        goto_next_start = {
                            ["]f"] = "@function.outer",
                            ["]c"] = "@class.outer",
                            ["]a"] = "@parameter.inner",
                        },
                        goto_next_end = {
                            ["]F"] = "@function.outer",
                            ["]C"] = "@class.outer",
                        },
                        goto_previous_start = {
                            ["[f"] = "@function.outer",
                            ["[c"] = "@class.outer",
                            ["[a"] = "@parameter.inner",
                        },
                        goto_previous_end = {
                            ["[F"] = "@function.outer",
                            ["[C"] = "@class.outer",
                        },
                    },
                },
                ensure_installed = {
                    "dockerfile",
                    "go",
                    "json",
                    "lua",
                    "python",
                    "yaml",
                },
            })
        end,
    },
    --}}}-----------------------------------------------------------------------------------------------------------
}
