return { -- Telescope
-- Find, Filter, Preview, Pick. All lua, all the time.
{
    "ahmedkhalf/project.nvim",
    config = function(_)
        require("project_nvim").setup()

    require("nvim-tree").setup({
    sync_root_with_cwd = true,
    respect_buf_cwd = true,
    update_focused_file = {
        enable = true,
        update_root = true
    },
})require('telescope').load_extension('projects')
    end
}}
