local M = {}

function M.setup()
    require('toggleterm').setup({
        open_mapping = [[<c-\>]],
        persist_mode = true,
        direction = 'float'
    })
end

-- M.setup()
return M
