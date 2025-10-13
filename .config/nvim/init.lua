-- -----------------------------------------------------------------------------------------------
-- GENERAL CONFIGURATION
-- -----------------------------------------------------------------------------------------------
vim.g.mapleader = " "

vim.o.complete = ".,o" -- use buffer and omnifunc
vim.o.completeopt = "fuzzy,menuone,noselect" -- add 'popup' for docs (sometimes)
vim.o.autocomplete = true
vim.o.pumheight = 7

-- Search
vim.opt.hlsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.wildmenu = true

vim.o.signcolumn = "yes"
vim.o.winborder = "rounded"

-- Indention
vim.opt.autoindent = true -- auto indentation
vim.opt.expandtab = true -- convert tabs to spaces
vim.opt.shiftwidth = 2 -- the number of spaces inserted for each indentation
vim.opt.smartindent = true -- make indenting smarter
vim.opt.softtabstop = 2 -- when hitting <BS>, pretend like a tab is removed, even if spaces
vim.opt.tabstop = 2 -- insert 2 spaces for a tab
vim.opt.shiftround = true -- use multiple of shiftwidth when indenting with "<" and ">"

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
})

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
-- -----------------------------------------------------------------------------------------------
-- KEYMAPS
-- -----------------------------------------------------------------------------------------------
vim.keymap.set("n", "<leader>w", ":w<CR>")
vim.keymap.set("n", "<leader>q", ":q<CR>")
vim.keymap.set({ "n", "x" }, "<leader>fo", function()
	require("conform").format({ lsp_fallback = true, async = true })
end, { desc = "Format file or range (in visual mode)" })

vim.keymap.set({ "n", "x" }, "<leader><leader>", "<cmd>FzfLua<cr>", { silent = true })
vim.keymap.set("n", "<c-t>", "<cmd>FzfLua files<cr>", { silent = true })

vim.keymap.set("n", "<C-h>", "<cmd>lua require'tmux'.move_left()<cr>", { desc = "Go to left window" })
vim.keymap.set("n", "<C-j>", "<cmd>lua require'tmux'.move_bottom()<cr>", { desc = "Go to lower window" })
vim.keymap.set("n", "<C-k>", "<cmd>lua require'tmux'.move_top()<cr>", { desc = "Go to upper window" })
vim.keymap.set("n", "<C-l>", "<cmd>lua require'tmux'.move_right()<cr>", { desc = "Go to right window" })

-- -----------------------------------------------------------------------------------------------
-- LSP
-- -----------------------------------------------------------------------------------------------
vim.lsp.enable({ "lua_ls", "ts_ls" })

vim.lsp.config("lua_ls", {
	settings = {
		Lua = { workspace = { library = vim.api.nvim_get_runtime_file("", true) } },
	},
})

-- -----------------------------------------------------------------------------------------------
-- CMD
-- -----------------------------------------------------------------------------------------------
vim.cmd.colorscheme("solarized")

vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(ev)
		vim.lsp.completion.enable(true, ev.data.client_id, ev.buf, {
			convert = function(item)
				local abbr = item.label
				abbr = abbr:gsub("%b()", ""):gsub("%b{}", "")
				abbr = abbr:match("[%w_.]+.*") or abbr
				abbr = #abbr > 15 and abbr:sub(1, 14) .. "…" or abbr

				local menu = item.detail or ""
				menu = #menu > 15 and menu:sub(1, 14) .. "…" or menu

				return { abbr = abbr, menu = menu }
			end,
		})
	end,
})
