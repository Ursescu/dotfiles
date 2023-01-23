-- Key mappers
local function map(mode, lhs, rhs, opts)
    local options = { noremap = true }
    if opts then
        options = vim.tbl_extend('force', options, opts)
    end
    vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

-- Grepper `gs` motion
vim.cmd([[
    nmap gs  <plug>(GrepperOperator)
    xmap gs  <plug>(GrepperOperator)
]])

vim.cmd [[
  function! QuickFixToggle()
    if empty(filter(getwininfo(), 'v:val.quickfix'))
      botright copen
    else
      cclose
    endif
  endfunction
]]

local commands = {
    {
        name = 'BufferKill',
        fn = function()
            require('config.bufferline').buf_kill('bd')
        end,
    },
}

local function command_install(collection)
    local common_opts = { force = true }
    for _, cmd in pairs(collection) do
        local opts = vim.tbl_deep_extend('force', common_opts, cmd.opts or {})
        vim.api.nvim_create_user_command(cmd.name, cmd.fn, opts)
    end
end

-- Install commands
command_install(commands)

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
map('n', '<leader>c', ':BufferKill<cr>', {})
map('n', '<leader>fb', ':Telescope buffers<cr>', {})
map('n', '<leader>a', ':BufferLinePick<cr>', {})
map('n', '<leader>t', ':BufferLineCycleNext<cr>', {})
map('n', '<leader>r', ':BufferLineCyclePrev<cr>', {})
map('', '<C-q>', ':call QuickFixToggle()<cr>', {})
map('', '<f12>', ':set list!<cr>', {})
map('', '<leader>w', ':set wrap!<cr>', {})
-- map('n', '[[', '?{<CR>w99[{', {})
-- map('n', '][', '/}<CR>b99]}', {})
-- map('n', ']]', 'j0[[%/{<CR>', {})
-- map('n', '[]', 'k$][%?}<CR>', {})
map('n', '<C-h>', '<C-w>h', {})
map('n', '<C-j>', '<C-w>j', {})
map('n', '<C-k>', '<C-w>k', {})
map('n', '<C-l>', '<C-w>l', {})
map('n', '<leader>w', ':lua require("nvim-window").pick()<cr>', {})
-- vim.keymap.set('n', '<c-\\>', '<Cmd>execute v:count . "ToggleTerm"<CR>', {})
