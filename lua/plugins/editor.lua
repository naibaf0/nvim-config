-- Editor enhancements: commenting, autopairs, surround, leap, etc.
return {
    -- Quick navigation
    {
        "ggandor/leap.nvim",
        url = "https://codeberg.org/andyg/leap.nvim",
        keys = {
            { "s", mode = { "n", "x", "o" }, desc = "Leap forward" },
            { "S", mode = { "n", "x", "o" }, desc = "Leap backward" },
        },
        config = function()
            require("leap").set_default_keymaps()
        end,
    },

    -- Commenting
    {
        "numToStr/Comment.nvim",
        keys = {
            { "gcc", mode = "n", desc = "Comment line" },
            { "gc", mode = { "n", "v" }, desc = "Comment" },
        },
        config = function()
            require("Comment").setup()
        end,
    },

    -- Auto pairs
    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        config = function()
            require("nvim-autopairs").setup({})
        end,
    },

    -- Guess indentation
    {
        "nmac427/guess-indent.nvim",
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            require("guess-indent").setup({})
        end,
    },

    -- Surround
    {
        "tpope/vim-surround",
        event = { "BufReadPre", "BufNewFile" },
    },

    -- Repeat plugin commands with .
    {
        "tpope/vim-repeat",
        event = { "BufReadPre", "BufNewFile" },
    },

    -- CtrlP (legacy fuzzy finder, keeping for compatibility)
    {
        "ctrlpvim/ctrlp.vim",
        cmd = { "CtrlP", "CtrlPBuffer", "CtrlPMRU" },
        init = function()
            if vim.fn.executable("ag") == 1 then
                vim.g.ctrlp_user_command = 'ag %s -l --nocolor -g ""'
            end
            vim.g.ctrlp_custom_ignore = {
                dir = "\\v[\\/]\\.(git|hg|svn)$|build",
                file = "\\v\\.(exe|so|dll|a)$",
            }
            vim.g.ctrlp_cache_dir = os.getenv("HOME") .. "/.cache/ctrlp"
        end,
    },

    -- Gutentags (automatic ctags)
    {
        "ludovicchabant/vim-gutentags",
        event = { "BufReadPre", "BufNewFile" },
        init = function()
            vim.g.gutentags_cache_dir = os.getenv("HOME") .. "/.cache/nvim/tags"
            vim.g.gutentags_generate_on_new = true
            vim.g.gutentags_generate_on_missing = true
            vim.g.gutentags_generate_on_write = true
            vim.g.gutentags_generate_on_empty_buffer = false
            vim.g.gutentags_ctags_extra_args = {
                "--tag-relative=yes",
                "--fields=+ailmnS",
            }
            vim.g.gutentags_file_list_command = {
                markers = {
                    [".git"] = "git ls-files",
                    [".hg"] = "hg files",
                },
            }
        end,
    },

    -- Async commands
    {
        "skywind3000/asyncrun.vim",
        cmd = { "AsyncRun", "AsyncStop" },
    },
}
