return {
	"folke/noice.nvim",
	event = "VeryLazy",
	opts = {
		lsp = {
			override = {
				["vim.lsp.util.convert_input_to_markdown_lines"] = true,
				["vim.lsp.util.stylize_markdown"] = true,
				["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
			},
		},
		popupmenu = {
			enabled = true, -- enables the Noice popupmenu UI
			---@type 'nui'|'cmp'
			backend = "nui", -- backend to use to show regular cmdline completions
			-- Icons for completion item kinds (see defaults at noice.config.icons.kinds)
			kind_icons = {}, -- set to `false` to disable icons
		},
	},
	dependencies = {
		"MunifTanjim/nui.nvim",
		"rcarriga/nvim-notify",
	},
}
