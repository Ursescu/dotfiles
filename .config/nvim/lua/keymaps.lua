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
        name = 'KillFloating',
        fn = function()
            for _, win in pairs(vim.api.nvim_list_wins()) do
                if vim.api.nvim_win_get_config(win).relative == 'win' then
                    vim.api.nvim_win_close(win, false)
                end
            end
        end
    },
    {
        name = 'BufferKill',
        fn = function()
            require('utils').buf_kill('bd')
        end,
    },
    {
        name = 'OnlyCurr',
        fn = function()
            local buff_kill = require('utils').buf_kill

            local current_buff = vim.api.nvim_get_current_buf()
            local current_win = vim.api.nvim_get_current_win()

            -- Delete all windows that display current buffer and it's not current window
            for _, win in ipairs(vim.api.nvim_list_wins()) do
                if win ~= current_win and vim.fn.winbufnr(win) == current_buff then
                    vim.api.nvim_win_close(win, false)
                end
            end

            -- Delete all other buffers and their window
            for _, buffer in ipairs(vim.api.nvim_list_bufs()) do
                if buffer ~= current_buff and vim.fn.buflisted(buffer) == 1 then
                    local win_id = vim.fn.bufwinid(buffer)
                    if win_id ~= -1 then
                        vim.api.nvim_win_close(win_id, false)
                    end
                    buff_kill('bd', buffer)
                end
            end
        end,
    },
    {
        -- Copy full path of current window in clipboard
        name = 'Cppath',
        fn = function()
            local path = vim.fn.expand("%:p")
            vim.fn.setreg("+", path)
            vim.notify('Copied "' .. path .. '" to the clipboard!')
        end
    }
}

vim.cmd [[
    function! WipeAll()
        let i = 0
        let n = bufnr("$")
        while i < n
            let i = i + 1
            if bufexists(i)
                execute("bw " . i)
            endif
        endwhile
    endfunction
]]

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
vim.g.winresizer_start_key = '<leader>i'

map('n', '<leader>ff', ':Telescope find_files<cr>', {})
map('n', '<leader>fg', ':Telescope live_grep<cr>', {})
map('n', '<leader>fe', ':Telescope file_browser<cr>', {})
map('n', '<leader>fa', ':lua require("telescope").extensions.live_grep_args.live_grep_args()<CR>', {})
map('v', '<leader>c', ':OSCYank<cr>', {})
map('n', '<leader>*', ':Grepper -noprompt -buffer -cword<cr>', {})
map('n', '<leader>n', ':NvimTreeToggle<cr>', {})
map('v', '<leader>y', '"+y', {})
map('n', '<leader>y', '"+y', {})
map('n', '<leader>c', ':BufferKill<cr>', {})
map('n', '<leader>fb', ':Telescope buffers<cr>', {})
map('n', '<leader>b', ':Telescope vim_bookmarks<cr>', {})
map('n', '<leader>a', ':BufferLinePick<cr>', {})
map('n', '<leader>t', ':BufferLineCycleNext<cr>', {})
map('n', '<leader>r', ':BufferLineCyclePrev<cr>', {})
map('', '<C-q>', ':call QuickFixToggle()<cr>', {})
map('', '<f12>', ':set list!<cr>', {})
map('', '<leader>w', ':set wrap!<cr>', {})
map('n', '<C-d>', '<C-d>zz', {})
map('n', '<C-u>', '<C-u>zz', {})
map('n', '<C-h>', '<C-w>h', {})
map('n', '<C-j>', '<C-w>j', {})
map('n', '<C-k>', '<C-w>k', {})
map('n', '<C-l>', '<C-w>l', {})
map('n', 'ss', ':HopWord<cr>', {})
-- map('n', '<leader>z', ':HopWord<cr>', {})
map('n', 'sw', ':lua require("nvim-window").pick()<cr>', {})

-- Delete to void register
map('n', '<leader>d', [["_d]])
map('v', '<leader>d', [["_d]])
map('n', 'n', 'nzzzv')
map('n', 'N', 'Nzzzv')

-- vim.keymap.set("n", "<leader>bo", "<cmd>%bd|e#<cr>", {desc="Close all buffers but the current one"})
vim.keymap.set('n', 'zR', require('ufo').openAllFolds)
vim.keymap.set('n', 'zM', require('ufo').closeAllFolds)

function _G.set_terminal_keymaps()
    local opts = { buffer = 0 }
    vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], opts)
    vim.keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]], opts)
    vim.keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]], opts)
    vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]], opts)
    vim.keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]], opts)
    vim.keymap.set('t', '<C-w>', [[<C-\><C-n><C-w>]], opts)
end

-- if you only want these mappings for toggle term use term://*toggleterm#* instead
vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')

-- Diagnostic key maps
local opts = { noremap = true, silent = true }
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
vim.keymap.set('n', '<space>q', vim.diagnostic.setqflist, opts)

vim.keymap.set({ 'n' }, '<C-p>', function()
    require('lsp_signature').toggle_float_win()
end, { silent = true, noremap = true, desc = 'toggle signature' })

-- vim.keymap.set('n', '<c-\\>', '<Cmd>execute v:count . "ToggleTerm"<CR>', {})
