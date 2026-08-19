-- Utility plugins: which-key, fterm, undotree, nvim-tree, session-manager
--
-- LAZY STRATEGY:
-- - plenary: YES (lazy=true) - Utility library, loaded as dependency
-- - which-key: YES (VeryLazy) - Keybinding help can defer slightly after startup
-- - FTerm: YES (keys) - Floating terminal only when toggled
-- - undotree: YES (keys) - Undo visualizer only when invoked
-- - nvim-tree: YES (cmd/keys) - File explorer only when toggled
-- - session-manager: YES (cmd/keys) - Session commands only when invoked

return {
    ----- Plenary {{{-----------------------------------------------------------------------------------------------
    {
        "nvim-lua/plenary.nvim",
    },
    --}}}-----------------------------------------------------------------------------------------------------------

    ----- which-key {{{---------------------------------------------------------------------------------------------
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        config = function()
            require("which-key").setup()
        end,
    },
    --}}}-----------------------------------------------------------------------------------------------------------

    ----- FTerm {{{-------------------------------------------------------------------------------------------------
    {
        "numToStr/FTerm.nvim",
        keys = {
            { "<A-t>", '<cmd>lua require("FTerm").toggle()<cr>', mode = "n", desc = "Toggle terminal" },
            { "<A-t>", '<C-\\><C-n><cmd>lua require("FTerm").toggle()<cr>', mode = "t", desc = "Toggle terminal" },
        },
        config = function()
            require("FTerm").setup({
                border = "double",
                dimensions = {
                    height = 0.9,
                    width = 0.9,
                },
            })
        end,
    },
    --}}}-----------------------------------------------------------------------------------------------------------

    ----- Undotree {{{----------------------------------------------------------------------------------------------
    {
        "jiaoshijie/undotree",
        dependencies = { "nvim-lua/plenary.nvim" },
        keys = {
            { "<F7>", '<cmd>lua require("undotree").toggle()<cr>', desc = "Toggle undotree" },
        },
        config = true,
    },
    --}}}-----------------------------------------------------------------------------------------------------------

    ----- nvim-tree {{{---------------------------------------------------------------------------------------------
    {
        "nvim-tree/nvim-tree.lua",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        keys = {
            { "<F6>", "<cmd>NvimTreeToggle<cr>", desc = "Toggle file tree" },
        },
        cmd = { "NvimTree", "NvimTreeToggle", "NvimTreeOpen", "NvimTreeClose" },
        config = function()
            require("nvim-tree").setup()
        end,
    },
    --}}}-----------------------------------------------------------------------------------------------------------

    ----- Session Manager {{{---------------------------------------------------------------------------------------
    {
        "Shatur/neovim-session-manager",
        dependencies = { "nvim-lua/plenary.nvim" },
        cmd = { "SessionManager" },
        keys = {
            { "<leader>l", "<cmd>SessionManager load_session<cr>", desc = "Load session" },
        },
        config = function()
            local Path = require("plenary.path")
            require("session_manager").setup({
                sessions_dir = Path:new(vim.fn.stdpath("data"), "sessions"),
                path_replacer = "__",
                colon_replacer = "++",
                autoload_mode = require("session_manager.config").AutoloadMode.CurrentDir,
                autosave_last_session = true,
                autosave_ignore_not_normal = true,
                autosave_ignore_filetypes = {
                    "gitcommit",
                    "quickfix",
                },
                autosave_only_in_session = false,
                max_path_length = 80,
            })
        end,
    },
    --}}}-----------------------------------------------------------------------------------------------------------
}
