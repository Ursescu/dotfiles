local M = {}

function M.setup()

    -- Setup ufo
    vim.o.foldcolumn = '0'
    vim.o.foldlevel = 99
    vim.o.foldlevelstart = 99
    vim.o.foldenable = true

    require('ufo').setup({
        open_fold_hl_timeout = 10,
        provider_selector = function(_, _, _)
            return { 'treesitter', 'indent' }
        end
    })
end

-- M.setup()
return M
