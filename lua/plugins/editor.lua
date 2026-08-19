-- Editor enhancements: commenting, autopairs, surround, leap, etc.
--
-- LAZY STRATEGY:
-- - leap: YES (keys) - Motion plugin only when using s/S keys
-- - Comment: YES (keys) - Only when using comment keybindings
-- - autopairs: YES (InsertEnter) - Only needed in insert mode
-- - guess-indent: YES (BufReadPre) - Only when opening files
-- - surround: NO - Needs immediate availability for text object motions
-- - repeat: NO - Extends . command, must be ready immediately
-- - ctrlp: YES (cmd) - Legacy finder, only when invoked
-- - gutentags: YES (BufReadPre) - Tags only when opening files
-- - asyncrun: YES (cmd) - Only when running async commands

return {
    ----- Leap {{{--------------------------------------------------------------------------------------------------
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
    --}}}-----------------------------------------------------------------------------------------------------------

    ----- Comment {{{-----------------------------------------------------------------------------------------------
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
    --}}}-----------------------------------------------------------------------------------------------------------

    ----- nvim-autopairs {{{----------------------------------------------------------------------------------------
    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        config = function()
            require("nvim-autopairs").setup({})
        end,
    },
    --}}}-----------------------------------------------------------------------------------------------------------

    ----- guess-indent {{{------------------------------------------------------------------------------------------
    {
        "nmac427/guess-indent.nvim",
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            require("guess-indent").setup({})
        end,
    },
    --}}}-----------------------------------------------------------------------------------------------------------

    ----- vim-surround {{{------------------------------------------------------------------------------------------
    {
        "tpope/vim-surround",
        lazy = false,
    },
    --}}}-----------------------------------------------------------------------------------------------------------

    ----- vim-repeat {{{--------------------------------------------------------------------------------------------
    {
        "tpope/vim-repeat",
        lazy = false,
    },
    --}}}-----------------------------------------------------------------------------------------------------------

    ----- CtrlP {{{-------------------------------------------------------------------------------------------------
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
    --}}}-----------------------------------------------------------------------------------------------------------

    ----- Gutentags {{{---------------------------------------------------------------------------------------------
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
    --}}}-----------------------------------------------------------------------------------------------------------

    ----- AsyncRun {{{----------------------------------------------------------------------------------------------
    {
        "skywind3000/asyncrun.vim",
        cmd = { "AsyncRun", "AsyncStop" },
    },
    --}}}-----------------------------------------------------------------------------------------------------------
}
