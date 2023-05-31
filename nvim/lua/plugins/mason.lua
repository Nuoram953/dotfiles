return {
{
    "williamboman/mason.nvim",
    build = ":MasonUpdate",
    config = function(_)
        require("mason").setup()
    end
}
}
