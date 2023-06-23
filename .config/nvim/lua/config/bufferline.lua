local M = {}



function M.setup()

    local buf_kill = require('utils').buf_kill;

    local options = {
        mode = 'buffers', -- set to 'tabs' to only show tabpages instead
        numbers = 'none', -- can be 'none' | 'ordinal' | 'buffer_id' | 'both' | function
        close_command = function(bufnr)
            buf_kill('bd', bufnr, false)
        end,
        right_mouse_command = 'vert sbuffer %d', -- can be a string | function, see 'Mouse actions'
        left_mouse_command = 'buffer %d', -- can be a string | function, see 'Mouse actions'
        middle_mouse_command = function(bufnr)
            buf_kill('bd', bufnr, false)
        end,
        indicator = {
            icon = '▎', -- this should be omitted if indicator style is not 'icon'
            style = 'icon',
        },

        modified_icon = '●',
        buffer_close_icon = '',
        close_icon = '',

        -- buffer_close_icon = lvim.icons.ui.Close,
        -- modified_icon = lvim.icons.ui.Circle,
        -- close_icon = lvim.icons.ui.BoldClose,
        -- left_trunc_marker = lvim.icons.ui.ArrowCircleLeft,
        -- right_trunc_marker = lvim.icons.ui.ArrowCircleRight,
        --- name_formatter can be used to change the buffer's label in the bufferline.
        --- Please note some names can/will break the
        --- bufferline so use this at your discretion knowing that it has
        --- some limitations that will *NOT* be fixed.
        name_formatter = function(buf) -- buf contains a 'name', 'path' and 'bufnr'
            -- remove extension from markdown files for example
            if buf.name:match '%.md' then
                return vim.fn.fnamemodify(buf.name, ':t:r')
            end
        end,
        max_name_length = 18,
        max_prefix_length = 15, -- prefix used when a buffer is de-duplicated
        truncate_names = true, -- whether or not tab names should be truncated
        tab_size = 18,
        diagnostics = 'nvim_lsp',
        diagnostics_update_in_insert = false,
        -- diagnostics_indicator = diagnostics_indicator,
        -- -- NOTE: this will be called a lot so don't do any heavy processing here
        custom_filter = function(buf, buf_nums)
            local filetype = vim.api.nvim_buf_get_option(buf, 'filetype')
            return filetype ~= 'qf'
        end,
        offsets = {
            {
                filetype = 'undotree',
                text = 'Undotree',
                highlight = 'PanelHeading',
                padding = 1,
            },
            {
                filetype = 'NvimTree',
                text = 'Explorer',
                highlight = 'PanelHeading',
                padding = 1,
            },
            {
                filetype = 'DiffviewFiles',
                text = 'Diff View',
                highlight = 'PanelHeading',
                padding = 1,
            },
            {
                filetype = 'flutterToolsOutline',
                text = 'Flutter Outline',
                highlight = 'PanelHeading',
            },
            {
                filetype = 'packer',
                text = 'Packer',
                highlight = 'PanelHeading',
                padding = 1,
            },
        },
        color_icons = true, -- whether or not to add the filetype icon highlights
        -- show_buffer_icons = lvim.use_icons, -- disable filetype icons for buffers
        show_buffer_close_icons = false,
        show_close_icon = false,
        show_tab_indicators = true,
        persist_buffer_sort = true, -- whether or not custom sorted buffers should persist
        -- can also be a table containing 2 custom separators
        -- [focused and unfocused]. eg: { '|', '|' }
        separator_style = 'thin',
        enforce_regular_tabs = false,
        always_show_bufferline = true,
        hover = {
            enabled = false, -- requires nvim 0.8+
            delay = 200,
            reveal = { 'close' },
        },
        sort_by = 'insert_after_current',
    }

    require('bufferline').setup({
        options = options
    })
end


-- M.setup()
return M
