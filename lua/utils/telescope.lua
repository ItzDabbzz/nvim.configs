local M = {}

M.load_extension_after_telescope_is_loaded = function(extension_name)
  local lazy_cfg = require("lazy.core.config").plugins
  if lazy_cfg["telescope.nvim"] and lazy_cfg["telescope.nvim"]._.loaded then
    -- Since Telescope is loaded, just load the extension:
    require("telescope").load_extension(extension_name)
  else
    -- If Telescope is not loaded, create an autocmd that will load the
    -- extension after Telescope is loaded.
    vim.api.nvim_create_autocmd("User", {
      pattern = "LazyLoad",
      callback = function(event)
        if event.data == "telescope.nvim" then
          require("telescope").load_extension(extension_name)
          return true
        end
      end,
    })
  end
end

return M
