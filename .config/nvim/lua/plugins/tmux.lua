vim.pack.add({
	"https://github.com/aserowy/tmux.nvim",
})

require("tmux").setup({
	copy_sync = {
		enable = true,
		sync_clipboard = false,
		sync_registers = true,
	},
})

vim.keymap.set("n", "<C-h>", "<cmd>lua require'tmux'.move_left()<cr>", { remap = true })
vim.keymap.set("n", "<C-j>", "<cmd>lua require'tmux'.move_bottom()<cr>", { remap = true })
vim.keymap.set("n", "<C-k>", "<cmd>lua require'tmux'.move_top()<cr>", { remap = true })
vim.keymap.set("n", "<C-l>", "<cmd>lua require'tmux'.move_right()<cr>", { remap = true })
