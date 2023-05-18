local set = vim.o
set.number = true
set.relativenumber = true

-- keybindings
local opt = { noremap = ture, silent = true }
vim.g.mapleader = " "
vim.keymap.set("n", "<C-l>","<C-w>l", opt)
vim.keymap.set("n", "<C-h>","<C-w>h", opt)
vim.keymap.set("n", "<C-j>","<C-w>j", opt)
vim.keymap.set("n", "<C-k>","<C-w>k", opt)
vim.keymap.set("n","<Leader>v","<C-w>v", opt)
vim.keymap.set("n","<Leader>s","<C-w>s", opt)

-- lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  "folke/which-key.nvim",
  { "folke/neoconf.nvim", cmd = "Neoconf" },
  "folke/neodev.nvim",
})
