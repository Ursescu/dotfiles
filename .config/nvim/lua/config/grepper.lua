local M = {}

function M.setup()

    -- Grepper
    vim.g.grepper = {
        tools = { 'rg', 'grep' },
        searchreg = 1,
    }

    vim.cmd(([[
    aug Grepper
        au!
        au User Grepper ++nested %s
    aug END
    ]]):format([[call setqflist([], 'r', {'context': {'bqf': {'pattern_hl': '\%#' . getreg('/')}}})]]))

end

return M
