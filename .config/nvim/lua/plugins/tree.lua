return { -- File explore
	-- nvim-tree.lua - A file explorer tree for neovim written in lua
	{
		"nvim-tree/nvim-tree.lua",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
			lazy = true,
			opt = true,
		},
		config = function(_)
			require("nvim-tree").setup({
				sync_root_with_cwd = true,
				respect_buf_cwd = true,
				update_focused_file = {
					enable = true,
					update_root = true,
				},
				sort_by = "case_sensitive",
				view = {
					adaptive_size = true,
					centralize_selection = true,
					width = 50,
					hide_root_folder = false,
					side = "left",
					preserve_window_proportions = false,
					number = false,
					relativenumber = false,
					signcolumn = "yes",
					float = {
						enable = false,
						quit_on_focus_loss = true,
						open_win_config = {
							relative = "editor",
							border = "rounded",
							width = 30,
							height = 30,
							row = 1,
							col = 1,
						},
					},
				},
				renderer = {
					add_trailing = false,
					group_empty = false,
					highlight_git = true,
					full_name = false,
					highlight_opened_files = "none",
					root_folder_label = ":t",
					indent_width = 2,
					indent_markers = {
						enable = true,
						inline_arrows = true,
						icons = {
							corner = "└",
							edge = "│",
							item = "│",
							none = " ",
						},
					},
				},
				filters = {
					dotfiles = false,
				},
			})
		end,
	},
}
