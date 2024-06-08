vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.opt.termguicolors = true

local bufopts = { noremap = true, silent = true }

vim.keymap.set({ "n", "x" }, "<leader>fo", ":Format<CR>", { noremap = true })
vim.keymap.set("n", "<space>e", "<CMD>Oil<CR>", { desc = "Open parent directory" })

-- fzf
vim.keymap.set("n", "<c-t>", "<cmd>lua require('fzf-lua').files()<CR>", { silent = true })
vim.keymap.set("n", "<leader>fb", "<cmd>lua require('fzf-lua').buffers()<CR>", { silent = true })
vim.keymap.set("n", "<c-g>", "<<cmd>lua require('fzf-lua').live_grep()<CR>", { silent = true })
vim.keymap.set("n", "<leader>ff", "<cmd>lua require('fzf-lua').oldfiles()<CR>", { silent = true })
vim.keymap.set("n", "<leader>fm", "<cmd>lua require('fzf-lua').marks()<CR>", { silent = true })
vim.keymap.set("n", "<leader>fr", "<cmd>lua require('fzf-lua').resume()<CR>", { silent = true })
vim.keymap.set("n", "<leader>fgc", "<cmd>lua require('fzf-lua').grep_cword()<CR>", { silent = true, noremap = true })
vim.keymap.set("x", "<leader>fgv", "<cmd>lua require('fzf-lua').grep_visual()<CR>", { silent = true, noremap = true })
vim.keymap.set("n", "<leader>so", "<cmd>lua require('fzf-lua').lsp_document_symbols()<CR>", { silent = true })
vim.keymap.set("n", "<leader>sO", "<cmd>lua require('fzf-lua').lsp_workspace_symbols()<CR>", { silent = true })

-- Window management
vim.keymap.set("n", "<leader>tv", "<C-w>v", { noremap = true, desc = "Vertical split" })
vim.keymap.set("n", "<leader>th", "<C-w>s", { noremap = true, desc = "Horizontal split" })
vim.keymap.set("n", "<C-h>", "<cmd>lua require'tmux'.move_left()<cr>", { desc = "Go to left window" })
vim.keymap.set("n", "<C-j>", "<cmd>lua require'tmux'.move_bottom()<cr>", { desc = "Go to lower window" })
vim.keymap.set("n", "<C-k>", "<cmd>lua require'tmux'.move_top()<cr>", { desc = "Go to upper window" })
vim.keymap.set("n", "<C-l>", "<cmd>lua require'tmux'.move_right()<cr>", { desc = "Go to right window" })
vim.keymap.set("n", "<C-Down>", "<cmd>resize -2<CR>", { noremap = true })
vim.keymap.set("n", "<C-Up>", "<cmd>resize +2<CR>", { noremap = true })
vim.keymap.set("n", "<C-Left>", "<cmd>vertical resize -2<CR>", { noremap = true })
vim.keymap.set("n", "<C-Right>", "<cmd>vertical resize +2<CR>", { noremap = true })

-- Use <Tab> to cycle through buffers in tab
vim.keymap.set("n", "<Tab>", "<cmd>:bprevious<cr>")
vim.keymap.set("n", "<S-Tab>", "<cmd>:bnext<cr>")
vim.keymap.set("v", "J", ":m '>+1<CR>gv==kgvo<esc>=kgvo", { desc = "move highlighted text down" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv==jgvo<esc>=jgvo", { desc = "move highlighted text up" })

-- nvim-scissors
vim.keymap.set("n", "<leader>se", function()
	require("scissors").editSnippet()
end)
vim.keymap.set({ "n", "x" }, "<leader>sa", function()
	require("scissors").addNewSnippet()
end)

-- Refactor
vim.keymap.set("x", "<leader>re", ":Refactor extract", { desc = "Refactor extract" })
vim.keymap.set("x", "<leader>rf", ":Refactor extract_to_file", { desc = "Refactor extract_to_file" })
vim.keymap.set("x", "<leader>rv", ":Refactor extract_var ")
vim.keymap.set({ "n", "x" }, "<leader>ri", ":Refactor inline_var", { desc = "Refactor inline_var" })
vim.keymap.set("n", "<leader>rI", ":Refactor inline_func")
vim.keymap.set("n", "<leader>rb", ":Refactor extract_block")
vim.keymap.set("n", "<leader>rbf", ":Refactor extract_block_to_file")

-- Quickfix list
vim.keymap.set(
	"n",
	"<leader>qn",
	"<cmd>cnext<CR>",
	{ desc = "Go to next element Quickfix", noremap = true, silent = true }
)
vim.keymap.set(
	"n",
	"<leader>qp",
	"<cmd>cprev<CR>",
	{ desc = "Go to previous element Quickfix", noremap = true, silent = true }
)
vim.keymap.set(
	"n",
	"<leader>qln",
	"<cmd>lnext<CR>",
	{ desc = "Go to next list element Quickfix", noremap = true, silent = true }
)
vim.keymap.set(
	"n",
	"<leader>qlp",
	"<cmd>lprev<CR>",
	{ desc = "Go to previous list element Quickfix", noremap = true, silent = true }
)

--lsp
vim.keymap.set(
	"n",
	"<leader>dq",
	"<cmd>lua vim.diagnostic.setloclist()<CR>",
	{ desc = "Send lsp to Quickfix list", noremap = true, silent = true }
)
vim.keymap.set(
	"n",
	"<leader>dn",
	"<cmd>lua vim.diagnostic.goto_next()<CR>",
	{ desc = "Go to next element diagnostic", noremap = true, silent = true }
)
vim.keymap.set(
	"n",
	"<leader>dp",
	"<cmd>lua vim.diagnostic.goto_prev()<CR>",
	{ desc = "Go to previous element Quickfix", noremap = true, silent = true }
)

-- dap
-- vim.keymap.set("n", "<leader>db", ":DapToggleBreakpoint<CR>", { desc = "Toggle breakpoint", noremap = true })
-- local dapui = require("dapui")
-- vim.keymap.set("n", "<leader>dut", dapui.toggle, { desc = "Toggle dapui", noremap = true })

-- gitsigns
local gitsigns = require("gitsigns")
vim.keymap.set("n", "<leader>hr", gitsigns.reset_hunk)
vim.keymap.set("n", "<leader>hv", gitsigns.preview_hunk)
vim.keymap.set("n", "<leader>hd", gitsigns.diffthis)
vim.keymap.set("n", "<leader>hD", function()
	gitsigns.diffthis("~")
end)
vim.keymap.set("n", "<leader>hn", "<cmd>Gitsigns next_hunk<CR>")
vim.keymap.set("n", "<leader>hp", "<cmd>Gitsigns prev_hunk<CR>")

--octo
vim.keymap.set("n", "<leader>opl", "<cmd>Octo pr list<CR>", { desc = "List prs", noremap = true, silent = true })

-- lsp
vim.keymap.set("n", "<leader>gD", "<cmd>FzfLua lsp_declarations<cr>", bufopts)
vim.keymap.set("n", "<leader>gd", "<cmd>FzfLua lsp_definitions<cr>", bufopts)
vim.keymap.set("n", "<leader>gr", "<cmd>FzfLua lsp_references<cr>", bufopts)
vim.keymap.set("n", "<leader>gi", "<cmd>FzfLua lsp_implementations<cr>", bufopts)
vim.keymap.set("n", "<leader>gt", "<cmd>FzfLua lsp_type_definitions<cr>", bufopts)
vim.keymap.set("n", "<leader>K", vim.lsp.buf.hover, bufopts)
vim.keymap.set("n", "<leader>k", vim.lsp.buf.signature_help, bufopts)
vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, bufopts)
vim.keymap.set("n", "<leader>ca", "<cmd>FzfLua lsp_code_actions<cr>", bufopts)

--dadbod
vim.keymap.set("n", "<leader>dbo", "<cmd>DBUI<cr>", bufopts)
vim.keymap.set("n", "<leader>dbc", "<cmd>DBUIClose<cr>", bufopts)
