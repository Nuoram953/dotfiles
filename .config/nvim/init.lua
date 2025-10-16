-- -----------------------------------------------------------------------------------------------
-- GENERAL CONFIGURATION
-- -----------------------------------------------------------------------------------------------
vim.g.mapleader = " "

-- Search
vim.opt.hlsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.wildmenu = true

vim.o.signcolumn = "yes"
vim.o.winborder = "rounded"
vim.o.pumborder = "rounded"

vim.opt.backspace = { "eol", "start", "indent" } -- allow backspacing over everything in insert mode
vim.opt.clipboard = "unnamedplus" -- allow neovim to access the system clipboard

-- Indention
vim.opt.autoindent = true -- auto indentation
vim.opt.expandtab = true -- convert tabs to spaces
vim.opt.shiftwidth = 2 -- the number of spaces inserted for each indentation
vim.opt.smartindent = true -- make indenting smarter
vim.opt.softtabstop = 2 -- when hitting <BS>, pretend like a tab is removed, even if spaces
vim.opt.tabstop = 2 -- insert 2 spaces for a tab
vim.opt.shiftround = true -- use multiple of shiftwidth when indenting with "<" and ">"

vim.opt.relativenumber = true

vim.diagnostic.config({ virtual_text = false })

--
-- -----------------------------------------------------------------------------------------------
-- PLUGINS
-- -----------------------------------------------------------------------------------------------
vim.pack.add({
	{ src = "https://github.com/ibhagwan/fzf-lua" },
	{ src = "https://github.com/stevearc/conform.nvim" },
	{ src = "https://github.com/neovim/nvim-lspconfig" },
	{ src = "https://github.com/mason-org/mason.nvim" },
	{ src = "https://github.com/aserowy/tmux.nvim" },
	{ src = "https://github.com/maxmx03/solarized.nvim" },
	{ src = "https://github.com/lukas-reineke/indent-blankline.nvim" },
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter" },
	{ src = "https://github.com/stevearc/oil.nvim" },
	{ src = "https://github.com/nvim-mini/mini.surround" },
	{ src = "https://github.com/nvim-mini/mini.snippets" },
	{ src = "https://github.com/nvim-mini/mini.completion" },
})

require("fzf-lua").register_ui_select({})
require("fzf-lua").setup({
	"fzf-native",
	winopts = {
		preview = {
			layout = "vertical",
			vertical = "top:50%",
		},
	},
})

require("oil").setup()

require("mason").setup()
require("ibl").setup()

require("conform").setup({
	formatters_by_ft = {
		lua = { "stylua" },
		typescript = { "prettier" },
	},
})

require("tmux").setup({
	copy_sync = {
		enable = true,
		sync_clipboard = false,
		sync_registers = true,
	},
})

require("nvim-treesitter.configs").setup({
	ensure_installed = { "lua", "typescript", "tsx" },
	highlight = { enable = true },
})

require("mini.surround").setup()
require("mini.completion").setup({
	window = {
		info = { width = 120 },
	},
})
require("mini.snippets").setup({
	snippets = {
		-- gen_loader.from_file("~/.config/nvim/snippets/global.json"),
		-- gen_loader.from_lang(),
	},
})

-- -----------------------------------------------------------------------------------------------
-- KEYMAPS
-- -----------------------------------------------------------------------------------------------
local bufopts = { noremap = true, silent = true }

vim.keymap.set("n", "<leader>w", ":w<CR>")
vim.keymap.set("n", "<leader>q", ":q<CR>")
vim.keymap.set("n", "<leader>e", "<CMD>Oil<CR>")
vim.keymap.set({ "n", "x" }, "<leader>fo", function()
	require("conform").format({ lsp_fallback = true, async = true })
end, { desc = "Format file or range (in visual mode)" })

vim.keymap.set({ "n", "x" }, "<leader><leader>", "<cmd>FzfLua<cr>", { silent = true })
vim.keymap.set("n", "<c-t>", "<cmd>lua require('fzf-lua').files()<cr>")
vim.keymap.set("n", "<leader>fb", "<cmd>lua require('fzf-lua').buffers()<cr>")
vim.keymap.set("n", "<leader>ff", "<cmd>lua require('fzf-lua').oldfiles()<cr>")
vim.keymap.set("n", "<leader>fr", "<cmd>lua require('fzf-lua').resume()<cr>")
vim.keymap.set("n", "<leader>so", "<cmd>lua require('fzf-lua').lsp_document_symbols()<CR>", { silent = true })
vim.keymap.set("n", "<leader>sO", "<cmd>lua require('fzf-lua').lsp_workspace_symbols()<CR>", { silent = true })

vim.keymap.set("n", "<leader>tv", "<C-w>v", { noremap = true, desc = "Vertical split" })
vim.keymap.set("n", "<leader>th", "<C-w>s", { noremap = true, desc = "Horizontal split" })
vim.keymap.set("n", "<C-h>", "<cmd>lua require'tmux'.move_left()<cr>")
vim.keymap.set("n", "<C-j>", "<cmd>lua require'tmux'.move_bottom()<cr>")
vim.keymap.set("n", "<C-k>", "<cmd>lua require'tmux'.move_top()<cr>")
vim.keymap.set("n", "<C-l>", "<cmd>lua require'tmux'.move_right()<cr>")

-- -----------------------------------------------------------------------------------------------
-- LSP
-- -----------------------------------------------------------------------------------------------
vim.lsp.enable({ "lua_ls", "ts_ls", "emmet_language_server" })

vim.lsp.config("lua_ls", {
	settings = {
		Lua = { workspace = { library = vim.api.nvim_get_runtime_file("", true) } },
	},
})

-- -----------------------------------------------------------------------------------------------
-- CMD
-- -----------------------------------------------------------------------------------------------
vim.cmd.colorscheme("solarized")
