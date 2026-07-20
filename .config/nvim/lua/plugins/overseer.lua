vim.pack.add({
	"https://github.com/stevearc/overseer.nvim",
})

require("overseer").setup()

local keymaps = {
	{
		"<leader>ot",
		function()
			vim.cmd("OverseerToggle")
		end,
	},
	{
		"<leader>or",
		function()
			vim.cmd("OverseerRun")
		end,
	},
	{
		"<leader>orr",
		function()
			vim.cmd("OverseerRestartLast")
		end,
	},
}

vim.api.nvim_create_user_command("OverseerRestartLast", function()
	local overseer = require("overseer")
	local task_list = require("overseer.task_list")
	local tasks = overseer.list_tasks({
		status = {
			overseer.STATUS.SUCCESS,
			overseer.STATUS.FAILURE,
			overseer.STATUS.CANCELED,
		},
		sort = task_list.sort_finished_recently,
	})
	if vim.tbl_isempty(tasks) then
		vim.notify("No tasks found", vim.log.levels.WARN)
	else
		local most_recent = tasks[1]
		overseer.run_action(most_recent, "restart")
	end
end, {})

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
