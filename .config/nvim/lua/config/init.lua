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

require("lazy").setup("plugins", {
	install = { colorscheme = { "tokyonight" } },
	defaults = { lazy = false },
	ui = {
		border = "rounded",
	},
	checker = { enabled = true },
	debug = false,
    performance = {
        cache = {
            enabled = true
        }
    }
})
