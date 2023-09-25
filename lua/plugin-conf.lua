local M = { }

function M.setup()

    ----- Catppuccin Colorscheme {{{------------------------------------------------------------------------------------
    require("catppuccin").setup({
        flavour = "macchiato", -- latte, frappe, macchiato, mocha
        transparent_background = false, -- disables setting the background color.
        show_end_of_buffer = false, -- shows the '~' characters after the end of buffers
        term_colors = true, -- sets terminal colors (e.g. `g:terminal_color_0`)
        dim_inactive = {
            enabled = true, -- dims the background color of inactive window
            shade = "dark",
            percentage = 0.15, -- percentage of the shade to apply to the inactive window
        },
        integrations = {
            cmp = true,
            gitsigns = true,
            leap = true,
            lsp_trouble = true,
            mason = true,
            nvimtree = true,
            treesitter = true,
            which_key = true
        },
    })
    vim.cmd.colorscheme "catppuccin"
    --}}}---------------------------------------------------------------------------------------------------------------

    ----- Lualine & Tabline {{{-----------------------------------------------------------------------------------------
    require'tabline'.setup {
      enable = false,
      options = {
        show_bufnr = true, -- this appends [bufnr] to buffer section,
      }
    }

    local function diff_source()
        local gitsigns = vim.b.gitsigns_status_dict
        if gitsigns then
            return {
                added = gitsigns.added,
                modified = gitsigns.changed,
                removed = gitsigns.removed
            }
        end
    end

    require('lualine').setup {
        options = {
            theme = "catppuccin"
        },
        extensions = {
            'fugitive', 'fzf', 'nvim-tree', 'mundo',-- 'quickfix',
        },
        sections = {
            lualine_b = { {'b:gitsigns_head', icon = ''}, {'diff', source = diff_source}, diagnostics },
        },
        tabline = {
            lualine_a = {},
            lualine_b = {},
            lualine_c = { require'tabline'.tabline_buffers },
            lualine_x = { require'tabline'.tabline_tabs },
            lualine_y = {},
            lualine_z = {},
        },
    }
    --}}}---------------------------------------------------------------------------------------------------------------

    ----- gitsigns {{{--------------------------------------------------------------------------------------------------
    require('gitsigns').setup{
        on_attach = function(bufnr)
            local gs = package.loaded.gitsigns

            local function map(mode, l, r, opts)
                opts = opts or {}
                opts.buffer = bufnr
                vim.keymap.set(mode, l, r, opts)
            end

            -- Navigation
            map('n', ']c', function()
                if vim.wo.diff then return ']c' end
                vim.schedule(function() gs.next_hunk() end)
                return '<Ignore>'
            end, {expr=true})

            map('n', '[c', function()
                if vim.wo.diff then return '[c' end
                vim.schedule(function() gs.prev_hunk() end)
                return '<Ignore>'
            end, {expr=true})

            -- Actions
            map({'n', 'v'}, '<leader>hs', ':Gitsigns stage_hunk<CR>')
            map({'n', 'v'}, '<leader>hr', ':Gitsigns reset_hunk<CR>')
            map('n', '<leader>hS', gs.stage_buffer)
            map('n', '<leader>hu', gs.undo_stage_hunk)
            map('n', '<leader>hR', gs.reset_buffer)
            map('n', '<leader>hp', gs.preview_hunk)
            map('n', '<leader>hb', function() gs.blame_line{full=true} end)
            map('n', '<leader>tb', gs.toggle_current_line_blame)
            map('n', '<leader>hd', gs.diffthis)
            map('n', '<leader>hD', function() gs.diffthis('~') end)
            map('n', '<leader>td', gs.toggle_deleted)

            -- Text object
            map({'o', 'x'}, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
        end
    }
    --}}}---------------------------------------------------------------------------------------------------------------

    ----- Neovim Session Manager {{{------------------------------------------------------------------------------------
    local Path = require('plenary.path')
    require('session_manager').setup({
        sessions_dir = Path:new(vim.fn.stdpath('data'), 'sessions'), -- The directory where the session files will be saved.
        path_replacer = '__', -- The character to which the path separator will be replaced for session files.
        colon_replacer = '++', -- The character to which the colon symbol will be replaced for session files.
        autoload_mode = require('session_manager.config').AutoloadMode.CurrentDir, -- Define what to do when Neovim is started without arguments. Possible values: Disabled, CurrentDir, LastSession
        autosave_last_session = true, -- Automatically save last session on exit and on session switch.
        autosave_ignore_not_normal = true, -- Plugin will not save a session when no buffers are opened, or all of them aren't writable or listed.
        autosave_ignore_filetypes = { -- All buffers of these file types will be closed before the session is saved.
        'gitcommit',
        'quickfix'
    },
    autosave_only_in_session = false, -- Always autosaves session. If true, only autosaves after a session is active.
    max_path_length = 80,  -- Shorten the display path if length exceeds this threshold. Use 0 if don't want to shorten the path at all.
    })
    --}}}---------------------------------------------------------------------------------------------------------------

    ----- Goyo {{{------------------------------------------------------------------------------------------------------

    local goyogroup = vim.api.nvim_create_augroup('goyo_cmds', {clear = true})
    local autocmd = vim.api.nvim_create_autocmd
    local bind = vim.keymap.set
    local unbind = vim.keymap.del

    vim.g.goyo_height = '100%'

    local enter = function()
      vim.opt.wrap = true
      vim.opt.linebreak =  true

      require('lualine').hide()

      vim.cmd[[Limelight]]
    end

    local leave = function()
      vim.opt.wrap = false
      vim.opt.linebreak =  false

      require('lualine').hide({unhide=true})

      vim.cmd[[Limelight!]]
    end

    autocmd('User', {pattern = 'GoyoEnter', group = goyogroup, callback = enter})
    autocmd('User', {pattern = 'GoyoLeave', group = goyogroup, callback = leave})
    --}}}---------------------------------------------------------------------------------------------------------------

    ----- CtrlP {{{-----------------------------------------------------------------------------------------------------
    if vim.fn.executable('ag') == 1 then
        vim.g.ctrlp_user_command = 'ag %s -l --nocolor -g ""'
    end
    vim.g.ctrlp_custom_ignore = {
        ['dir']  = '\\v[\\/]\\.(git|hg|svn)$|build',
        ['file'] = '\\v\\.(exe|so|dll|a)$',
    }
    vim.g.ctrlp_cache_dir = os.getenv('HOME') .. '/.cache/ctrlp'
    --}}}---------------------------------------------------------------------------------------------------------------

    ----- FTerm {{{-----------------------------------------------------------------------------------------------------
    require'FTerm'.setup({
        border = 'double',
        dimensions  = {
            height = 0.9,
            width = 0.9,
        },
    })
    --}}}---------------------------------------------------------------------------------------------------------------

    ----- Treesitter {{{------------------------------------------------------------------------------------------------
    require('nvim-treesitter.configs').setup({
        highlight = {
        enable = true,
        },
        incremental_selection = {
            enable = true,
            keymaps = {
                init_selection = 'ga',
                node_incremental = 'ga',
                node_decremental = 'gz',
            },
        },
        textobjects = {
            select = {
                enable = true,
                lookahead = true,
                keymaps = {
                    ['af'] = '@function.outer',
                    ['if'] = '@function.inner',
                    ['ac'] = '@class.outer',
                    ['ic'] = '@class.inner',
                    ['ia'] = '@parameter.inner',
                }
            },
            swap = {
                enable = true,
                swap_previous = {
                    ['{a'] = '@parameter.inner',
                },
                swap_next = {
                    ['}a'] = '@parameter.inner',
                },
            },
            move = {
                enable = true,
                set_jumps = true,
                goto_next_start = {
                    [']f'] = '@function.outer',
                    [']c'] = '@class.outer',
                    [']a'] = '@parameter.inner',
                },
                goto_next_end = {
                    [']F'] = '@function.outer',
                    [']C'] = '@class.outer',
                },
                goto_previous_start = {
                    ['[f'] = '@function.outer',
                    ['[c'] = '@class.outer',
                    ['[a'] = '@parameter.inner',
                },
                goto_previous_end = {
                    ['[F'] = '@function.outer',
                    ['[C'] = '@class.outer',
                },
            },
        },
        ensure_installed = {
            'dockerfile',
            'go',
            'json',
            'lua',
            'python',
            'yaml'
        },
    })
    --}}}---------------------------------------------------------------------------------------------------------------

    ----- Vim Markdown Composer {{{-------------------------------------------------------------------------------------
    vim.g.markdown_composer_autostart = 0
    --}}}---------------------------------------------------------------------------------------------------------------

    -- vim_markdown {{{-------------------------------------------------------------------------------------------------
        vim.g.vim_markdown_folding_disabled = 1
        vim.g.vim_markdown_conceal = 0
        vim.g.vim_markdown_conceal_code_blocks = 0
        vim.g.vim_markdown_folding_style_pythonic = 1
        vim.g.vim_markdown_toc_autofit = 1
        vim.g.vim_markdown_auto_insert_bullets = 1
        vim.g.vim_markdown_new_list_item_indent = 1
    -- }}}--------------------------------------------------------------------------------------------------------------

    ----- IndentLine {{{------------------------------------------------------------------------------------------------
    vim.g.indentLine_enabled = false
    vim.cmd[[
    augroup filetype
        au FileType c,cpp,python,java IndentLinesEnable
    augroup END
    ]]
    --}}}---------------------------------------------------------------------------------------------------------------

    ----- ViewDoc {{{---------------------------------------------------------------------------------------------------
    vim.g.viewdoc_openempty = false

    -- If set to 1, the word which is looked up is also copied into the Vims search register which allows to easily search
    -- in the documentation for occurrences of this word.
    vim.g.viewdoc_copy_to_search_reg = true
    --}}}---------------------------------------------------------------------------------------------------------------

    ----- Gutentags {{{-------------------------------------------------------------------------------------------------
    vim.g.gutentags_cache_dir = os.getenv('HOME') .. '/.cache/nvim/tags'
    vim.g.gutentags_generate_on_new = true
    vim.g.gutentags_generate_on_missing = true
    vim.g.gutentags_generate_on_write = true
    vim.g.gutentags_generate_on_empty_buffer = false
    vim.g.gutentags_ctags_extra_args = {
        '--tag-relative=yes',
        '--fields=+ailmnS',
    }
    vim.g.gutentags_file_list_command = {
        ['markers'] = {
            ['.git'] = 'git ls-files',
            ['.hg']  = 'hg files',
        }
    }
    --}}}---------------------------------------------------------------------------------------------------------------

    ----- Telescope {{{-------------------------------------------------------------------------------------------------
    local telescope = require('telescope')
    telescope.setup {
        defaults = {
            vimgrep_arguments = {
                "rg",
                "--color=never",
                "--no-heading",
                "--with-filename",
                "--line-number",
                "--column",
                "--smart-case",
                "--trim" -- add this value
            }
        },
        extensions = {
            ['fzf'] = {
                fuzzy = true,                    -- false will only do exact matching
                override_generic_sorter = true,  -- override the generic sorter
                override_file_sorter = true,     -- override the file sorter
                case_mode = 'smart_case',        -- or "ignore_case" or "respect_case"
            },
            ['ui-select'] = { require('telescope.themes').get_dropdown { } }
        },
        pickers = {
            find_files = {
                find_command = { "fd", "--type", "f", "--strip-cwd-prefix" },
                theme = "dropdown"
            },
        }
    }
    -- To get fzf loaded and working with telescope, you need to call
    -- load_extension, somewhere after setup function:
    telescope.load_extension('fzf')
    telescope.load_extension('ui-select')
    --}}}---------------------------------------------------------------------------------------------------------------

    ----- VimTeX {{{----------------------------------------------------------------------------------------------------
    vim.g.tex_flavor = 'latex'
    vim.g.vimtex_compiler_enabled = 1
    vim.g.vimtex_compiler_method = 'latexmk'
    vim.g.vimtex_quickfix_mode = 0
    vim.g.vimtex_view_method = 'zathura'
    vim.g.vimtex_view_zathura_options = '-x "nvr --servername ' .. vim.api.nvim_get_vvar('servername') .. ' --remote-silent %{input} -c %{line}"'
    vim.g.tex_conceal='abdmg'
    --[[ vim.g.vimtex_syntax_minted = [
        {
          'lang' : 'c',
        },
        {
          'lang' : 'go',
        },
        {
          'lang' : 'cpp',
          'environments' : ['cppcode', 'cppcode_test'],
        },
        {
          'lang' : 'bash',
          'syntax' : 'sh'
        },
        {
          'lang' : 'yaml',
        },
        {
          'lang' : 'json',
        },
        {
          'lang' : 'python',
          'ignore' : [
            'pythonEscape',
            'pythonBEscape',
            ],
        }
    ] ]]
    --}}}---------------------------------------------------------------------------------------------------------------

    -- Completion {{{---------------------------------------------------------------------------------------------------
    -- luasnip setup
    local luasnip = require 'luasnip'
    require("luasnip.loaders.from_vscode").lazy_load()

    -- nvim-cmp setup
    local cmp = require 'cmp'
    local lspkind = require 'lspkind'
    cmp.setup {
        snippet = {
            expand = function(args)
                  luasnip.lsp_expand(args.body)
            end,
        },
        window = {
            documentation = {
                border = 'rounded',
                max_height = 15,
                max_width = 50,
                zindex = 16,
            }
      },
        formatting = {
            fields = {'menu', 'abbr', 'kind'},
            format = lspkind.cmp_format({
                mode = 'symbol_text',
                maxwidth = 50, -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
                ellipsis_char = '...', -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)

                -- The function below will be called before any actual modifications from lspkind
                -- so that you can provide more controls on popup customization. (See [#30](https://github.com/onsails/lspkind-nvim/pull/30))
                before = function (entry, vim_item)
                ---
                return vim_item
                end
            })
        },
        mapping = cmp.mapping.preset.insert({
            ['<C-d>'] = cmp.mapping.scroll_docs(-4),
            ['<C-f>'] = cmp.mapping.scroll_docs(4),
            ['<C-Space>'] = cmp.mapping.complete(),
            ['<C-e>'] = cmp.mapping.abort(),
            ['<CR>'] = cmp.mapping.confirm {
                behavior = cmp.ConfirmBehavior.Replace,
                select = true,
            },
            ['<Tab>'] = cmp.mapping(function(fallback)
                if cmp.visible() then
                    cmp.select_next_item()
                elseif luasnip.expand_or_jumpable() then
                    luasnip.expand_or_jump()
                else
                    fallback()
                end
            end, { 'i', 's' }),
            ['<S-Tab>'] = cmp.mapping(function(fallback)
                if cmp.visible() then
                    cmp.select_prev_item()
                elseif luasnip.jumpable(-1) then
                    luasnip.jump(-1)
                else
                    fallback()
                end
            end, { 'i', 's' }),
        }),
        sources = {
            { name = 'luasnip', keyword_length = 2 },
            { name = 'nvim_lsp', keyword_length = 3 },
            { name = 'path' },
            { name = 'omni' },
            { name = 'buffer', keyword_length = 3 }
        }
    }
    --}}}---------------------------------------------------------------------------------------------------------------

    -- LSP Installation & Config {{{------------------------------------------------------------------------------------
    require("mason").setup({
        ui = {
            icons = {
                package_installed = "✓",
                package_pending = "➜",
                package_uninstalled = "✗"
            }
        }
    })
    require("mason-lspconfig").setup()
    --}}}---------------------------------------------------------------------------------------------------------------

    ----- lsp_signature {{{---------------------------------------------------------------------------------------------
    require'lsp_signature'.setup{
        bind = true, -- This is mandatory, otherwise border config won't get registered.
        -- If you want to hook lspsaga or other signature handler, pls set to false
        doc_lines = 2, -- will show two lines of comment/doc(if there are more than two lines in doc, will be truncated);
        -- set to 0 if you DO NOT want any API comments be shown
        -- This setting only take effect in insert mode, it does not affect signature help in normal
        -- mode, 10 by default

        floating_window = true, -- show hint in a floating window, set to false for virtual text only mode
        fix_pos = false, -- set to true, the floating window will not auto-close until finish all parameters
        hint_enable = true, -- virtual hint enable
        hint_prefix = "🐼 ", -- Panda for parameter
        hint_scheme = "String",
        use_lspsaga = false, -- set to true if you want to use lspsaga popup
        hi_parameter = "Search", -- how your parameter will be highlight
        max_height = 12, -- max height of signature floating_window, if content is more than max_height, you can scroll down
        -- to view the hiding contents
        max_width = 120, -- max_width of signature floating_window, line will be wrapped if exceed max_width
        transpancy = 10, -- set this value if you want the floating windows to be transpant (100 fully transpant), nil to disable(default)
        handler_opts = {
            border = "rounded", -- double, single, shadow, none
        },

        trigger_on_newline = false, -- set to true if you need multiple line parameter, sometime show signature on new line can be confusing, set it to false for #58
        extra_trigger_chars = {}, -- Array of extra characters that will trigger signature completion, e.g., {"(", ","}
        -- deprecate !!
        -- decorator = {"`", "`"}  -- this is no longer needed as nvim give me a handler and it allow me to highlight active parameter in floating_window
        zindex = 200, -- by default it will be on top of all floating windows, set to 50 send it to bottom
        debug = false, -- set to true to enable debug logging
        log_path = "debug_log_file_path", -- debug log path

        padding = "", -- character to pad on left and right of signature can be ' ', or '|'  etc

        shadow_blend = 36, -- if you using shadow as border use this set the opacity
        shadow_guibg = "Black", -- if you using shadow as border use this set the color e.g. 'Green' or '#121315'
        toggle_key = "<M-o>", -- toggle signature on and off in insert mode,  e.g. toggle_key = '<M-x>'
    }
    --}}}---------------------------------------------------------------------------------------------------------------

end

return M
