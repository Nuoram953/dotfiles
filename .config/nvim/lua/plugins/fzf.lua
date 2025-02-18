return {
	"ibhagwan/fzf-lua",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		local fzf = require("fzf-lua")

		fzf.setup({
			"fzf-native",
			keymap = {
				fzf = {
					["ctrl-q"] = "select-all+accept",
				},
			},
			file = {
				fzf_opts = {
					["--ansi"] = true,
				},
			},
			grep = {
				rg_opts = "--hidden --line-number --multiline",
			},
			lsp = {
        includeDeclaration=false
			},
			defaults = {
				formatter = "path.filename_first",
				multiline = 1,
			},
			winopts = {
				preview = {
					layout = "vertical",
					vertical = "top:50%",
				},
				height = 0.75,
			},
			file_icons = true,
		})

		local function get_plugin_dirs()
			local plugin_dirs = {}

			local lazy_path = vim.fn.stdpath("data") .. "/lazy"
			if vim.fn.isdirectory(lazy_path) == 1 then
				for _, dir in ipairs(vim.fn.readdir(lazy_path)) do
					table.insert(plugin_dirs, lazy_path .. "/" .. dir)
				end
			end

			return plugin_dirs
		end

		local function plugin_file_picker(plugin_path)
			local files = vim.fn.systemlist("find " .. plugin_path .. " -type f")

			fzf.fzf_exec(files, {
				prompt = "Files> ",
				actions = {
					["default"] = function(selected)
						-- Open the selected file with proper path handling
						local selected_file = vim.fn.expand(selected[1])
						vim.cmd("edit " .. selected_file)
					end,
				},
			})
		end

		local function plugin_picker()
			local plugin_dirs = get_plugin_dirs()
			local plugin_names = {}

			for _, path in ipairs(plugin_dirs) do
				table.insert(plugin_names, vim.fn.fnamemodify(path, ":t"))
			end

			fzf.fzf_exec(plugin_names, {
				prompt = "Plugins> ",
				actions = {
					["default"] = function(selected)
						local selected_plugin = selected[1]
						for _, path in ipairs(plugin_dirs) do
							if vim.fn.fnamemodify(path, ":t") == selected_plugin then
								plugin_file_picker(path)
								break
							end
						end
					end,
				},
			})
		end

		fzf.plugins = plugin_picker
	end,
}
