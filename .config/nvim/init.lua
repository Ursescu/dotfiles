require('plugins').setup()

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
local on_attach = function(_, bufnr)
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


local capabilities = require('cmp_nvim_lsp').default_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

local lsp_flags = {
    -- This is the default in Nvim 0.7+
    debounce_text_changes = 150,
}

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
-- lspconfig.ccls.setup({
--     on_attach = on_attach,
--     flags = lsp_flags,
--     capabilities = capabilities,
-- })

lspconfig.clangd.setup({
    cmd = {
        "clangd",
        "--compile-commands-dir=."
    },
    autostart = true,
    on_attach = on_attach,
    flags = lsp_flags,
    capabilities = capabilities,
    root_dir = function(_)
        -- print("Hello root dir here")
        -- print(lspconfig.clangd.document_config.default_config.root_dir(fname))
        -- print(vim.fn.getcwd())
        return vim.fn.getcwd()
        -- lspconfig.clangd.document_config.default_config.root_dir(fname) or vim.fn.getcwd()
    end,
})

-- vim-bookmarks
vim.g.bookmark_save_per_working_dir = 1
vim.g.bookmark_auto_save = 1

-- QFEnter
vim.g.qfenter_exclude_filetypes = {'NvimTree'}
vim.g.qfenter_excluded_action = 'error'

-- Nvim tree setup
vim.g.loaded_netrw = 1
vim.g.loaded = 1
vim.g.loaded_netrwPlugin = 1

-- set termguicolors to enable highlight groups
vim.opt.termguicolors = true

-- OR setup with some options
require("nvim-tree").setup({
    -- sort_by = "case_sensitive",
    view = {
        adaptive_size = true,
        -- mappings = {
        --     list = {
        --         { key = "u", action = "dir_up" },
        --     },
        -- },
    },
    disable_netrw = true,
    -- renderer = {
    --     group_empty = true,
    -- },
    -- filters = {
    --     dotfiles = true,
    -- },
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


require('telescope').load_extension 'file_browser'
require('telescope').load_extension 'fzf'
require('telescope').load_extension 'possession'
require('telescope').load_extension 'vim_bookmarks'

