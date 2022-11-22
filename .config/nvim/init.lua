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
    set nowrap
    set listchars=tab:→\ ,extends:>,precedes:<,space:·
    set list
    set scrolloff=10
    set sidescrolloff=30
    set sessionoptions-=buffers
]])

vim.cmd [[packadd packer.nvim]]

require('packer').startup(function(use)
    -- Packer itself
    use 'wbthomason/packer.nvim'

    use 'tpope/vim-surround'
    use {
        'nvim-telescope/telescope.nvim',
        requires = {
            { 'nvim-lua/plenary.nvim' }
        }
    }
    use { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }

    use { 'junegunn/fzf', run = function()
        vim.fn['fzf#install']()
    end
    }

    use { 'kevinhwang91/nvim-bqf' }

    use 'mhinz/vim-grepper'
    use { 'ojroques/vim-oscyank', branch = 'main' }

    use 'nvim-telescope/telescope-file-browser.nvim'
    use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
    use { 'p00f/nvim-ts-rainbow' }
    use {
        'nvim-tree/nvim-tree.lua',
        requires = {
            'nvim-tree/nvim-web-devicons', -- optional, for file icons
        },
        tag = 'nightly' -- optional, updated every week. (see issue #1193)
    }

    use { "sitiom/nvim-numbertoggle" }
    use 'folke/tokyonight.nvim'
    use 'simeji/winresizer'
    use {
        'jedrzejboczar/possession.nvim',
        requires = { 'nvim-lua/plenary.nvim' }
    }
    -- use 'dstein64/vim-startuptime'

    -- NVIM LSP CONFIGS
    use 'neovim/nvim-lspconfig'

    use 'hrsh7th/cmp-nvim-lsp'
    use 'hrsh7th/cmp-buffer'
    use 'hrsh7th/cmp-path'
    use 'hrsh7th/cmp-cmdline'
    use 'hrsh7th/nvim-cmp'

    use 'L3MON4D3/LuaSnip'
    use 'saadparwaiz1/cmp_luasnip'

    use 'MattesGroeger/vim-bookmarks'
    use 'tom-anders/telescope-vim-bookmarks.nvim'

    use 'yssl/QFEnter'
end)


-- CMP NVIM Setup
vim.opt.completeopt = { 'menu', 'menuone', 'noselect' }

require('luasnip.loaders.from_vscode').lazy_load()

local cmp = require('cmp')
local luasnip = require('luasnip')

local select_opts = { behavior = cmp.SelectBehavior.Select }

local has_words_before = function()
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

cmp.setup({
    completion = {
        completeopt = 'menu,menuone,noinsert'
    },
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end
    },
    sources = {
        { name = 'path' },
        { name = 'nvim_lsp', keyword_length = 3 },
        { name = 'buffer', keyword_length = 3 },
        { name = 'luasnip', keyword_length = 2 },
    },
    window = {
        documentation = cmp.config.window.bordered(),
        completion = cmp.config.window.bordered()
    },
    formatting = {
        fields = { 'menu', 'abbr', 'kind' },
        format = function(entry, item)
            local menu_icon = {
                nvim_lsp = 'λ',
                luasnip = '⋗',
                buffer = 'Ω',
            }

            item.menu = menu_icon[entry.source.name]
            return item
        end,
    },
    mapping = {
        ['<Up>'] = cmp.mapping.select_prev_item(select_opts),
        ['<Down>'] = cmp.mapping.select_next_item(select_opts),

        ['<C-p>'] = cmp.mapping.select_prev_item(select_opts),
        ['<C-n>'] = cmp.mapping.select_next_item(select_opts),

        ['<C-u>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),

        ['<C-e>'] = cmp.mapping.abort(),
        ['<CR>'] = cmp.mapping.confirm({ select = true }),

        ['<C-d>'] = cmp.mapping(function(fallback)
            if luasnip.jumpable(1) then
                luasnip.jump(1)
            else
                fallback()
            end
        end, { 'i', 's' }),
        ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
            elseif has_words_before() then
                cmp.complete()
            else
                fallback()
            end
        end, { "i", "s" }),

        ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end, { "i", "s" }),
    },
})

-- LSP Conifg
local lspconfig = require('lspconfig')

local opts = { noremap = true, silent = true }
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
    -- Enable completion triggered by <c-x><c-o>
    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

    -- Mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local bufopts = { noremap = true, silent = true, buffer = bufnr }
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
    vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
    vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
    vim.keymap.set('n', '<space>wl', function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, bufopts)
    vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
    vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
    vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
    vim.keymap.set('n', '<space>f', function() vim.lsp.buf.format { async = false } end, bufopts)
end

local lsp_flags = {
    -- This is the default in Nvim 0.7+
    debounce_text_changes = 150,
}

local capabilities = require('cmp_nvim_lsp').default_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

-- LUA LSP setup
lspconfig.sumneko_lua.setup({
    capabilities = capabilities,
    settings = {
        Lua = {
            runtime = {
                -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
                version = 'LuaJIT',
            },
            diagnostics = {
                -- Get the language server to recognize the `vim` global
                globals = { 'vim' },
            },
            workspace = {
                -- Make the server aware of Neovim runtime files
                library = vim.api.nvim_get_runtime_file("", true),
                checkThirdParty = false
            },
            -- Do not send telemetry data containing a randomized but unique identifier
            telemetry = {
                enable = false,
            },
        },
    },
    on_attach = on_attach,
    flags = lsp_flags,
})

-- CCLS LSP Setup
lspconfig.ccls.setup({
    on_attach = on_attach,
    flags = lsp_flags,
    capabilities = capabilities,
})

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
        border_chars = { '┃', '┃', '━', '━', '┏', '┓', '┗', '┛', '█' },
        show_title = false,
        should_preview_cb = function(bufnr, qwinid)
            local ret = true
            local bufname = vim.api.nvim_buf_get_name(bufnr)
            local fsize = vim.fn.getfsize(bufname)
            if fsize > 1000 * 1024 then
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
        tabc = 'tabc',
        ptogglemode = 'z,',
    },
    filter = {
        fzf = {
            action_for = { ['ctrl-s'] = 'split', ['ctrl-t'] = 'tabedit', ['ctrl-v'] = 'vsplit' },
            extra_opts = { '--bind', 'ctrl-o:toggle-all', '--prompt', 'QuickFix> ' }
        }
    }
})

-- vim-bookmarks
vim.g.bookmark_save_per_working_dir = 1
vim.g.bookmark_auto_save = 1

-- QFEnter
vim.g.qfenter_exclude_filetypes = {'NvimTree'}
vim.g.qfenter_excluded_action = 'error'

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
    ensure_installed = { 'c', 'lua', 'cpp', 'python', 'rust' },
    sync_install = false,

    auto_install = true,

    highlight = {
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
local actions = require('telescope.actions')
local action_layout = require('telescope.actions.layout')
require('telescope').setup {
    defaults = {
        dynamic_preview_title = true,
        vimgrep_arguments = {
            'rg',
            '--color=never',
            '--no-heading',
            '--with-filename',
            '--line-number',
            '--column',
            '--smart-case',
            '--trim'
        },
        mappings = {
            i = {
                -- ['<esc>'] = actions.close,
                ['<C-u>'] = false,
                ['<M-p>'] = action_layout.toggle_preview
            },
            n = {
                ['<M-p>'] = action_layout.toggle_preview
            },
        },
        path_display = {
            truncate = 30,
        }
    },
    pickers = {
        find_files = {
            path_display = {
                'absolute',
            }
        }
    },
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

require('possession').setup {
    session_dir = '/home/john/.nvim/config/data/possession',
    silent = false,
    load_silent = true,
    debug = false,
    prompt_no_cr = false,
    autosave = {
        current = false, -- or fun(name): boolean
        tmp = false, -- or fun(): boolean
        tmp_name = 'tmp',
        on_load = false,
        on_quit = false,
    },
    commands = {
        save = 'SSave',
        load = 'SLoad',
        close = 'SClose',
        delete = 'SDel',
        show = 'SShow',
        list = 'SList',
        migrate = 'SMigrate',
    },
    hooks = {
        before_save = function(name) return {} end,
        after_save = function(name, user_data, aborted) end,
        before_load = function(name, user_data) return user_data end,
        after_load = function(name, user_data) end,
    },
    plugins = {
        close_windows = {
            hooks = { 'before_save', 'before_load' },
            preserve_layout = true, -- or fun(win): boolean
            match = {
                floating = true,
                buftype = {},
                filetype = {},
                custom = false, -- or fun(win): boolean
            },
        },
        --delete_hidden_buffers = false,
        delete_hidden_buffers = {
            hooks = {
                'before_load',
                vim.o.sessionoptions:match('buffer') and 'before_save',
            },
            force = false, -- or fun(buf): boolean
        },
        nvim_tree = true,
        tabby = true,
        delete_buffers = false,
    },
}

require('telescope').load_extension 'file_browser'
require('telescope').load_extension 'fzf'
require('telescope').load_extension 'possession'
require('telescope').load_extension 'vim_bookmarks'

-- Grepper
vim.g.grepper = {
    tools = { 'rg', 'grep' },
    searchreg = 1,
}

-- https://github.com/mhinz/vim-grepper
vim.g.grepper = { tools = { 'rg', 'grep' }, searchreg = 1 }
vim.cmd(([[
    aug Grepper
        au!
        au User Grepper ++nested %s
    aug END
]]):format([[call setqflist([], 'r', {'context': {'bqf': {'pattern_hl': '\%#' . getreg('/')}}})]]))

-- try `gsiw` under word
vim.cmd([[
    nmap gs  <plug>(GrepperOperator)
    xmap gs  <plug>(GrepperOperator)
]])

-- Winresizer
vim.g.winresizer_start_key = '<leader>rs'

-- Key mappers
local function map(mode, lhs, rhs, opts)
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
--map('n', '<leader>*', ':Grepper -tool rg -cword -noprompt<cr>', {})
map('n', '<leader>n', ':NvimTreeToggle<cr>', {})
map('v', '<leader>y', '"+y', {})
map('', '<f12>', ':set list!<cr>', {})
map('', '<leader>w', ':set wrap!<cr>', {})

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
