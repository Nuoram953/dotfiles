-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- set termguicolors to enable highlight groups
vim.opt.termguicolors = true

vim.keymap.set("i", "jj", "<ESC>", { noremap = true })
vim.keymap.set("t", "jj", "<C-\\><C-n>", { noremap = true })
-- Telescope
-- <leader> is a space now
local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Find files" })
vim.keymap.set("n", "<leader>fg", ":lua require('telescope').extensions.live_grep_args.live_grep_args()<CR>")
vim.keymap.set("n", "<leader>fb", builtin.buffers, {})
vim.keymap.set("n", "<leader>so", builtin.lsp_document_symbols, {})
vim.keymap.set("n", "<leader>sO", builtin.lsp_workspace_symbols, {})
vim.keymap.set("n", "<leader>fh", builtin.help_tags, {})
vim.keymap.set("n", "<leader>fp", ":Telescope projects<CR>", {})
vim.keymap.set(
	"n",
	";",
	"<cmd>lua require('telescope.builtin').resume(require('telescope.themes').get_ivy({}))<cr>",
	opts
)
vim.keymap.set("n", "<space>e", ":Telescope file_browser<CR>", { noremap = true })

-- open file_browser with the path of the current buffer
vim.keymap.set("n", "<space>e", ":Telescope file_browser path=%:p:h select_buffer=true<CR>", { noremap = true })

-- Window management
vim.keymap.set("n", "<leader>tv", "<C-w>v", { noremap = true, desc = "Vertical split" })
vim.keymap.set("n", "<leader>th", "<C-w>s", { noremap = true, desc = "Horizontal split" })
vim.keymap.set("n", "<C-h>", "<C-w>h", { noremap = true })
vim.keymap.set("n", "<C-j>", "<C-w>j", { noremap = true })
vim.keymap.set("n", "<C-k>", "<C-w>k", { noremap = true })
vim.keymap.set("n", "<C-l>", "<C-w>l", { noremap = true })
vim.keymap.set("n", "<C-Up>", "<cmd>resize -2<CR>", { noremap = true })
vim.keymap.set("n", "<C-Down>", "<cmd>resize +2<CR>", { noremap = true })
vim.keymap.set("n", "<C-Left>", "<cmd>vertical resize -2<CR>", { noremap = true })
vim.keymap.set("n", "<C-Right>", "<cmd>vertical resize +2<CR>", { noremap = true })

-- Use <Tab> to cycle through buffers in tab
vim.keymap.set("n", "<Tab>", "<cmd>:bprevious<cr>")
vim.keymap.set("n", "<S-Tab>", "<cmd>:bnext<cr>")

vim.keymap.set("v", "J", ":m '>+1<CR>gv==kgvo<esc>=kgvo", { desc = "move highlighted text down" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv==jgvo<esc>=jgvo", { desc = "move highlighted text up" })

-- Refactor
vim.keymap.set("x", "<leader>re", ":Refactor extract ")
vim.keymap.set("x", "<leader>rf", ":Refactor extract_to_file ")
vim.keymap.set("x", "<leader>rv", ":Refactor extract_var ")
vim.keymap.set({ "n", "x" }, "<leader>ri", ":Refactor inline_var")
vim.keymap.set( "n", "<leader>rI", ":Refactor inline_func")
vim.keymap.set("n", "<leader>rb", ":Refactor extract_block")
vim.keymap.set("n", "<leader>rbf", ":Refactor extract_block_to_file")
