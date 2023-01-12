-- local g = vim.g
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
opt.number = true
opt.relativenumber = true
opt.jumpoptions = "stack"
wo.wrap = false
opt.listchars = "tab:→\\ ,extends:>,precedes:<,space:·"
wo.list = true
opt.scrolloff = 8
opt.sidescrolloff = 8
opt.splitright = true
cmd("set sessionoptions-=buffers")

opt.termguicolors = true

-- Setting it twice to activate hightlights for bufferline (don't know why this is needed)
vim.cmd("colorscheme tokyonight-night")
vim.cmd("colorscheme tokyonight-night")
