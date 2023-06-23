local M = {}
local navic = require("nvim-navic")
local vi_mode_utils = require('feline.providers.vi_mode')

local components = {
    active = {},
    inactive = {}
}

table.insert(components.active, {})
table.insert(components.inactive, {})

local inactive = {
    filetypes = {
        '^NvimTree$',
        '^packer$',
        '^startify$',
        '^fugitive$',
        '^fugitiveblame$',
        '^qf$',
        '^help$'
    },
    buftypes = {
        '^terminal$'
    },
    bufnames = {}
}

-- Return true if any pattern in tbl matches provided value
local function find_pattern_match(tbl, val)
    return tbl
        and next(vim.tbl_filter(function(pattern)
            return val:match(pattern)
        end, tbl))
end

table.insert(components.active[1], {
    provider = function(component)
        local filetype = vim.bo.filetype

        if find_pattern_match(inactive.filetypes, filetype) then
            return '', nil
        else
            return require('feline.providers.file').file_info(component, {})
        end
    end,
    hl = function()
        local filetype = vim.bo.filetype

        if find_pattern_match(inactive.filetypes, filetype) then
            return 'Normal'
        else
            return {
                fg = 'skyblue',
                bg = 'NONE',
                style = 'bold',
            }
        end
    end,
    right_sep = {
        str = ' ',
        hl = 'Normal'
    }
})

table.insert(components.active[1], {
    provider = function()
        return navic.get_location()
    end,
    enabled = function()
        return navic.is_available()
    end,
    hl = 'Normal',
})

table.insert(components.inactive[1], {
    provider = function(component)
        local filetype = vim.bo.filetype

        if find_pattern_match(inactive.filetypes, filetype) then
            return '', nil
        else
            return require('feline.providers.file').file_info(component, {})
        end
    end,
    hl = function()
        local filetype = vim.bo.filetype
        -- vim.pretty_print(filetype)
        if find_pattern_match(inactive.filetypes, filetype) then
            return 'Normal'
        else
            return {
                fg = 'white',
                bg = 'NONE',
                style = 'bold',
            }
        end
    end,
})

local status_line_components = {
    active = {},
    inactive = {}
}

status_line_components.active[1] = {
    {
        provider = '▊ ',
        hl = {
            fg = 'skyblue',
        },
    },
    {
        provider = 'vi_mode',
        hl = function()
            return {
                name = vi_mode_utils.get_mode_highlight_name(),
                fg = vi_mode_utils.get_mode_color(),
                style = 'bold',
            }
        end,
    },
    {
        provider = {
            name = 'file_info',
            opts = {
                type = 'relative'
            }
        },
        hl = {
            fg = 'white',
            bg = 'oceanblue',
            style = 'bold',
        },
        left_sep = {
            'slant_left_2',
            { str = ' ', hl = { bg = 'oceanblue', fg = 'NONE' } },
        },
        right_sep = {
            { str = ' ', hl = { bg = 'oceanblue', fg = 'NONE' } },
            'slant_right_2',
            ' ',
        },
    },
    {
        provider = 'file_size',
        right_sep = {
            ' ',
            {
                str = 'slant_left_2_thin',
                hl = {
                    fg = 'fg',
                    bg = 'bg',
                },
            },
        },
    },
    {
        provider = 'position',
        left_sep = ' ',
        right_sep = {
            ' ',
            {
                str = 'slant_right_2_thin',
                hl = {
                    fg = 'fg',
                    bg = 'bg',
                },
            },
        },
    },
    {
        provider = 'diagnostic_errors',
        hl = { fg = 'red' },
    },
    {
        provider = 'diagnostic_warnings',
        hl = { fg = 'yellow' },
    },
    {
        provider = 'diagnostic_hints',
        hl = { fg = 'cyan' },
    },
    {
        provider = 'diagnostic_info',
        hl = { fg = 'skyblue' },
    },
}

status_line_components.active[2] = {
    {
        provider = 'git_branch',
        hl = {
            fg = 'white',
            bg = 'black',
            style = 'bold',
        },
        right_sep = {
            str = ' ',
            hl = {
                fg = 'NONE',
                bg = 'black',
            },
        },
    },
    {
        provider = 'git_diff_added',
        hl = {
            fg = 'green',
            bg = 'black',
        },
    },
    {
        provider = 'git_diff_changed',
        hl = {
            fg = 'orange',
            bg = 'black',
        },
    },
    {
        provider = 'git_diff_removed',
        hl = {
            fg = 'red',
            bg = 'black',
        },
        right_sep = {
            str = ' ',
            hl = {
                fg = 'NONE',
                bg = 'black',
            },
        },
    },
    {
        provider = 'line_percentage',
        hl = {
            style = 'bold',
        },
        left_sep = '  ',
        right_sep = ' ',
    },
    {
        provider = 'scroll_bar',
        hl = {
            fg = 'skyblue',
            style = 'bold',
        },
    },
}

status_line_components.inactive[1] = {
    {
        provider = 'file_type',
        hl = {
            fg = 'white',
            bg = 'oceanblue',
            style = 'bold',
        },
        left_sep = {
            str = ' ',
            hl = {
                fg = 'NONE',
                bg = 'oceanblue',
            },
        },
        right_sep = {
            {
                str = ' ',
                hl = {
                    fg = 'NONE',
                    bg = 'oceanblue',
                },
            },
            'slant_right',
        },
    },
    {}
}

function M.setup()
    require('feline').setup({
        components = status_line_components
    })

    require('feline').winbar.setup({
        components = components,
        use_autocmd = true,
        disable = inactive,
    })
end

-- M.setup()
return M
