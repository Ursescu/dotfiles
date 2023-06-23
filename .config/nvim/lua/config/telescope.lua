local M = {}

function M.setup()
    -- Telescope setup
    local action_state = require('telescope.actions.state')

    -- Function to kill buffer from telescope buffer picker
    local function telescope_action_kill_buffer(prompt_bufnr)
        local kill_func = require('utils').buf_kill;
        local current_picker = action_state.get_current_picker(prompt_bufnr)
        current_picker:delete_selection(function(selection)
            kill_func('bd', selection.bufnr, false)
            return true
        end)
    end

    local bookmark_actions = require('telescope').extensions.vim_bookmarks.actions
    local action_layout = require('telescope.actions.layout')
    require('telescope').setup {
        defaults = {
            dynamic_preview_title = true,
            vimgrep_arguments = {
                'rg',
                '--color=never',
                '--no-heading',
                '--with-filename',
                '--line-number',
                '--column',
                '--smart-case',
                '--trim'
            },
            history = {
                path = '~/.local/share/nvim/databases/telescope_history.sqlite3',
                limit = 100,
            },
            mappings = {
                i = {
                    ["<C-h>"] = require('telescope.actions.history').get_simple_history,
                    ["<C-Down>"] = require('telescope.actions').cycle_history_next,
                    ["<C-Up>"] = require('telescope.actions').cycle_history_prev,

                    -- ['<esc>'] = actions.close,
                    ['<M-p>'] = action_layout.toggle_preview
                },
                n = {
                    ['<M-p>'] = action_layout.toggle_preview
                },
            },
            path_display = {
                truncate = 30,
            }
        },
        pickers = {
            find_files = {
                path_display = {
                    'absolute',
                }
            },
            buffers = {
                mappings = {
                    i = {
                        ['<C-k>'] = telescope_action_kill_buffer,
                        ['<M-p>'] = action_layout.toggle_preview
                    },
                    n = {
                        ['<C-k>'] = telescope_action_kill_buffer,
                        ['<M-p>'] = action_layout.toggle_preview
                    },
                },
                path_display = {
                    truncate = 3,
                }
            },
        },
        extensions = {
            file_browser = {
                theme = 'dropdown',
                previewer = false,
                layout_config = {
                    center = {
                        height = 0.8,
                        width = 0.4
                    }
                }
            },
            vim_bookmarks = {
                all = {
                    mappings = {
                        i = {
                            ['<C-k>'] = bookmark_actions.delete_selected_or_at_cursor,
                        }
                    },
                    attach_mappings = function(_, map)
                        map('n', 'dd', bookmark_actions.delete_selected_or_at_cursor)
                        map('i', '<C-k>', bookmark_actions.delete_selected_or_at_cursor)
                    end
                }
            }
        }
    }

    require('telescope').load_extension 'file_browser'
    require('telescope').load_extension 'fzf'
    -- require('telescope').load_extension 'possession'
    require('telescope').load_extension 'vim_bookmarks'
    require('telescope').load_extension 'smart_history'
    require('telescope').load_extension 'live_grep_args'
end

-- M.setup()
return M
