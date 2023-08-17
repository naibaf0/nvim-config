local M = { }

function M.setup()

    ----- Bootstrap `packer` {{{----------------------------------------------------------------------------------------
    local install_path = vim.fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
    if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
      packer_bootstrap = vim.fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
      vim.cmd [[packadd packer.nvim]]
    end
    --}}}---------------------------------------------------------------------------------------------------------------

    ----- Install/load plugins {{{--------------------------------------------------------------------------------------
    require('packer').startup(function()
        -- Packer can manage itself
        use 'wbthomason/packer.nvim'

        -- Plugins -----------------------------------------------------------------------------------------------------

        -- Catppuccin
        use { "catppuccin/nvim", as = "catppuccin" }
        -- Top and Bottom 
        use { 'nvim-lualine/lualine.nvim', requires = { 'kyazdani42/nvim-web-devicons', opt = true } }
        use { 'kdheepak/tabline.nvim', requires = { 'kyazdani42/nvim-web-devicons', opt = true } }
        -- Git
        use { 'lewis6991/gitsigns.nvim', requires = 'nvim-lua/plenary.nvim' }
        use 'tpope/vim-fugitive'
        -- File Tree
        use {
            'kyazdani42/nvim-tree.lua',
            requires = {
                'kyazdani42/nvim-web-devicons', opt = true -- optional, for file icons
            },
            config = function() require'nvim-tree'.setup() end,
        }
        -- Undotree
        use 'simnalamburt/vim-mundo'
        -- Session Manager
        use { 'Shatur/neovim-session-manager', requires = { 'nvim-lua/plenary.nvim' } }
        -- Keybinding preview/help
        use {
            'folke/which-key.nvim',
            config = function() require('which-key').setup() end
        }
        -- Distraction-free Writing
        use 'junegunn/goyo.vim'
        use 'junegunn/limelight.vim'

        use 'ctrlpvim/ctrlp.vim'

        -- Quick Navigation
        use {
            'ggandor/leap.nvim',
            config = function() require('leap').set_default_keymaps() end
        }

        -- Floating Terminal
        use "numToStr/FTerm.nvim"

        use {'nvim-treesitter/nvim-treesitter', run = { ":TSUpdate" } }
        use 'ludovicchabant/vim-gutentags'
        use 'nvim-lua/plenary.nvim'
        use 'powerman/vim-plugin-viewdoc'
        use {
            'numToStr/Comment.nvim',
            config = function() require('Comment').setup() end
        }
        use 'skywind3000/asyncrun.vim'
        use 'Yggdroot/indentLine'
        use 'nmac427/guess-indent.nvim'
        use {
            "windwp/nvim-autopairs",
            config = function() require("nvim-autopairs").setup {} end
        }
        use 'tpope/vim-repeat'
        use 'tpope/vim-surround'

        -- Languages {{{------------------------------------------------------------------------------------------------
        use 'lervag/vimtex'
        -- use {
        --     'brymer-meneses/grammar-guard.nvim',
        --     config = function() require("grammar-guard").setup() end
        -- }
        use 'pedrohdz/vim-yaml-folds'
        use 'elzr/vim-json'
        use { 'euclio/vim-markdown-composer', run = { 'cargo build --release', ':UpdateRemotePlugins' } }
        use 'godlygeek/tabular'
        use 'plasticboy/vim-markdown'
 
        --}}}-----------------------------------------------------------------------------------------------------------

        -- Completion {{{-----------------------------------------------------------------------------------------------
        use {
            'hrsh7th/nvim-cmp',
            requires = {
                'hrsh7th/cmp-nvim-lsp',
                'onsails/lspkind.nvim',
                'saadparwaiz1/cmp_luasnip',
                'hrsh7th/cmp-omni',
                'hrsh7th/cmp-path',
                'hrsh7th/cmp-buffer',
                'L3MON4D3/LuaSnip',
                'rafamadriz/friendly-snippets'
            }
        }
        --}}}-----------------------------------------------------------------------------------------------------------

        -- Telescope {{{------------------------------------------------------------------------------------------------
        use {
            'nvim-telescope/telescope.nvim', branch = '0.1.x',
            requires = { 'nvim-lua/plenary.nvim' },
        }
        use {
            'nvim-telescope/telescope-fzf-native.nvim',
            requires = { 'nvim-telescope/telescope.nvim' },
            run = 'make'
        }
        use {'nvim-telescope/telescope-ui-select.nvim' }
        --}}}-----------------------------------------------------------------------------------------------------------

        -- LanguageServerProtocol (LSP) plugins {{{---------------------------------------------------------------------
        use {
            'williamboman/mason.nvim',
            'williamboman/mason-lspconfig.nvim',
            'neovim/nvim-lspconfig',
        }
        use {
            'p00f/clangd_extensions.nvim',
            requires = { 'neovim/nvim-lspconfig' }
        }
        use { 'ray-x/lsp_signature.nvim' }
        use {
            'folke/trouble.nvim',
            requires = {
                'kyazdani42/nvim-web-devicons', opt = true -- optional, for file icons
            },
        }
        --}}}-----------------------------------------------------------------------------------------------------------

        -- Automatically set up your configuration after cloning packer.nvim.  Put this at the end after all plugins.
        if packer_bootstrap then
            require('packer').sync()
        end
    end)
    ---}}}--------------------------------------------------------------------------------------------------------------

end

return M
