local M = { }

local utils = require('utils')

function M.setup()
    local has_wk, wk = pcall(require, 'which-key')

    ----- Global mappings {{{-------------------------------------------------------------------------------------------
    -- Select a session
    if has_wk then
        wk.add({
            { "<Leader>", group = "Sessions" },
            { "<Leader>l", function() require('session_manager').load_session() end, desc = "Load a session" },
        })
    end

    -- Toggle Vim Spellcheck and the language
    vim.keymap.set('n', '<F2>', function()
        vim.opt.spell = not vim.o.spell
    end)
    vim.keymap.set('n', '<F3>', function()
        if vim.bo.spelllang == "en_GB" then
            vim.bo.spelllang="de_DE"
            print("spelllang DE")
        else
            vim.bo.spelllang="en_GB"
            print("spelllang EN")
        end
    end)

    -- Toggle cursor column
    vim.keymap.set('n', '<F4>', function()
        vim.o.cursorcolumn = not vim.o.cursorcolumn
    end)

    vim.keymap.set('n', '<F5>', ':AsyncRun -program=make<CR>')


    -- Sort visual lines
    vim.keymap.set('v', '<C-s>', ':sort i<CR>', { silent = true })

    -- Revert visual lines
    vim.keymap.set('v', '<C-r>', ':!tac<CR>', { silent = true })


    -- only press < and > once in normal mode indent TODO this seems buggy right now
    vim.keymap.set('n', '<', '<<', { remap = true })
    vim.keymap.set('n', '>', '>>', { remap = true })

    -- convenient mappings for system clipboard
    vim.keymap.set('', '<leader>y', '"+y', { remap = false })
    vim.keymap.set('', '<leader>p', '"+p', { remap = false })

    vim.keymap.set('x', '*', ':lua require("utils").search_for_visual_selection(true)<cr>', { silent = true })
    vim.keymap.set('x', '?', ':lua require("utils").search_for_visual_selection(false)<cr>', { silent = true })
    --}}}---------------------------------------------------------------------------------------------------------------

    ----- Plugin mappings {{{-------------------------------------------------------------------------------------------

    -- Switch Buffers
    vim.keymap.set('n', '<tab>', ':TablineBufferNext<CR>', { silent = true })
    vim.keymap.set('n', '<s-tab>', ':TablineBufferPrevious<CR>', { silent = true })
    -- Switch Tabs
    vim.keymap.set('n', '<c-tab>', ':tabnext<CR>', { silent = true })
    vim.keymap.set('n', '<c-s-tab>', ':tabprevious<CR>', { silent = true })
    vim.keymap.set('n', '<c-n>', ':TablineTabNew', { silent = true })

    -- Toggle FileTree
    vim.keymap.set('n', '<F6>', ':NvimTreeToggle<CR>', { silent = true })
    -- Toggle Undotree
    vim.keymap.set('n', '<F7>', ':MundoToggle<CR>', { silent = true })
    -- Toggle Goyo Mode
    vim.keymap.set('n', '<leader>w', ':Goyo<CR>', { silent = true })

    -- Toggle FTerm
    vim.keymap.set('n', '<A-t>', ':lua require("FTerm").toggle()<CR>')
    vim.keymap.set('t', '<A-t>', '<C-\\><C-n><CMD>lua require("FTerm").toggle()<CR>')

    -- Telescope
    vim.keymap.set('n', '<leader>o',':lua require("utils").project_files()<cr>' , { silent = true })

    if has_wk then
        wk.add({
            { "f", group = "Telescope" },
            { "fb", function() require('telescope.builtin').buffers() end, desc = "Buffers" },
            { "ff", function() require('telescope.builtin').find_files() end, desc = "Find file" },
            { "fg", function() require('telescope.builtin').live_grep() end, desc = "Live Grep" },
            { "fvb", function() require('telescope.builtin').git_branches() end, desc = "Find Git branch" },
            { "fvc", function() require('telescope.builtin').git_commits() end, desc = "Find Git commit" },
            { "fvf", function() require('telescope.builtin').git_files() end, desc = "Find file tracked in Git" },
            { "fvh", function() require('telescope.builtin').git_bcommits() end, desc = "Find buffer's Git commit (history)" },
        })
    end

    -- Trouble
    if has_wk then
        wk.add({
            { "t", group = "Trouble" },
            { "tb", function() require('telescope.builtin').buffers() end, desc = "Buffers" },
            { "tg", function() require('telescope.builtin').live_grep() end, desc = "Live Grep" },
            { "tt", function() require('trouble').toggle() end, desc = "Toggle Trouble" },
        })
    end
    --}}}---------------------------------------------------------------------------------------------------------------

end

return M
