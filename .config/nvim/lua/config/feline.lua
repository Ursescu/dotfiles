local M = {}
local navic = require("nvim-navic")
local vi_mode_utils = require('feline.providers.vi_mode')

local winbar_components = {
    active = {},
    inactive = {}
}

winbar_components.active[1] = {
    {
        provider = function(component)
            return require('feline.providers.file').file_info(component, {})
        end,
        hl = function()
            return {
                fg = 'skyblue',
                bg = 'NONE',
                style = 'bold',
            }
        end,
        right_sep = {
            str = ' ',
            hl = 'Normal'
        }
    },
    {
        provider = function()
            return navic.get_location()
        end,
        enabled = function()
            return navic.is_available()
        end,
        hl = 'Normal',
    }
}

winbar_components.inactive[1] = {
    {
        provider = function(component)
            return require('feline.providers.file').file_info(component, {})
        end,
        hl = function()
            return {
                fg = 'white',
                bg = 'NONE',
                style = 'bold',
            }
        end,
    }
}

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

    -- Disable WINBAR for these filetypes/buftypes/bufnames
    local winbar_disable = {
        filetypes = {
            '^NvimTree$',
            '^packer$',
            '^startify$',
            '^fugitive$',
            '^fugitiveblame$',
            '^qf$',
            '^help$',
            'toggleterm'
        },
        buftypes = {
            '^terminal$',
            '^nofile$'
        },
        bufnames = {}
    }

    require('feline').winbar.setup({
        components = winbar_components,
        use_autocmd = true,
        disable = winbar_disable,
    })
end

return M
