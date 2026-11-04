vim.pack.add({
	"https://github.com/folke/snacks.nvim",
	"https://github.com/nvim-tree/nvim-web-devicons",
})

local Snacks = require("snacks")

--------------------------------------------------------------------------------
-- Custom File Manipulation Actions for Snacks Picker
--------------------------------------------------------------------------------
local function file_create(picker)
	local item = picker:current()
	local path = item and Snacks.picker.util.path(item)
	local base_dir
	if path then
		base_dir = vim.fn.isdirectory(path) == 1 and path or vim.fs.dirname(path)
	else
		base_dir = picker:cwd()
	end
	base_dir = vim.fs.normalize(base_dir)

	local cwd = vim.fs.normalize(picker:cwd())
	local rel_dir
	if base_dir == cwd then
		rel_dir = "./"
	elseif base_dir:sub(1, #cwd + 1) == cwd .. "/" then
		rel_dir = base_dir:sub(#cwd + 2) .. "/"
	else
		rel_dir = vim.fn.fnamemodify(base_dir, ":~:.") .. "/"
	end

	Snacks.input({
		prompt = "Create file in " .. rel_dir .. ": ",
	}, function(value)
		if not value or value:match("^%s*$") then
			return
		end

		local full_path
		if value:sub(1, 1) == "/" then
			full_path = vim.fs.normalize(value)
		elseif value:sub(1, 2) == "~/" or value == "~" then
			full_path = vim.fs.normalize(vim.fn.expand(value))
		elseif value:sub(1, 2) == "./" then
			full_path = vim.fs.normalize(cwd .. "/" .. value:sub(3))
		else
			full_path = vim.fs.normalize(base_dir .. "/" .. value)
		end

		local is_dir = value:sub(-1) == "/"
		if is_dir then
			vim.fn.mkdir(full_path, "p")
			Snacks.notify.info("Created directory: " .. vim.fn.fnamemodify(full_path, ":~:."))
			picker:refresh()
			return
		end

		local parent = vim.fs.dirname(full_path)
		if vim.fn.isdirectory(parent) == 0 then
			vim.fn.mkdir(parent, "p")
		end

		if vim.uv.fs_stat(full_path) then
			Snacks.notify.warn("File already exists, opening: " .. vim.fn.fnamemodify(full_path, ":~:."))
		else
			local fd = io.open(full_path, "w")
			if fd then
				fd:close()
				Snacks.notify.info("Created file: " .. vim.fn.fnamemodify(full_path, ":~:."))
			else
				Snacks.notify.error("Failed to create file: " .. full_path)
				return
			end
		end

		picker:close()
		vim.schedule(function()
			vim.cmd.edit(vim.fn.fnameescape(full_path))
		end)
	end)
end

local function file_rename(picker)
	local item = picker:current()
	if not item then
		Snacks.notify.warn("No file selected to rename")
		return
	end
	local path = Snacks.picker.util.path(item)
	if not path or not vim.uv.fs_stat(path) then
		Snacks.notify.warn("Selected item is not a valid file on disk")
		return
	end

	Snacks.rename.rename_file({
		from = path,
		on_rename = function(_, _, ok)
			if ok then
				picker:refresh()
			end
		end,
	})
end

local function trash_or_delete(path)
	local ok_trash = false
	if vim.fn.executable("gio") == 1 then
		vim.fn.system({ "gio", "trash", path })
		if vim.v.shell_error == 0 then
			ok_trash = true
		end
	elseif vim.fn.executable("trash") == 1 then
		vim.fn.system({ "trash", path })
		if vim.v.shell_error == 0 then
			ok_trash = true
		end
	end

	if ok_trash then
		return true, "trashed"
	end

	local ok, ret = pcall(vim.fn.delete, path, "rf")
	if ok and ret == 0 then
		return true, "deleted"
	end
	return false, type(ret) == "string" and ret or "Failed to delete"
end

local function file_delete(picker)
	local items = picker:selected({ fallback = true })
	local paths = {}
	for _, it in ipairs(items) do
		local p = Snacks.picker.util.path(it)
		if p and vim.uv.fs_stat(p) then
			table.insert(paths, p)
		end
	end

	if #paths == 0 then
		Snacks.notify.warn("No valid file selected to delete")
		return
	end

	local prompt
	if #paths == 1 then
		prompt = "Delete " .. vim.fn.fnamemodify(paths[1], ":~:.") .. "?"
	else
		prompt = ("Delete %d selected files?"):format(#paths)
	end

	Snacks.picker.util.confirm(prompt, function()
		local count = 0
		for _, path in ipairs(paths) do
			local ok, err = trash_or_delete(path)
			if ok then
				count = count + 1
				local buf = vim.fn.bufnr(path)
				if buf ~= -1 and vim.api.nvim_buf_is_valid(buf) then
					Snacks.bufdelete.delete({ buf = buf, force = true, wipe = true })
				end
			else
				Snacks.notify.error("Failed to delete " .. path .. ": " .. tostring(err))
			end
		end
		if count > 0 then
			Snacks.notify.info(("Deleted %d file(s)"):format(count))
		end
		picker:refresh()
	end)
end

local function file_copy(picker)
	local item = picker:current()
	local path = item and Snacks.picker.util.path(item)
	if not path or not vim.uv.fs_stat(path) then
		Snacks.notify.warn("No valid file selected to copy")
		return
	end

	local dir = vim.fn.isdirectory(path) == 1 and path or vim.fs.dirname(path)
	local old_name = vim.fn.fnamemodify(path, ":t")

	Snacks.input({
		prompt = "Duplicate/copy file: ",
		default = old_name,
	}, function(value)
		if not value or value:match("^%s*$") or value == old_name then
			return
		end

		local to = vim.fs.normalize(dir .. "/" .. value)
		if vim.uv.fs_stat(to) then
			Snacks.notify.warn("File already exists: " .. to)
			return
		end

		local parent = vim.fs.dirname(to)
		if vim.fn.isdirectory(parent) == 0 then
			vim.fn.mkdir(parent, "p")
		end

		Snacks.picker.util.copy_path(path, to)
		Snacks.notify.info("Copied to: " .. vim.fn.fnamemodify(to, ":~:."))
		picker:refresh()
	end)
end

local function yank_relpath(picker, item)
	local path = item and Snacks.picker.util.path(item)
	if path then
		local rel = vim.fn.fnamemodify(path, ":~:.")
		vim.fn.setreg("+", rel)
		vim.fn.setreg('"', rel)
		Snacks.notify.info("Copied relative path: " .. rel)
	end
end

Snacks.setup({
	animate = { enabled = true },
	bigfile = { enabled = true },
	dashboard = {
		enabled = true,
		sections = {
			-- {
			-- 	section = "terminal",
			-- 	cmd = "chafa ~/dotfiles/wallpapers/metroid.png; sleep .1",
			-- 	height = 25,
			-- 	padding = 1,
			-- },
			{ section = "keys", gap = 1, padding = 1 },
		},
	},
	dim = { enabled = true },
	explorer = { enabled = true, replace_netrw = true },
	image = { enabled = true },
	indent = { enabled = true },
	input = { enabled = true },
	layout = { enabled = true },
	notifier = { enabled = true },
	quickfile = { enabled = true },
	scope = { enabled = true },
	scratch = { enabled = true },
	scroll = { enabled = true },
	statuscolumn = { enabled = true },
	terminal = { enabled = true },
	toggle = { enabled = true },
	words = { enabled = false },
	zen = { enabled = true },
	picker = {
		actions = {
			file_create = { action = file_create, desc = "Create file next to current" },
			file_rename = { action = file_rename, desc = "Rename file" },
			file_delete = { action = file_delete, desc = "Delete file" },
			file_copy = { action = file_copy, desc = "Duplicate/copy file" },
			yank_relpath = { action = yank_relpath, desc = "Copy relative path" },
			yazi_copy_relative_path = "yank_relpath",
		},
		win = {
			input = {
				keys = {
					["<a-c>"] = { "file_create", mode = { "n", "i" }, desc = "Create file next to current" },
					["<a-a>"] = { "file_create", mode = { "n", "i" }, desc = "Create file next to current" },
					["<a-r>"] = { "file_rename", mode = { "n", "i" }, desc = "Rename file" },
					["<a-d>"] = { "file_delete", mode = { "n", "i" }, desc = "Delete file" },
					["<a-y>"] = { "file_copy", mode = { "n", "i" }, desc = "Duplicate file" },
				},
			},
			list = {
				keys = {
					["a"] = "file_create",
					["c"] = "file_copy",
					["r"] = "file_rename",
					["d"] = "file_delete",
					["y"] = "yank_relpath",
				},
			},
		},
		sources = {
			lsp_symbols = {
				filter = { default = true },
			},
			files = {
				hidden = true,
				ignored = true,
				win = {
					input = {
						keys = {
							["<S-h>"] = "toggle_hidden",
							["<S-i>"] = "toggle_ignored",
							["<S-f>"] = "toggle_follow",
							["<C-y>"] = { "yazi_copy_relative_path", mode = { "n", "i" } },
						},
					},
				},
				exclude = {
					"**/.git/*",
					"**/node_modules/*",
					"**/.yarn/cache/*",
					"**/.yarn/install*",
					"**/.yarn/releases/*",
					"**/.pnpm-store/*",
					"**/.idea/*",
					"**/.DS_Store",
					"build/*",
					"coverage/*",
					"dist/*",
					"hodor-types/*",
					"**/target/*",
					"**/public/*",
					"**/digest*.txt",
					"**/.node-gyp/**",
					"**/dist/**",
					"**/.venv/*",
				},
			},
			grep = {
				hidden = true,
				ignored = true,
				win = {
					input = {
						keys = {
							["<S-h>"] = "toggle_hidden",
							["<S-i>"] = "toggle_ignored",
							["<S-f>"] = "toggle_follow",
						},
					},
				},
				exclude = {
					"**/.git/*",
					"**/node_modules/*",
					"**/.yarn/cache/*",
					"**/.yarn/install*",
					"**/.yarn/releases/*",
					"**/.pnpm-store/*",
					"**/.venv/*",
					"**/.idea/*",
					"**/.DS_Store",
					"**/yarn.lock",
					"build*/*",
					"coverage/*",
					"dist/*",
					"certificates/*",
					"hodor-types/*",
					"**/target/*",
					"**/public/*",
					"**/digest*.txt",
					"**/.node-gyp/**",
				},
			},
			grep_buffers = {},
			explorer = {
				hidden = true,
				ignored = true,
				supports_live = true,
				auto_close = true,
				diagnostics = true,
				diagnostics_open = false,
				focus = "list",
				follow_file = true,
				git_status = true,
				git_status_open = false,
				git_untracked = true,
				jump = { close = true },
				tree = true,
				watch = true,
				exclude = {
					".git",
					".pnpm-store",
					".venv",
					".DS_Store",
					"**/.node-gyp/**",
				},
			},
		},
	},
})

vim.api.nvim_create_autocmd("User", {
	pattern = "VeryLazy",
	callback = function()
		Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>us")
		Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
		Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>uL")
		Snacks.toggle.diagnostics():map("<leader>ud")
		Snacks.toggle.line_number():map("<leader>ul")
		Snacks.toggle
			.option(
				"conceallevel",
				{ off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2, name = "Conceal Level" }
			)
			:map("<leader>uc")
		Snacks.toggle
			.option("showtabline", { off = 0, on = vim.o.showtabline > 0 and vim.o.showtabline or 2, name = "Tabline" })
			:map("<leader>uA")
		Snacks.toggle.treesitter():map("<leader>uT")
		Snacks.toggle.option("background", { off = "light", on = "dark", name = "Dark Background" }):map("<leader>ub")
		Snacks.toggle.dim():map("<leader>uD")
		Snacks.toggle.animate():map("<leader>ua")
		Snacks.toggle.indent():map("<leader>ug")
		Snacks.toggle.scroll():map("<leader>uS")
		Snacks.toggle.profiler():map("<leader>dpp")
		Snacks.toggle.profiler_highlights():map("<leader>dph")
		Snacks.toggle.zoom():map("<leader>wm"):map("<leader>uZ")
		Snacks.toggle.zen():map("<leader>uz")
	end,
})
-- stylua: ignore start
local keymaps = {
    { "<leader>l", function() vim.cmd("Lazy") end, desc = "Open Lazy tab", },
    { "<leader><space>", function() Snacks.picker.smart() end, desc = "Smart Find Files" },
    { "<leader>/", function() Snacks.picker.grep() end, desc = "Grep" },
    { "<leader>:", function() Snacks.picker.command_history() end, desc = "Command History" },
    { "<leader>n", function() Snacks.picker.notifications() end, desc = "Notification History" },
    { "<leader>e", function() Snacks.explorer() end, desc = "File Explorer" },
    {
      "<leader>,", function()
        Snacks.picker.buffers({
          win = {
            input = {
              keys = {
                ["dd"] = "bufdelete",
                ["<c-d>"] = { "bufdelete", mode = { "n", "i" } },
              },
            },
            list = { keys = { ["dd"] = "bufdelete" } },
          },
        })
      end, desc = "Buffers",
    },
    -- find
    { "<leader>fb", function() Snacks.picker.buffers() end, desc = "Buffers" },
    { "<leader>fc", function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end, desc = "Find Config File" },
    { "<leader>ff", function() Snacks.picker.files() end, desc = "Find Files" },
    { "<leader>fF", function() Snacks.picker.files({ cwd = vim.fn.expand("~")}) end, desc = "Find note File" },
    { "<leader>fg", function() Snacks.picker.git_files() end, desc = "Find Git Files" },
    { "<leader>fp", function() Snacks.picker.projects() end, desc = "Projects" },
    { "<leader>fr", function() Snacks.picker.recent() end, desc = "Recent" },
    { "<leader>fn", function() Snacks.picker.files({ cwd = vim.fn.expand("~/notes")}) end, desc = "Find note File" },

    -- git
    { "<leader>lg", function() Snacks.lazygit() end, desc = "Lazygit" },
    { "<leader>gb", function() Snacks.picker.git_branches() end, desc = "Git Branches" },
    { "<leader>gl", function() Snacks.picker.git_log() end, desc = "Git Log" },
    { "<leader>gL", function() Snacks.picker.git_log_line() end, desc = "Git Log Line" },
    { "<leader>gs", function() Snacks.picker.git_status() end, desc = "Git Status" },
    { "<leader>gS", function() Snacks.picker.git_stash() end, desc = "Git Stash" },
    { "<leader>gp", function() Snacks.picker.git_diff() end, desc = "Git Diff Picker (Hunks)" },
    { "<leader>gP", function() Snacks.picker.git_diff({ base = "origin" }) end, desc = "Git Diff Picker(origin)" },
    { "<leader>gf", function() Snacks.picker.git_log_file() end, desc = "Git Log File" },
    -- Grep
    { "<leader>sb", function() Snacks.picker.lines() end, desc = "Buffer Lines" },
    { "<leader>sB", function() Snacks.picker.grep_buffers() end, desc = "Grep Open Buffers" },
    { "<leader>sg", function() Snacks.picker.grep() end, desc = "Grep" },
    { "<leader>sw", function() Snacks.picker.grep_word() end, desc = "Visual selection or word", mode = { "n", "x" } },
    -- search
    { '<leader>s"', function() Snacks.picker.registers() end, desc = "Registers" },
    { '<leader>s/', function() Snacks.picker.search_history() end, desc = "Search History" },
    { "<leader>sa", function() Snacks.picker.autocmds() end, desc = "Autocmds" },
    { "<leader>sb", function() Snacks.picker.lines() end, desc = "Buffer Lines" },
    { "<leader>sc", function() Snacks.picker.command_history() end, desc = "Command History" },
    { "<leader>sC", function() Snacks.picker.commands() end, desc = "Commands" },
    { "<leader>sd", function() Snacks.picker.diagnostics() end, desc = "Diagnostics" },
    { "<leader>sD", function() Snacks.picker.diagnostics_buffer() end, desc = "Buffer Diagnostics" },
    { "<leader>sH", function() Snacks.picker.highlights() end, desc = "Highlights" },
    { "<leader>si", function() Snacks.picker.icons() end, desc = "Icons" },
    { "<leader>sj", function() Snacks.picker.jumps() end, desc = "Jumps" },
    { "<leader>sk", function() Snacks.picker.keymaps() end, desc = "Keymaps" },
    { "<leader>sl", function() Snacks.picker.loclist() end, desc = "Location List" },
    { "<leader>sm", function() Snacks.picker.marks() end, desc = "Marks" },
    { "<leader>sM", function() Snacks.picker.man() end, desc = "Man Pages" },
    { "<leader>sp", function() Snacks.picker.lazy() end, desc = "Search for Plugin Spec" },
    { "<leader>sq", function() Snacks.picker.qflist() end, desc = "Quickfix List" },
    { "<leader>sR", function() Snacks.picker.resume() end, desc = "Resume" },
    { "<leader>su", function() Snacks.picker.undo() end, desc = "Undo History" },
    { "<leader>uC", function() Snacks.picker.colorschemes() end, desc = "Colorschemes" },
    -- LSP
    { "gd", function() Snacks.picker.lsp_definitions() end, desc = "Goto Definition" },
    { "gD", function() Snacks.picker.lsp_declarations() end, desc = "Goto Declaration" },
    { "gr", function() Snacks.picker.lsp_references() end, nowait = true, desc = "References" },
    { "gI", function() Snacks.picker.lsp_implementations() end, desc = "Goto Implementation" },
    { "gy", function() Snacks.picker.lsp_type_definitions() end, desc = "Goto T[y]pe Definition" },
    { "<leader>ss", function() Snacks.picker.lsp_symbols() end, desc = "LSP Symbols" },
    { "<leader>sS", function() Snacks.picker.lsp_workspace_symbols() end, desc = "LSP Workspace Symbols" },
    { "gai", function() Snacks.picker.lsp_incoming_calls() end, desc = "C[a]lls Incoming", has = "callHierarchy/incomingCalls" },
    { "gao", function() Snacks.picker.lsp_outgoing_calls() end, desc = "C[a]lls Outgoing", has = "callHierarchy/outgoingCalls" },
    -- buffers
    { "<leader>bd", function() Snacks.bufdelete() end, desc = "Delete buffer", mode = { "n" }, },
    { "<leader>bo", function() Snacks.bufdelete.other() end, desc = "Delete other buffers", mode = { "n" }, },
    -- terminal
    { "<leader>fT", function() Snacks.terminal() end, desc = "Terminal (cwd)", mode = "n", },
    { "<leader>ft", function() Snacks.terminal(nil, { cwd = vim.fn.getcwd() }) end, desc = "Terminal (Root Dir)",  mode = "n", },
    { "<c-:>",  function() Snacks.terminal(nil, { cwd = vim.fn.getcwd() }) end, desc = "Terminal (Root Dir)", mode = "n", },
    { "<c-/>",      function() Snacks.terminal() end, desc = "Toggle Terminal" },
    { "<c-_>", function() Snacks.terminal(nil, { cwd = vim.fn.getcwd() }) end, desc = "which_key_ignore",  mode = "n", },
    -- Other
    { "<leader>z",  function() Snacks.zen() end, desc = "Toggle Zen Mode" },
    { "<leader>Z",  function() Snacks.zen.zoom() end, desc = "Toggle Zoom" },
    { "<leader>.",  function() Snacks.scratch() end, desc = "Toggle Scratch Buffer" },
    { "<leader>S",  function() Snacks.scratch.select() end, desc = "Select Scratch Buffer" },
    { "<leader>n",  function() Snacks.notifier.show_history() end, desc = "Notification History" },
    { "<leader>bd", function() Snacks.bufdelete() end, desc = "Delete Buffer" },
    { "<leader>cR", function() Snacks.rename.rename_file() end, desc = "Rename File" },
    { "<leader>gB", function() Snacks.gitbrowse() end, desc = "Git Browse", mode = { "n", "v" } },
    { "<leader>un", function() Snacks.notifier.hide() end, desc = "Dismiss All Notifications" },
    { "<c-_>",      function() Snacks.terminal() end, desc = "which_key_ignore" },
    { "]]",         function() Snacks.words.jump(vim.v.count1) end, desc = "Next Reference", mode = { "n", "t" } },
    { "[[",         function() Snacks.words.jump(-vim.v.count1) end, desc = "Prev Reference", mode = { "n", "t" } },
    {
      "<leader>N",
      desc = "Neovim News",
      function()
        Snacks.win({
          file = vim.api.nvim_get_runtime_file("doc/news.txt", false)[1],
          width = 0.6,
          height = 0.6,
          wo = {
            spell = false,
            wrap = false,
            signcolumn = "yes",
            statuscolumn = " ",
            conceallevel = 3,
          },
        })
      end,
    }
}
-- stylua: ignore end
for _, map in ipairs(keymaps) do
	local opts = { desc = map.desc }
	if map.silent ~= nil then
		opts.silent = map.silent
	end
	if map.noremap ~= nil then
		opts.noremap = map.noremap
	else
		opts.noremap = true
	end
	if map.expr ~= nil then
		opts.expr = map.expr
	end
	local mode = map.mode or "n"
	vim.keymap.set(mode, map[1], map[2], opts)
end
