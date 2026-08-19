-- Telescope fuzzy finder
return {
    {
        "nvim-telescope/telescope.nvim",
        branch = "0.1.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            {
                "nvim-telescope/telescope-fzf-native.nvim",
                build = "make",
            },
            "nvim-telescope/telescope-ui-select.nvim",
        },
        cmd = "Telescope",
        keys = {
            { "fb", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
            { "ff", "<cmd>Telescope find_files<cr>", desc = "Find file" },
            { "fg", "<cmd>Telescope live_grep<cr>", desc = "Live Grep" },
            { "fvb", "<cmd>Telescope git_branches<cr>", desc = "Git branches" },
            { "fvc", "<cmd>Telescope git_commits<cr>", desc = "Git commits" },
            { "fvf", "<cmd>Telescope git_files<cr>", desc = "Git files" },
            { "fvh", "<cmd>Telescope git_bcommits<cr>", desc = "Buffer git history" },
        },
        config = function()
            local telescope = require("telescope")
            telescope.setup({
                defaults = {
                    vimgrep_arguments = {
                        "rg",
                        "--color=never",
                        "--no-heading",
                        "--with-filename",
                        "--line-number",
                        "--column",
                        "--smart-case",
                        "--trim",
                    },
                },
                extensions = {
                    fzf = {
                        fuzzy = true,
                        override_generic_sorter = true,
                        override_file_sorter = true,
                        case_mode = "smart_case",
                    },
                    ["ui-select"] = {
                        require("telescope.themes").get_dropdown({}),
                    },
                },
                pickers = {
                    find_files = {
                        find_command = { "fd", "--type", "f", "--strip-cwd-prefix" },
                        theme = "dropdown",
                    },
                },
            })
            telescope.load_extension("fzf")
            telescope.load_extension("ui-select")
        end,
    },
}
