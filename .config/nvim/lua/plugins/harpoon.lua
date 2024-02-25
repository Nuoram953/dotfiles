return {
    'ThePrimeagen/harpoon',
    branch = 'harpoon2',
    dependencies = {
        'nvim-lua/plenary.nvim',
    },
    config = function()
        local harpoon = require("harpoon")
        harpoon:setup()

        vim.keymap.set("n", "<leader>ha", function() harpoon:list():append() end)
        vim.keymap.set("n", "<leader>hh", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)

        vim.keymap.set("n", "<leader>hi", function() harpoon:list():select(1) end)
        vim.keymap.set("n", "<leader>hj", function() harpoon:list():select(2) end)
        vim.keymap.set("n", "<leader>hk", function() harpoon:list():select(3) end)
        vim.keymap.set("n", "<leader>hl", function() harpoon:list():select(4) end)
        harpoon.settings = {
            save_on_toggle = false,
            sync_on_ui_close = false,
            key = function()
                local current_file = vim.fn.expand('%:p')
                local parent_directory = vim.fn.fnamemodify(current_file, ':h')
                return parent_directory
            end
        }
    end,
}
