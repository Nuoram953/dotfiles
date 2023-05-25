return {

    -- file explorer
    {
        "nvim-tree/nvim-tree.lua",
        config = function(_, opts)
            require("nvim-tree").setup()
   	 end,
    },

    {
        "nvim-telescope/telescope.nvim",
        dependencies = { 'nvim-lua/plenary.nvim' },
        cmd = "Telescope",
        version = false, 
    },

}
