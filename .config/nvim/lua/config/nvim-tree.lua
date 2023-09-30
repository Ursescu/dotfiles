local M = {}

local function open_nvim_tree(data)

  -- buffer is a directory
  local directory = vim.fn.isdirectory(data.file) == 1

  if not directory then
    return
  end

  -- change to the directory
  vim.cmd.cd(data.file)

  -- open the tree
  require("nvim-tree.api").tree.open()
end

function M.setup()

    -- Nvim tree setup
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1

    require('nvim-tree').setup({
        -- open_on_setup = true,
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

    vim.api.nvim_create_autocmd({ "VimEnter" }, { callback = open_nvim_tree })
end

-- M.setup()
return M
