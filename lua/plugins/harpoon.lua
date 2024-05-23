return {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    config = function()
        local hp = require("harpoon")
        hp:setup()
        local keys = require("helpers.keys")
        keys.map("n", "<leader>ha", function ()
            hp:list():add()
        end)

        keys.map("n", "<leader>ht", function ()
            hp.ui:toggle_quick_menu(hp:list())
        end)

        for _, idx in ipairs {1, 2, 3, 4, 5 } do
            keys.map("n", string.format("<leader>h%d", idx), function ()
                hp:list():select(idx)
            end)
        end
    end
}