local M = {}

function M.setup()
    -- Indicate first time installation
    local packer_bootstrap = false

    -- packer.nvim configuration
    local conf = {
        profile = {
            enable = true,
            threshold = 0, -- the amount in ms that a plugins load time must be over for it to be included in the profile
        },
        display = {
            open_fn = function()
                return require('packer.util').float { border = 'rounded' }
            end,
        },
    }

    -- Check if packer.nvim is installed
    -- Run PackerCompile if there are changes in this file
    local function packer_init()
        local fn = vim.fn
        local install_path = fn.stdpath 'data' .. '/site/pack/packer/start/packer.nvim'
        if fn.empty(fn.glob(install_path)) > 0 then
            packer_bootstrap = fn.system {
                'git',
                'clone',
                '--depth',
                '1',
                'https://github.com/wbthomason/packer.nvim',
                install_path,
            }
            vim.cmd [[packadd packer.nvim]]
        end

        -- Run PackerCompile if there are changes in this file
        -- vim.cmd 'autocmd BufWritePost plugins.lua source <afile> | PackerCompile'
        local packer_grp = vim.api.nvim_create_augroup('packer_user_config', { clear = true })
        --        vim.api.nvim_create_autocmd(
        --            { 'BufWritePost' },
        --            { pattern = 'init.lua', command = 'source <afile> | PackerCompile', group = packer_grp }
        --        )
    end

    -- Plugins
    local function plugins(use)
        -- Packer itself
        use 'wbthomason/packer.nvim'
        use { "kkharji/sqlite.lua" }
        use 'tpope/vim-surround'
        use 'nvim-telescope/telescope-file-browser.nvim'
        use 'nvim-telescope/telescope-smart-history.nvim'
        use 'nvim-telescope/telescope-live-grep-args.nvim'
        use { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }
        use {
            'nvim-telescope/telescope.nvim',
            requires = {
                { 'nvim-lua/plenary.nvim' }
            },
            config = function()
                require('config.telescope').setup()
            end
        }
        -- NOT USED
        -- use { 'junegunn/fzf', run = function()
        --     vim.fn['fzf#install']()
        -- end
        -- }

        use {
            'kevinhwang91/nvim-bqf',
            config = function()
                require('config.bqf').setup()
            end
        }

        use {
            'mhinz/vim-grepper',
            config = function()
                require('config.grepper').setup()
            end
        }
        use { 'ojroques/vim-oscyank', branch = 'main' }
        --
        use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate',
            config = function()
                require('config.nvim-treesitter').setup()
            end
        }
        -- NOT UPDATING AS TYPE
        -- use { 'p00f/nvim-ts-rainbow' }
        use {
            'nvim-tree/nvim-tree.lua',
            requires = {
                'nvim-tree/nvim-web-devicons', -- optional, for file icons
            },
            tag = 'nightly',                   -- optional, updated every week. (see issue #1193)
            config = function()
                require('config.nvim-tree').setup()
            end
        }
        -- CAUSES SOME WEIRD ARTIFACTS
        -- use {
        --     'sitiom/nvim-numbertoggle',
        -- }

        use 'simeji/winresizer'
        -- NOT USED
        -- use {
        --     'jedrzejboczar/possession.nvim',
        --     requires = { 'nvim-lua/plenary.nvim' },
        --     config = function()
        --         require('config.possession').setup()
        --     end
        -- }

        --NVIM LSP CONFIGS
        use 'neovim/nvim-lspconfig'
        use 'williamboman/mason.nvim'
        use 'williamboman/mason-lspconfig.nvim'

        use 'hrsh7th/cmp-nvim-lsp'
        use 'hrsh7th/cmp-buffer'
        use 'hrsh7th/cmp-path'
        use 'hrsh7th/cmp-cmdline'
        use 'hrsh7th/nvim-cmp'
        use 'hrsh7th/cmp-nvim-lsp-signature-help'

        use 'L3MON4D3/LuaSnip'
        use 'saadparwaiz1/cmp_luasnip'

        use 'MattesGroeger/vim-bookmarks'
        use 'tom-anders/telescope-vim-bookmarks.nvim'

        use 'yssl/QFEnter'
        use {
           'numToStr/Comment.nvim',
            config = function()
                require('Comment').setup()
            end
        }

        use {
            'kevinhwang91/nvim-ufo',
            requires = 'kevinhwang91/promise-async',
            config = function()
                require('config.ufo').setup()
            end
        }

        use {
            'akinsho/toggleterm.nvim',
            tag = '*',
            config = function()
                require('config.toggleterm').setup()
            end
        }

        use {
            "ray-x/lsp_signature.nvim",
        }
        -- TEMP: Don't use buffer line
        -- use {
        --     'akinsho/bufferline.nvim',
        --     tag = 'main',
        --     requires = { 'nvim-tree/nvim-web-devicons' },
        --     config = function()
        --         require('config.bufferline').setup()
        --     end
        -- }

        use {
            'lukas-reineke/indent-blankline.nvim',
            -- branch = 'v3', -- not yet, need to change config
            config = function()
                require('config.indent').setup()
            end
        }

        use {
            'folke/tokyonight.nvim',
            config = function()
                require('config.tokyonight').setup()
            end
        }
        use {
            'https://gitlab.com/yorickpeterse/nvim-window.git',
            as = 'nvim-window.nvim',
            config = function()
                require('config.nvim-window').setup()
            end
        }

        use {
            "rcarriga/nvim-dap-ui",
            requires = { "mfussenegger/nvim-dap" },
            config = function()
                require('config.nvim-dap').setup()
                require('config.nvim-dap-ui').setup()
            end
        }
        use {
            'rmagatti/auto-session',
            config = function()
                require('config.auto-session').setup()
            end
        }
        use {
            'simrat39/symbols-outline.nvim',
            config = function()
                require('config.symbols-outline').setup()
            end
        }

        use {
            'folke/neodev.nvim'
        }

        -- Zoom window in tab
        use {
            'troydm/zoomwintab.vim'
        }

        use {
            "SmiteshP/nvim-navic",
            requires = "neovim/nvim-lspconfig"
        }

        use {
            'Ursescu/feline.nvim',
            config = function()
                require('config.feline').setup()
            end
        }
        use {
            'phaazon/hop.nvim',
            branch = 'v2',
            config = function()
                require('config.hop').setup()
            end
        }

        -- DON'T USE
        -- use {
        --     'ggandor/leap.nvim',
        --     config = function()
        --         require('leap').add_default_mappings(true)
        --         require('leap').highlight_unlabeled_phase_one_targets = true
        --     end
        -- }
        -- Bootstrap Neovim
        if packer_bootstrap then
            print 'Neovim restart is required after installation!'
            require('packer').sync()
        end
    end

    -- Init and start packer
    packer_init()
    local packer = require 'packer'

    -- Performance
    -- pcall(require, 'impatient')
    -- pcall(require, 'packer_compiled')

    packer.init(conf)
    packer.startup(plugins)
end

return M
