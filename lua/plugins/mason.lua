return {
    'williamboman/mason.nvim',
    build = function()
      pcall(function()
        require("mason-registry").refresh()
      end)
    end,
    event = "User FileOpened",
    lazy = true,
    config = true,
}