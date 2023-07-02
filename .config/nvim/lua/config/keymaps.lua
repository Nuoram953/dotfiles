-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- set termguicolors to enable highlight groups
vim.opt.termguicolors = true

vim.keymap.set("i", "ne", "<ESC>" ,{noremap=true})
vim.keymap.set("t", "ne", "<C-\\><C-n>", {noremap=true})
-- Telescope
-- <leader> is a space now
local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>ff", builtin.find_files, {})
vim.keymap.set("n", "<leader>fg", builtin.live_grep, {})
vim.keymap.set("n", "<leader>fb", builtin.buffers, {})
vim.keymap.set("n", "<leader>fh", builtin.help_tags, {})
vim.keymap.set("n", "<leader>fp", ":Telescope projects<CR>", {})
vim.keymap.set("n", ";", "<cmd>lua require('telescope.builtin').resume(require('telescope.themes').get_ivy({}))<cr>", opts)

-- NvimTree
vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>", {}) -- open/close
vim.keymap.set("n", "<leader>nr", ":NvimTreeRefresh<CR>", {}) -- refresh
vim.keymap.set("n", "<leader>nf", ":NvimTreeFindFile<CR>", {}) -- search file

-- Symbole-outline
vim.keymap.set("n", "<leader>so", ":SymbolsOutline<CR>", {})

-- Window management
vim.keymap.set('n',"<leader>tv","<C-w>v",{noremap=true, desc="Vertical split"})
vim.keymap.set('n',"<leader>th","<C-w>s",{noremap=true, desc="Horizontal split"})
vim.keymap.set('n',"<C-h>","<C-w>h",{noremap=true})
vim.keymap.set('n',"<C-j>","<C-w>j",{noremap=true})
vim.keymap.set('n',"<C-k>","<C-w>k",{noremap=true})
vim.keymap.set('n',"<C-l>","<C-w>l",{noremap=true})
vim.keymap.set('n',"<C-Up>","<cmd>resize -2<CR>",{noremap=true})
vim.keymap.set('n',"<C-Down>","<cmd>resize +2<CR>",{noremap=true})
vim.keymap.set('n',"<C-Left>","<cmd>vertical resize -2<CR>",{noremap=true})
vim.keymap.set('n',"<C-Right>","<cmd>vertical resize +2<CR>",{noremap=true})

-- Use <Tab> to cycle through buffers in tab
vim.keymap.set("n", "<Tab>", "<cmd>:bprevious<cr>")
vim.keymap.set("n", "<S-Tab>", "<cmd>:bnext<cr>")

vim.keymap.set("v", "J", ":m '>+1<CR>gv==kgvo<esc>=kgvo", { desc = "move highlighted text down" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv==jgvo<esc>=jgvo", { desc = "move highlighted text up" })
