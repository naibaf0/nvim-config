local M = { }

-- local env = require('user.env')
local utils = require('utils')


function M.setup()

    local command = vim.api.nvim_create_user_command
    local autocmd = vim.api.nvim_create_autocmd
    local augroup = vim.api.nvim_create_augroup('init_cmds', {clear = true})

    command('DeleteTrailingWS', utils.delete_trailing_ws, {desc = 'Delete extra whitespace'})
    command('EditMacro', utils.edit_macro, {desc = 'Create/Edit macro in an input'})
    command('AutoIndent', utils.set_autoindent, {desc = 'Guess indentation in all files'})
    command('DiagnosticsToggle', utils.toggle_diagnostics, {desc = 'Toggle Diagnostics on and off'})

    autocmd('TextYankPost', {
      desc = 'highlight text after is copied',
      group = augroup,
      callback = function()
        vim.highlight.on_yank({higroup = 'IncSearch', timeout = 300})
      end
    })

    autocmd('CmdWinEnter', {group = augroup, command = 'quit'})

    ----- Save session & quit {{{---------------------------------------------------------------------------------------
    command('Q', function()
        require('session_manager').save_current_session()
        vim.cmd[[wqa]]
    end, {
        desc = 'save current session, write all files, quit'
    })
    --}}}---------------------------------------------------------------------------------------------------------------

end

return M
