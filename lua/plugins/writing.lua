-- Writing and documentation plugins: goyo, limelight, vimtex, markdown
--
-- LAZY STRATEGY:
-- - goyo/limelight: YES (cmd/keys) - Zen mode only when explicitly invoked
-- - vimtex: YES (ft) - LaTeX-specific, only for .tex/.bib files
-- - vim-markdown: YES (ft) - Markdown-specific
-- - tabular: YES (cmd) - Text alignment only when invoked
-- - markdown-composer: YES (ft) - Markdown preview only for .md files
-- - vim-json: YES (ft) - JSON-specific
-- - vim-yaml-folds: YES (ft) - YAML-specific
-- - viewdoc: YES (cmd) - Documentation viewer only when invoked

return {
    ----- Goyo {{{--------------------------------------------------------------------------------------------------
    {
        "junegunn/goyo.vim",
        cmd = "Goyo",
        keys = {
            { "<leader>w", "<cmd>Goyo<cr>", desc = "Toggle Goyo" },
        },
        dependencies = { "junegunn/limelight.vim" },
        init = function()
            vim.g.goyo_height = "100%"
        end,
        config = function()
            local goyogroup = vim.api.nvim_create_augroup("goyo_cmds", { clear = true })
            local autocmd = vim.api.nvim_create_autocmd

            local enter = function()
                vim.opt.wrap = true
                vim.opt.linebreak = true
                require("lualine").hide()
                vim.cmd([[Limelight]])
            end

            local leave = function()
                vim.opt.wrap = false
                vim.opt.linebreak = false
                require("lualine").hide({ unhide = true })
                vim.cmd([[Limelight!]])
            end

            autocmd("User", { pattern = "GoyoEnter", group = goyogroup, callback = enter })
            autocmd("User", { pattern = "GoyoLeave", group = goyogroup, callback = leave })
        end,
    },
    --}}}-----------------------------------------------------------------------------------------------------------

    ----- Limelight {{{---------------------------------------------------------------------------------------------
    {
        "junegunn/limelight.vim",
        cmd = "Limelight",
    },
    --}}}-----------------------------------------------------------------------------------------------------------

    ----- VimTeX {{{------------------------------------------------------------------------------------------------
    {
        "lervag/vimtex",
        ft = { "tex", "bib" },
        init = function()
            vim.g.tex_flavor = "latex"
            vim.g.vimtex_compiler_enabled = 1
            vim.g.vimtex_compiler_method = "latexmk"
            vim.g.vimtex_quickfix_mode = 0
            vim.g.vimtex_view_method = "zathura"
            vim.g.vimtex_view_zathura_options = '-x "nvr --servername '
                .. vim.api.nvim_get_vvar("servername")
                .. ' --remote-silent %{input} -c %{line}"'
            vim.g.tex_conceal = "abdmg"
        end,
    },
    --}}}-----------------------------------------------------------------------------------------------------------

    ----- vim-markdown {{{------------------------------------------------------------------------------------------
    {
        "plasticboy/vim-markdown",
        ft = { "markdown" },
        dependencies = { "godlygeek/tabular" },
        init = function()
            vim.g.vim_markdown_folding_disabled = 1
            vim.g.vim_markdown_conceal = 0
            vim.g.vim_markdown_conceal_code_blocks = 0
            vim.g.vim_markdown_folding_style_pythonic = 1
            vim.g.vim_markdown_toc_autofit = 1
            vim.g.vim_markdown_auto_insert_bullets = 1
            vim.g.vim_markdown_new_list_item_indent = 1
        end,
    },
    --}}}-----------------------------------------------------------------------------------------------------------

    ----- Tabular {{{-----------------------------------------------------------------------------------------------
    {
        "godlygeek/tabular",
        cmd = "Tabularize",
    },
    --}}}-----------------------------------------------------------------------------------------------------------

    ----- vim-markdown-composer {{{---------------------------------------------------------------------------------
    {
        "euclio/vim-markdown-composer",
        ft = { "markdown" },
        build = "cargo build --release",
        init = function()
            vim.g.markdown_composer_autostart = 0
        end,
    },
    --}}}-----------------------------------------------------------------------------------------------------------

    ----- vim-json {{{----------------------------------------------------------------------------------------------
    {
        "elzr/vim-json",
        ft = { "json" },
    },
    --}}}-----------------------------------------------------------------------------------------------------------

    ----- vim-yaml-folds {{{----------------------------------------------------------------------------------------
    {
        "pedrohdz/vim-yaml-folds",
        ft = { "yaml" },
    },
    --}}}-----------------------------------------------------------------------------------------------------------

    ----- ViewDoc {{{-----------------------------------------------------------------------------------------------
    {
        "powerman/vim-plugin-viewdoc",
        cmd = { "ViewDoc", "ViewDocHelp" },
        init = function()
            vim.g.viewdoc_openempty = false
            vim.g.viewdoc_copy_to_search_reg = true
        end,
    },
    --}}}-----------------------------------------------------------------------------------------------------------
}
