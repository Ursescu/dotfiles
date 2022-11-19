vim.cmd([[
    set expandtab
    set ts=4
    set sw=4
    set number
    set showcmd
    set laststatus=2
    set incsearch
    set ignorecase
    set smartcase
    set jumpoptions=stack 
]])

vim.cmd [[packadd packer.nvim]]

require('packer').startup(function()
    -- Packer itself
    use 'wbthomason/packer.nvim'

    use 'tpope/vim-surround'
    use {
        'nvim-telescope/telescope.nvim',
        requires = {
            { 'nvim-lua/plenary.nvim' }
        }
    }
    use {'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }

    use {'junegunn/fzf', run = function()
            vim.fn['fzf#install']()
        end
    }
    
    use {'kevinhwang91/nvim-bqf'}
    
    use 'mhinz/vim-grepper'
    use {'ojroques/vim-oscyank', branch = 'main'}

    use 'nvim-telescope/telescope-file-browser.nvim'
    use {'nvim-treesitter/nvim-treesitter', run = ':TSUpdate'}
    use {'p00f/nvim-ts-rainbow'}
    use {
        'nvim-tree/nvim-tree.lua',
        requires = {
            'nvim-tree/nvim-web-devicons', -- optional, for file icons
        },
        tag = 'nightly' -- optional, updated every week. (see issue #1193)
    }

    use {"sitiom/nvim-numbertoggle"}
    use 'folke/tokyonight.nvim'
    use 'dstein64/vim-startuptime'
end)

-- Number toggle setup
require('numbertoggle').setup()

-- Bqf setup
require('bqf').setup({
    auto_enable = true,
    auto_resize_height = true, -- highly recommended enable
    preview = {
        win_height = 12,
        win_vheight = 12,
        delay_syntax = 80,
        border_chars = {'┃', '┃', '━', '━', '┏', '┓', '┗', '┛', '█'},
        show_title = false,
        should_preview_cb = function(bufnr, qwinid)
            local ret = true
            local bufname = vim.api.nvim_buf_get_name(bufnr)
            local fsize = vim.fn.getfsize(bufname)
            if fsize > 100 * 1024 then
                -- skip file size greater than 100k
                ret = false
            elseif bufname:match('^fugitive://') then
                -- skip fugitive buffer
                ret = false
            end
            return ret
        end
    },
    -- make `drop` and `tab drop` to become preferred
    func_map = {
        drop = 'o',
        openc = 'O',
        split = '<C-s>',
        tabdrop = '<C-t>',
        tabc = '',
        ptogglemode = 'z,',
    },
    filter = {
        fzf = {
            action_for = {['ctrl-s'] = 'split', ['ctrl-t'] = 'tab drop', ['ctrl-v'] = 'vsplit'},
            extra_opts = {'--bind', 'ctrl-o:toggle-all', '--prompt', 'QuickFix> '}
        }
    }
})


-- Nvim tree setup
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- set termguicolors to enable highlight groups
vim.opt.termguicolors = true

-- empty setup using defaults
require("nvim-tree").setup()

-- OR setup with some options
require("nvim-tree").setup({
  sort_by = "case_sensitive",
  view = {
    adaptive_size = true,
    mappings = {
      list = {
        { key = "u", action = "dir_up" },
      },
    },
  },
  renderer = {
    group_empty = true,
  },
  filters = {
    dotfiles = true,
  },
})

-- Nvim Tree sitter config
require('nvim-treesitter.configs').setup {
    ensure_installed = { 'c', 'lua', 'cpp', 'python' },
    sync_install = false,

    auto_install = true,

    higlight = {
        enable = true,
        additional_vim_regex_highlighting = false
    },

    rainbow = {
        enable = true,
        disable = {},
        extended_mode = true,
        max_file_lines = nil
    }
}

-- Telescope setup
require('telescope').setup {
    extensions = {
        file_browser = {
            theme = 'dropdown',
            previewer = false,
            layout_config = {
                center = {
                    height = 0.8,
                    width = 0.4
                }
            }
        }
    }
}
require('telescope').load_extension 'file_browser'
require('telescope').load_extension 'fzf'

-- Grepper
vim.g.grepper = {
    tools = {'rg', 'grep'},
    searchreg = 1,
}

-- Key mappers
function map(mode, lhs, rhs, opts)
    local options = { noremap = true }
    if opts then
        options = vim.tbl_extend("force", options, opts)
    end
    vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

map('n', '<leader>ff', ':Telescope find_files<cr>', {})
map('n', '<leader>fg', ':Telescope live_grep<cr>', {})
map('n', '<leader>fe', ':Telescope file_browser<cr>', {})
map('v', '<leader>c', ':OSCYank<cr>', {})
map('n', '<leader>*', ':Grepper -tool rg -cword -noprompt<cr>', {})
map('n', '<leader>n', ':NvimTreeToggle<cr>', {})

-- Color scheme
vim.cmd [[colorscheme tokyonight-night]]

-- vimrc incsearch highlight
vim.cmd([[
augroup vimrc-incsearch-highlight
  autocmd!
  autocmd CmdlineEnter /,\? :set hlsearch
  autocmd CmdlineLeave /,\? :set nohlsearch
augroup END
]])
