local M = {}

function M.setup()
    -- Nvim Tree sitter config
    require('nvim-treesitter.configs').setup {
        ensure_installed = { 'c', 'lua', 'cpp', 'python', 'rust' },
        sync_install = false,

        auto_install = true,

        highlight = {
            enable = true,
            additional_vim_regex_highlighting = false
        },
        -- This plugin is not updating the state while typing
        -- rainbow = {
        --     enable = true,
        --     disable = {},
        --     extended_mode = true,
        --     max_file_lines = nil
        -- }
    }
end

-- M.setup()
return M
