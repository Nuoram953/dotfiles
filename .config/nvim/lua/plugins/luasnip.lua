local M = {
    "L3MON4D3/LuaSnip",
    dependencies = {
        "rafamadriz/friendly-snippets",
        config = function()
            require("luasnip.loaders.from_vscode").lazy_load {paths={"~/dotfiles/.config/nvim/lua/snippets"}}
        end,
    },
    config = true,
}

return M
