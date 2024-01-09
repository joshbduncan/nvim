local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

-- remap leader key to <space>
keymap("", "<Space>", "<Nop>", opts)
vim.g.mapleader = " "
vim.g.maplocalleader = " "