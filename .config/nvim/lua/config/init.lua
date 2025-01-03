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

vim.g.mapleader = " "
vim.opt.termguicolors = true -- enable 24-bit RGB colors

vim.cmd("autocmd ColorScheme dracula highlight DiffChange guifg=#000000 guibg=#f1fa8c")
vim.cmd("autocmd ColorScheme dracula highlight DiffText guifg=#000000 guibg=#f1fa8c")

require("lazy").setup({
	spec = {
		{ import = "plugins" },
		{ import = "plugins.dap" },
	},
	dev = {
		path = "~/projects/nvim-plugins",
	},
	install = { colorscheme = { "dracula" } },
	defaults = { lazy = false },
	ui = {
		border = "rounded",
	},
	checker = { enabled = false },
	debug = false,
	performance = {
		cache = {
			enabled = true,
		},
	},
})
