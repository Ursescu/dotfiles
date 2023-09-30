local M = {}

function M.setup()
    require('toggleterm').setup({
        open_mapping = [[<c-\>]],
        persist_mode = true,
        direction = 'horizontal'
    })
end

-- M.setup()
return M
