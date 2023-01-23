local M = {}

function M.setup()
    require('tokyonight').setup({
        style = 'night',
        styles = {
            comments = {
                italic = false
            },
            keywords = {
                italic = false
            },
        },
        sidebars = { "qf", "NvimTree", "help" },
    })
end

return M
