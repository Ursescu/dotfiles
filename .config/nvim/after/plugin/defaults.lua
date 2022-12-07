local g = vim.g
local opt = vim.opt
local cmd = vim.cmd
local wo = vim.wo

-- g.mapleader = " "
-- g.maplocalleader = ","

opt.expandtab = true
opt.ts = 4
opt.sw = 4
opt.number = true
opt.showcmd = true
opt.laststatus = 2
opt.incsearch = true
opt.ignorecase = true
opt.smartcase = true
opt.jumpoptions = "stack"
wo.wrap = false
opt.listchars = "tab:→\\ ,extends:>,precedes:<,space:·"
wo.list = true
opt.scrolloff = 10
opt.sidescrolloff = 30
cmd("set sessionoptions-=buffers")

cmd("colorscheme tokyonight-night")
