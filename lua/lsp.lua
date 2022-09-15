local M = { }

function M.setup()
    local wk = require('which-key')
    local diag = vim.diagnostic
    local buf = vim.lsp.buf
    local augroup = vim.api.nvim_create_augroup
    local autocmd = vim.api.nvim_create_autocmd
    local command = vim.api.nvim_create_user_command

    ----- Key bindings {{{----------------------------------------------------------------------------------------------

    -- Mappings. See `:help vim.diagnostic.*` for documentation on any of the below functions
    local opts = { noremap = true, silent = true }

    wk.register({
        name = 'LSP',
        ['??'] = { function() diag.open_float() end, 'Show diagnostic under cursor' },
        ['?j'] = { function() diag.goto_prev() end, 'Goto previous diagnostic' },
        ['?k'] = { function() diag.goto_next() end, 'Goto next diagnostic' },
        ['<leader>d'] = { function() diag.setloclist() end, 'Show all diagnostics' }
    })

    local signs = {
        { name = "DiagnosticSignError", text = "" },
        { name = "DiagnosticSignWarn", text = "" },
        { name = "DiagnosticSignHint", text = "" },
        { name = "DiagnosticSignInfo", text = "" },
    }

    for _, sign in ipairs(signs) do
        vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
    end

    local config = {
        -- disable virtual text
        virtual_text = false,
        -- show signs
        signs = {
            active = signs,
        },
        update_in_insert = true,
        underline = true,
        severity_sort = true,
        float = {
            focusable = false,
            style = "minimal",
            border = "rounded",
            source = "always",
            header = "",
            prefix = "",
        },
    }

    vim.diagnostic.config(config)

    local group = augroup('diagnostic_cmds', {clear = true})

    autocmd('ModeChanged', {
        group = group,
        pattern = {'n:i', 'v:s'},
        desc = 'Disable diagnostics while typing',
        callback = function() vim.diagnostic.disable(0) end
    })

    autocmd('ModeChanged', {
        group = group,
        pattern = 'i:n',
        desc = 'Enable diagnostics when leaving insert mode',
        callback = function() vim.diagnostic.enable(0) end
    })

    vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
        border = "rounded",
    })

    vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
        border = "rounded",
    })

    -- Use an on_attach function to only map the following keys
    -- after the language server attaches to the current buffer
    local on_attach = function(client, bufnr)

        if client.server_capabilities.goto_definition == true then
            vim.api.nvim_buf_set_option(bufnr, "tagfunc", 'v:lua.vim.lsp.tagfunc')
        end

        if client.server_capabilities.document_formatting == true then
            vim.api.nvim_buf_set_option(bufnr, 'formatexpr', 'v:lua.vim.lsp.formatexpr()')
        end

        -- Mappings. See `:help vim.lsp.*` for documentation on any of the below functions
        local bufopts = { noremap=true, silent=true, buffer=bufnr }

        wk.register({
            name = 'LSP',
            g = {
                d = { function() buf.declaration() end, 'Goto declaration' },
                D = { function() buf.definition() end, 'Goto definition' },
                i = { function() buf.implementation() end, 'Goto implementation' },
                t = { function() buf.type_definition() end, 'Goto type definition' },
            },
            k = { function() buf.hover() end, 'Tooltip for item under cursor' },
            ['rn'] = { function() buf.rename() end, 'Refactor rename item under cursor' },
            ['ca'] = { function() buf.code_action() end, 'Perform code action for item under cursor' },
            ['cf'] = { function() buf.formatting() end, 'Perform formatting (whole file)' },
        }, { prefix = '<leader>', buffer = bufnr })

        -- vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
    end
    --}}}---------------------------------------------------------------------------------------------------------------

    ----- Server configurations {{{-------------------------------------------------------------------------------------
    --
    -- Add additional capabilities supported by nvim-cmp
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)

    local lspconfig = require('lspconfig')

    lspconfig['clangd'].setup{
        on_attach = on_attach,
        capabilities = capabilities
    }

    lspconfig['gopls'].setup{
        on_attach = on_attach,
        capabilities = capabilities
    }

    lspconfig['ltex'].setup{
        filetypes = { "tex", "bib" },
        settings = {
            ltex = {
                enabled = { "latex", "bibtex", "markdown" },
                -- language = "en",
                diagnosticSeverity = "information",
                sentenceCacheSize = 2000,
                additionalRules = {
                    enablePickyRules = true,
                    motherTongue = "de-DE",
                },
                trace = { server = "verbose" },
                dictionary = {},
                disabledRules = {},
                hiddenFalsePositives = {},
            },
        },
        on_attach = on_attach,
        capabilities = capabilities
    }

    -- lspconfig['grammar_guard'].setup{
    --     filetypes = { "tex", "bib" },
    --     settings = {
    --         ltex = {
    --             enabled = { "latex", "tex", "bib", "markdown" },
    --             language = "en",
    --             diagnosticSeverity = "information",
    --             sentenceCacheSize = 2000,
    --             additionalRules = {
    --                 enablePickyRules = true,
    --                 motherTongue = "de-DE",
    --             },
    --             trace = { server = "verbose" },
    --             dictionary = {},
    --             disabledRules = {},
    --             hiddenFalsePositives = {},
    --         },
    --     },
    --     on_attach = on_attach,
    --     capabilities = capabilities
    -- }

    lspconfig['pylsp'].setup{
        settings = {
            pylsp = {
                plugins = {
                    pycodestyle = {
                        ignore = {'W391'},
                        maxLineLength = 120
                    }
                }
            }
        }
    }

    lspconfig['texlab'].setup{
        filetypes = { "tex", "bib" },
        settings = {
          texlab = {
            build = {
              executable = "latexmk",
              args = { "-pdf", "-interaction=nonstopmode", "-synctex=1", "%f" },
              onSave = true,
              onChange = false
            },
            chktex = {
                onOpenAndSave = true,
                onEdit = true,
            },
            bibtexFormatter = 'texlab',
            formatterLineLength = 120,
          }
        },
        on_attach = on_attach,
        capabilities = capabilities
    }
    --}}}---------------------------------------------------------------------------------------------------------------

end

return M
