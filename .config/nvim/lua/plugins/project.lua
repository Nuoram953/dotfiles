return { -- Telescope
    -- Find, Filter, Preview, Pick. All lua, all the time.
    {
        "ahmedkhalf/project.nvim",
        config = function(_)
            require("project_nvim").setup()


            require('telescope').load_extension('projects')
        end
    } }
