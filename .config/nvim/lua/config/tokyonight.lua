local M = {}

function M.setup()
    print("SETUP")
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
        sidebars = {"qf", "NvimTree", "help"},
    })
end

return M
