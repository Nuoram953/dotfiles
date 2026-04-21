vim.pack.add({
	"https://github.com/mfussenegger/nvim-dap",
	"https://github.com/igorlfs/nvim-dap-view",
})

local _dap_initialized = false
local function init_dap()
	if _dap_initialized then
		return
	end
	_dap_initialized = true
	local dap = require("dap")
	local dapui = require("dap-view")
	-- Point to vscode-js-debug
	local js_debug_path = vim.fn.expand("$HOME/vscode-js-debug/dist/src/dapDebugServer.js")
	-- Setup the adapter
	dap.adapters["pwa-node"] = {
		type = "server",
		host = "localhost",
		port = "${port}",
		executable = {
			command = "node",
			args = { js_debug_path, "${port}" },
		},
	}
	dap.adapters["node"] = function(cb, config)
		if config.type == "node" then
			config.type = "pwa-node"
		end
		local a = dap.adapters["pwa-node"]
		if type(a) == "function" then
			a(cb, config)
		else
			cb(a)
		end
	end
	local js_filetypes = { "typescript", "javascript", "typescriptreact", "javascriptreact" }
	for _, ft in ipairs(js_filetypes) do
		dap.configurations[ft] = {
			{
				type = "pwa-node",
				request = "attach",
				name = "Attach to Node.js",
				port = 9229,
				address = "localhost",
				localRoot = vim.fn.getcwd(),
				remoteRoot = "/usr/src/app",
				cwd = vim.fn.getcwd(),
				sourceMaps = true,
				protocol = "inspector",
			},
			{
				type = "pwa-node",
				request = "launch",
				name = "Debug Mocha Tests",
				program = "${workspaceFolder}/node_modules/mocha/bin/_mocha",
				args = {
					"--require",
					"ts-node/register/transpile-only",
					"--require",
					"source-map-support/register",
					"--reporter",
					"spec",
					"--colors",
					"${workspaceFolder}/tests/unit/**/*.[tj]s",
				},
				cwd = vim.fn.getcwd(),
				runtimeExecutable = "node",
				internalConsoleOptions = "openOnSessionStart",
				skipFiles = { "<node_internals>/**" },
				sourceMaps = true,
				protocol = "inspector",
			},
			{
				type = "pwa-node",
				request = "launch",
				name = "Debug Jest Tests",
				program = "${workspaceFolder}/node_modules/jest/bin/jest.js",
				args = { "--runInBand", "--no-cache", "${relativeFile}" },
				cwd = "${workspaceFolder}",
				runtimeExecutable = "node",
				console = "integratedTerminal",
				internalConsoleOptions = "neverOpen",
				sourceMaps = true,
				skipFiles = { "<node_internals>/**" },
			},
		}
	end
	dap.listeners.after.event_initialized["dapui_config"] = function()
		dapui.open()
	end
	dap.listeners.before.event_terminated["dapui_config"] = function()
		dapui.close()
	end
	dap.listeners.before.event_exited["dapui_config"] = function()
		dapui.close()
	end
	dap.listeners.before.disconnect["dapui_config"] = function()
		dapui.close()
	end
end
-- Keymaps
-- stylua: ignore start
vim.keymap.set("n", "<leader>db", function() init_dap(); require("dap").toggle_breakpoint() end, { desc = "Toggle Breakpoint" })
vim.keymap.set("n", "<leader>dB", function() init_dap(); require("dap").list_breakpoints(); vim.cmd("copen") end, { desc = "List Breakpoints" })
vim.keymap.set("n", "<leader>dc", function() init_dap(); require("dap").continue() end, { desc = "Run/Continue" })
vim.keymap.set("n", "<leader>dC", function() init_dap(); require("dap").run_to_cursor() end, { desc = "Run to Cursor" })
vim.keymap.set("n", "<leader>dg", function() init_dap(); require("dap").goto_() end, { desc = "Go to Line (No Execute)" })
vim.keymap.set("n", "<leader>di", function() init_dap(); require("dap").step_into() end, { desc = "Step Into" })
vim.keymap.set("n", "<leader>dj", function() init_dap(); require("dap").down() end, { desc = "Down" })
vim.keymap.set("n", "<leader>dk", function() init_dap(); require("dap").up() end, { desc = "Up" })
vim.keymap.set("n", "<leader>dl", function() init_dap(); require("dap").run_last() end, { desc = "Run Last" })
vim.keymap.set("n", "<leader>do", function() init_dap(); require("dap").step_out() end, { desc = "Step Out" })
vim.keymap.set("n", "<leader>dO", function() init_dap(); require("dap").step_over() end, { desc = "Step Over" })
vim.keymap.set("n", "<leader>dP", function() init_dap(); require("dap").pause() end, { desc = "Pause" })
vim.keymap.set("n", "<leader>dr", function() init_dap(); require("dap").repl.toggle() end, { desc = "Toggle REPL" })
vim.keymap.set("n", "<leader>ds", function() init_dap(); require("dap").session() end, { desc = "Session" })
vim.keymap.set("n", "<leader>dt", function()
	init_dap()
	require("dap").terminate()
	vim.defer_fn(function()
		require("dap-view").close()
	end, 100)
end, { desc = "Terminate" })
vim.keymap.set("n", "<leader>dw", function() init_dap(); require("dap.ui.widgets").hover() end, { desc = "DAP Widgets" })
vim.keymap.set("n", "<leader>du", function() init_dap(); require("dap-view").toggle() end, { desc = "Dap UI" })
-- stylua: ignore end
