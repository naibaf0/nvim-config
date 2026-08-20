local wk = require('which-key')
local diag = vim.diagnostic
local buf = vim.lsp.buf
local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd
local command = vim.api.nvim_create_user_command

----- Key bindings {{{----------------------------------------------------------------------------------------------

-- Mappings. See `:help vim.diagnostic.*` for documentation on any of the below functions
local opts = { noremap = true, silent = true }

wk.add({
    { "<leader>d", function() require("trouble").toggle() end, desc = "Show all diagnostics" },
    -- { "<leader>d", function() diag.setloclist() end, desc = "Show all diagnostics" },
})
wk.add({
    { "?", group = "LSP Diagnostics" },
    { "??", function() diag.open_float() end, desc = "Show diagnostic under cursor" },
    { "?j", function() diag.goto_prev() end, desc = "Goto previous diagnostic" },
    { "?k", function() diag.goto_next() end, desc = "Goto next diagnostic" },
})

local config = {
    -- disable virtual text
    virtual_text = false,
    -- show signs using modern API
    signs = {
        text = {
            [diag.severity.ERROR] = " ",
            [diag.severity.WARN] = " ",
            [diag.severity.HINT] = "",
            [diag.severity.INFO] = " ",
        },
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

diag.config(config)

local group = augroup('diagnostic_cmds', {clear = true})

autocmd('ModeChanged', {
    group = group,
    pattern = {'n:i', 'v:s'},
    desc = 'Disable diagnostics while typing',
    callback = function() diag.enable(false) end
})

autocmd('ModeChanged', {
    group = group,
    pattern = 'i:n',
    desc = 'Enable diagnostics when leaving insert mode',
    callback = function() diag.enable(true) end
})

--}}}---------------------------------------------------------------------------------------------------------------

----- LspAttach Autocmd {{{-----------------------------------------------------------------------------------------

autocmd("LspAttach", {
    group = augroup("lsp_attach", { clear = true }),
    desc = "LSP keymaps and buffer settings",
    callback = function(args)
        local bufnr = args.buf
        local client = vim.lsp.get_client_by_id(args.data.client_id)

        if not client then
            return
        end

        if client.server_capabilities.definitionProvider then
            vim.bo[bufnr].tagfunc = "v:lua.vim.lsp.tagfunc"
        end

        if client.server_capabilities.documentFormattingProvider then
            vim.bo[bufnr].formatexpr = "v:lua.vim.lsp.formatexpr()"
        end

        -- Mappings. See `:help vim.lsp.*` for documentation on any of the below functions
        local bufopts = { noremap=true, silent=true, buffer=bufnr, border = 'rounded' }

        -- LSP keymaps using which-key
        wk.add({
            { "<leader>g", group = "LSP Goto", buffer = bufnr },
            { "<leader>gd", function() buf.declaration() end, desc = "Goto declaration", buffer = bufnr },
            { "<leader>gD", function() buf.definition() end, desc = "Goto definition", buffer = bufnr },
            { "<leader>gi", function() buf.implementation() end, desc = "Goto implementation", buffer = bufnr },
            { "<leader>gt", function() buf.type_definition() end, desc = "Goto type definition", buffer = bufnr },
            { "<leader>k", function() buf.hover() end, desc = "Tooltip for item under cursor", buffer = bufnr },
            { "<leader>rn", function() buf.rename() end, desc = "Refactor rename item under cursor", buffer = bufnr },
            { "<leader>ca", function() buf.code_action() end, desc = "Perform code action for item under cursor", buffer = bufnr },
            { "<leader>cf", function() buf.format() end, desc = "Perform formatting (whole file)", buffer = bufnr },
        })

        vim.keymap.set('n', '<C-k>', buf.signature_help, bufopts)
        vim.keymap.set('n', 'K', buf.hover, bufopts)

        -- ltex-extra setup (only for ltex server)
        if client.name == "ltex" then
            require("ltex_extra").setup {
                path = ".ltex"
            }
        end
    end,
})

--}}}---------------------------------------------------------------------------------------------------------------

----- Server configurations {{{-------------------------------------------------------------------------------------

-- Add additional capabilities supported by nvim-cmp
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

local lspconfig = vim.lsp.config

lspconfig('clangd', {
    capabilities = capabilities
})

lspconfig('gopls', {
    cmd = {"gopls", "serve"},
    settings = {
        gopls = {
            -- analysis = {
            --     unusedparams = true,
            -- },
            staticcheck = true,
        },
    },
    capabilities = capabilities
})

lspconfig('ltex', {
    filetypes = { "tex", "bib", "markdown" },
    settings = {
        ltex = {
            enabled = { "latex", "bibtex", "markdown" },
            -- language = "en-US",
            diagnosticSeverity = "information",
            sentenceCacheSize = 2000,
            additionalRules = {
                enablePickyRules = true,
                motherTongue = "de-DE",
            },
            trace = { server = "verbose" },
            disabledRules = {},
        },
    },
    capabilities = capabilities
})

lspconfig('pylsp', {
    settings = {
        pylsp = {
            plugins = {
                pycodestyle = {
                    ignore = {'W391'},
                    maxLineLength = 120
                }
            }
        }
    },
    capabilities = capabilities
})

lspconfig('texlab', {
    filetypes = { "tex", "bib" },
    settings = {
      texlab = {
        -- rootDirectory = ".",
        build = {
          executable = "latexmk",
          args = { "-pdf", "-interaction=nonstopmode", "-synctex=1", "%f" },
          onSave = false,
          -- forwardSearchAfter = true,
        },
        -- forwardSearch = {
        --   executable = "zathura",
        --   args = { "--synctex-forward", "%l:1:%f", "%p" },
        -- },
        chktex = {
            onOpenAndSave = true,
            onEdit = true,
        },
        bibtexFormatter = 'texlab',
        formatterLineLength = 120,
      }
    },
    capabilities = capabilities
})

lspconfig('yamlls', {
    settings = {
        yaml = {
           schemas = { kubernetes = "globPattern" },
        }
    },
    capabilities = capabilities
})

--}}}---------------------------------------------------------------------------------------------------------------

----- Enable LSP Servers {{{----------------------------------------------------------------------------------------

vim.lsp.enable({
    "clangd",
    "gopls",
    "ltex",
    "pylsp",
    "texlab",
    "yamlls",
})

--}}}---------------------------------------------------------------------------------------------------------------
