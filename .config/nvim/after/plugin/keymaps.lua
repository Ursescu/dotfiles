
-- Key mappers
local function map(mode, lhs, rhs, opts)
    local options = { noremap = true }
    if opts then
        options = vim.tbl_extend("force", options, opts)
    end
    vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end


-- Grepper `gs` motion
vim.cmd([[
    nmap gs  <plug>(GrepperOperator)
    xmap gs  <plug>(GrepperOperator)
]])

-- Winresizer
vim.g.winresizer_start_key = '<leader>rs'

map('n', '<leader>ff', ':Telescope find_files<cr>', {})
map('n', '<leader>fg', ':Telescope live_grep<cr>', {})
map('n', '<leader>fe', ':Telescope file_browser<cr>', {})
map('v', '<leader>c', ':OSCYank<cr>', {})
map('n', '<leader>*', ':Grepper -noprompt -buffer -cword<cr>', {})
map('n', '<leader>n', ':NvimTreeToggle<cr>', {})
map('v', '<leader>y', '"+y', {})
map('n', '<leader>y', '"+y', {})
map('', '<f12>', ':set list!<cr>', {})
map('', '<leader>w', ':set wrap!<cr>', {})
map('n', '[[', '?{<CR>w99[{', {})
map('n', '][', '/}<CR>b99]}', {})
map('n', ']]', 'j0[[%/{<CR>', {})
map('n', '[]', 'k$][%?}<CR>', {})

-- vim.keymap.set('n', '<c-\\>', '<Cmd>execute v:count . "ToggleTerm"<CR>', {})
