-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.g.mapleader = " "

-- disable netrw at the very start of your init.lua (strongly advised)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1


vim.keymap.set("i", "jk", "<ESC>" ,{noremap=true})
vim.keymap.set("t", "jk", "<C-\\><C-n>", {noremap=true})

-- telescope
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})

vim.keymap.set('n', '<leader>e', ':NvimTreeToggle<CR>', {noremap = true})

-- Splits
vim.keymap.set('n',"<C-h>","<C-w>h",{noremap=true})
vim.keymap.set('n',"<C-j>","<C-w>j",{noremap=true})
vim.keymap.set('n',"<C-k>","<C-w>k",{noremap=true})
vim.keymap.set('n',"<C-l>","<C-w>l",{noremap=true})
vim.keymap.set('n',"<C-Up>","<cmd>resize -2<CR>",{noremap=true})
vim.keymap.set('n',"<C-Down>","<cmd>resize +2<CR>",{noremap=true})
vim.keymap.set('n',"<C-Left>","<cmd>vertical resize -2<CR>",{noremap=true})
vim.keymap.set('n',"<C-Right>","<cmd>vertical resize +2<CR>",{noremap=true})

-- buffers
vim.keymap.set('n',"<leader>tv","<C-w>v",{noremap=true, desc="Vertical split"})
vim.keymap.set('n',"<leader>th","<C-w>s",{noremap=true, desc="Horizontal split"})
