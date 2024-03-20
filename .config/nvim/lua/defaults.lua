-- local g = vim.g
local opt = vim.opt
local cmd = vim.cmd
local wo = vim.wo

vim.g.zoomwintab_hidetabbar = 0

vim.o.shell = '/usr/bin/bash'
vim.bo.expandtab = true
opt.expandtab = true
opt.ts = 4
opt.sw = 4
opt.number = true
opt.showcmd = true
opt.laststatus = 2
opt.incsearch = true
opt.ignorecase = true
opt.smartcase = true
opt.number = true
opt.relativenumber = true
opt.jumpoptions = 'stack'
wo.wrap = false
cmd([[set listchars=tab:-->,extends:>,precedes:<,space:·]])
wo.list = true
opt.scrolloff = 8
opt.sidescrolloff = 8
opt.splitright = true
opt.swapfile = false
opt.backup = false
opt.termguicolors = true
opt.fixeol = false
opt.title = true
cmd("set titlestring=NVIM:\\ %{substitute(getcwd(),\\ $HOME,\\ '~',\\ '')}")

-- CMP Setup
opt.completeopt = { 'menu', 'menuone', 'noselect' }

-- Auto-session
opt.sessionoptions = 'blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions'

-- Set nvim
vim.g.python3_host_prog = os.getenv('HOME') .. '/.pyenv/versions/py3nvim/bin/python'
vim.g.loaded_perl_provider = 0

cmd('colorscheme tokyonight-night')
