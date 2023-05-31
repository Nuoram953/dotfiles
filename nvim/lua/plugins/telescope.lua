return { -- Telescope
-- Find, Filter, Preview, Pick. All lua, all the time.
{
    "nvim-telescope/telescope.nvim",
    dependencies = {"nvim-lua/plenary.nvim", {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make"
    }},
    config = function(_)
        require("telescope").setup()
    end
}}
