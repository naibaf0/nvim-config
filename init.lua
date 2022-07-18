-- Lua core configuration for neovim.
--


-- ========================================================================== --
-- ==                            DEPENDENCIES                              == --
-- ========================================================================== --

-- ripgrep    - https://github.com/BurntSushi/ripgrep
-- fd         - https://github.com/sharkdp/fd
-- git        - https://git-scm.com/
-- make       - https://www.gnu.org/software/make/
-- c compiler - gcc or tcc or zig

-- Try to load "env" file
--local ok, env = pcall(require, 'env')

--if not ok then
--  vim.notify(
--    'lua/env.lua not found. You should probably rename env.sample',
--    vim.log.levels.ERROR
--  )
--  return
--end

-- Basic editor options
require('settings').setup()

-- Keybindings
require('keymap').setup()

-- Plugin management and config
require('plugins').setup()
require('plugin-conf').setup()
require('lsp').setup()

-- User defined commands
require('commands').setup()

function load_project_config()
    if vim.fn.filereadable('.project.lua') == 1 then
        vim.cmd[[luafile .project.lua]]
    elseif vim.fn.filereadable('.project.vim') == 1 then
        vim.cmd[[source .project.vim]]
    end
end

local LoadProjectConfig = vim.api.nvim_create_augroup('LoadProjectConfig', {})
vim.api.nvim_create_autocmd('DirChanged', {
    group = LoadProjectConfig,
    pattern = 'global',
    callback = load_project_config,
})

load_project_config()

