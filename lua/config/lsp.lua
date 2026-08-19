local wk = require("which-key")
local diag = vim.diagnostic
local buf = vim.lsp.buf
local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

----- Key bindings {{{----------------------------------------------------------------------------------------------

-- Mappings. See `:help vim.diagnostic.*` for documentation on any of the below functions
wk.add({
    { "<leader>d", function() require("trouble").toggle() end, desc = "Show all diagnostics" },
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

local group = augroup("diagnostic_cmds", { clear = true })

autocmd("ModeChanged", {
    group = group,
    pattern = { "n:i", "v:s" },
    desc = "Disable diagnostics while typing",
    callback = function()
        diag.enable(false)
    end,
})

autocmd("ModeChanged", {
    group = group,
    pattern = "i:n",
    desc = "Enable diagnostics when leaving insert mode",
    callback = function()
        diag.enable(true)
    end,
})

--}}}---------------------------------------------------------------------------------------------------------------

----- on_attach {{{-------------------------------------------------------------------------------------------------

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
    if client.server_capabilities.goto_definition == true then
        vim.bo[bufnr].tagfunc = "v:lua.vim.lsp.tagfunc"
    end

    if client.server_capabilities.document_formatting == true then
        vim.bo[bufnr].formatexpr = "v:lua.vim.lsp.formatexpr()"
    end

    -- Mappings. See `:help vim.lsp.*` for documentation on any of the below functions
    local bufopts = { noremap = true, silent = true, buffer = bufnr }

    -- LSP keymaps using new which-key API
    wk.add({
        { "<leader>g", group = "LSP Goto", buffer = bufnr },
        { "<leader>gd", function() buf.declaration() end, desc = "Goto declaration", buffer = bufnr },
        { "<leader>gD", function() buf.definition() end, desc = "Goto definition", buffer = bufnr },
        { "<leader>gi", function() buf.implementation() end, desc = "Goto implementation", buffer = bufnr },
        { "<leader>gt", function() buf.type_definition() end, desc = "Goto type definition", buffer = bufnr },
        { "<leader>k", function() buf.hover() end, desc = "Tooltip for item under cursor", buffer = bufnr },
        { "<leader>rn", function() buf.rename() end, desc = "Refactor rename", buffer = bufnr },
        { "<leader>ca", function() buf.code_action() end, desc = "Code action", buffer = bufnr },
        { "<leader>cf", function() buf.format() end, desc = "Format file", buffer = bufnr },
    })

    vim.keymap.set("n", "<C-k>", buf.signature_help, bufopts)
    vim.keymap.set("n", "K", buf.hover, bufopts)
end

--}}}---------------------------------------------------------------------------------------------------------------

----- Server configurations {{{-------------------------------------------------------------------------------------

-- Add additional capabilities supported by nvim-cmp
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

local lspconfig = vim.lsp.conf

lspconfig('clangd', {
    on_attach = on_attach,
    capabilities = capabilities,
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
    on_attach = on_attach,
    capabilities = capabilities,
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
    on_attach = function(client, bufnr)
        -- rest of your on_attach process.
        on_attach(client, bufnr)
        require("ltex_extra").setup { 
            path = ".ltex"
        }
    end,
    capabilities = capabilities,
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
    }
    on_attach = on_attach,
    capabilities = capabilities,
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
    on_attach = on_attach,
    capabilities = capabilities,
})

lspconfig('yamlls', {
    settings = {
        yaml = {
           schemas = { kubernetes = "globPattern" },
        }
    }
    on_attach = on_attach,
    capabilities = capabilities,
})

--}}}---------------------------------------------------------------------------------------------------------------
