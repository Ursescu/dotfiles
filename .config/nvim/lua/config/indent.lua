local M = {}

function M.setup()
    -- require('indent_blankline').setup({
    --     show_current_context = true,
    --     show_current_context_start = false,
    --     space_char_blankline = " ",
    -- })
    -- require('ibl').setup({
    --     indent = {
    --         smart_indent_cap = false,
    --         char = "│",
    --     },
    -- })

    require('ibl').setup({
        debounce = 10,
        scope = {
            enabled = false
        },
        indent = {
            -- smart_indent_cap = false,
            char = "│",
        },
    })
end

-- M.setup()
return M
