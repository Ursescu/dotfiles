local M = {}

function M.setup()

    -- Nvim tree setup
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1

    require('nvim-tree').setup({
        view = {
            adaptive_size = false,
            width = 30,
            side = 'left',
            mappings = {
                list = {
                    { key = '<C-y>', action = 'toggle_file_info' },
                    { key = '<C-k>', action = '' }
                }
            }
        },
        -- actions = {
        --     open_file = {
        --         resize_window = false,
        --     }
        -- },
        git = {
            enable = false,
        },
        disable_netrw = true,
    })
end

-- M.setup()
return M
