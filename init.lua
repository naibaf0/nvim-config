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

----- Lazy.nvim Bootstrap {{{-----------------------------------------------------------------------------------
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)
--}}}-----------------------------------------------------------------------------------------------------------

----- Pre-Plugin Configuration {{{------------------------------------------------------------------------------
-- Basic editor options MUST load first (sets leader key before lazy.nvim)
require("config.settings").setup()
--}}}-----------------------------------------------------------------------------------------------------------

----- Plugin Setup {{{------------------------------------------------------------------------------------------
require("lazy").setup("plugins", {
    defaults = {
        lazy = false, -- plugins are not lazy-loaded by default
    },
    install = {
        colorscheme = { "catppuccin" },
    },
    checker = {
        enabled = true, -- automatically check for plugin updates
        notify = false, -- don't notify on updates
    },
    change_detection = {
        notify = false, -- don't notify on config changes
    },
    performance = {
        rtp = {
            disabled_plugins = {
                "gzip",
                "tarPlugin",
                "tohtml",
                "tutor",
                "zipPlugin",
            },
        },
    },
})
--}}}-----------------------------------------------------------------------------------------------------------

----- Post-Plugin Configuration {{{-----------------------------------------------------------------------------
-- Keybindings (loaded after plugins so plugin commands are available)
require("config.keymap").setup()

-- User defined commands (loaded after plugins for plugin integration)
require("config.commands").setup()
--}}}-----------------------------------------------------------------------------------------------------------

----- Project Configuration {{{---------------------------------------------------------------------------------
local function load_project_config()
    if vim.fn.filereadable(".project.lua") == 1 then
        vim.cmd([[luafile .project.lua]])
    elseif vim.fn.filereadable(".project.vim") == 1 then
        vim.cmd([[source .project.vim]])
    end
end

local LoadProjectConfig = vim.api.nvim_create_augroup("LoadProjectConfig", {})
vim.api.nvim_create_autocmd("DirChanged", {
    group = LoadProjectConfig,
    pattern = "global",
    callback = load_project_config,
})

load_project_config()
--}}}-----------------------------------------------------------------------------------------------------------
