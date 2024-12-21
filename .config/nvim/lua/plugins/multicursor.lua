return {
	"jake-stewart/multicursor.nvim",
	branch = "1.0",
	config = function()
		local mc = require("multicursor-nvim")

		mc.setup()

		vim.keymap.set({ "n", "v" }, "<up>", function()
			mc.addCursor("k")
		end)
		vim.keymap.set({ "n", "v" }, "<down>", function()
			mc.addCursor("j")
		end)

		vim.keymap.set({ "n", "v" }, "<c-n>", function()
			mc.addCursor("*")
		end)

		vim.keymap.set({ "n", "v" }, "<c-s>", function()
			mc.skipCursor("*")
		end)

		vim.keymap.set({ "n", "v" }, "<left>", mc.nextCursor)
		vim.keymap.set({ "n", "v" }, "<right>", mc.prevCursor)

		vim.keymap.set({ "n", "v" }, "<leader>x", mc.deleteCursor)

		vim.keymap.set("n", "<c-leftmouse>", mc.handleMouse)

		vim.keymap.set({ "n", "v" }, "<c-q>", function()
			if mc.cursorsEnabled() then
				mc.disableCursors()
			else
				mc.addCursor()
			end
		end)

		vim.keymap.set("n", "<esc>", function()
			if not mc.cursorsEnabled() then
				mc.enableCursors()
			else
				mc.clearCursors()

				vim.api.nvim_command("nohlsearch")
			end
		end)

		vim.keymap.set("n", "<leader>a", mc.alignCursors)

		vim.keymap.set("v", "S", mc.splitCursors)

		vim.keymap.set("v", "I", mc.insertVisual)
		vim.keymap.set("v", "A", mc.appendVisual)

		vim.keymap.set("v", "M", mc.matchCursors)

		vim.keymap.set("v", "<leader>t", function()
			mc.transposeCursors(1)
		end)
		vim.keymap.set("v", "<leader>T", function()
			mc.transposeCursors(-1)
		end)

		vim.api.nvim_set_hl(0, "MultiCursorCursor", { link = "Cursor" })
		vim.api.nvim_set_hl(0, "MultiCursorVisual", { link = "Visual" })
		vim.api.nvim_set_hl(0, "MultiCursorDisabledCursor", { link = "Visual" })
		vim.api.nvim_set_hl(0, "MultiCursorDisabledVisual", { link = "Visual" })
	end,
}
