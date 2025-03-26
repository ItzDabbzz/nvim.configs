M = {}

function _G.dump(...)
    vim.print(...)
end

---The file system path separator for the current platform.
M.path_separator = "/"
M.is_windows = vim.fn.has("win32") == 1 or vim.fn.has("win32unix") == 1
if M.is_windows == true then
    M.path_separator = "\\"
end

---Split string into a table of strings using a separator.
---@param inputString string The string to split.
---@param sep string The separator to use.
---@return table table A table of strings.
M.split = function(inputString, sep)
    local fields = {}

    local pattern = string.format("([^%s]+)", sep)
    local _ = string.gsub(inputString, pattern, function(c)
        fields[#fields + 1] = c
    end)

    return fields
end

---Joins arbitrary number of paths together.
---@param ... string The paths to join.
---@return string
M.path_join = function(...)
        local args = { ... }
        if #args == 0 then
            return ""
        end

        local all_parts = {}
        if type(args[1]) == "string" and args[1]:sub(1, 1) == M.path_separator then
            all_parts[1] = ""
        end

        for _, arg in ipairs(args) do
            arg_parts = M.split(arg, M.path_separator)
            vim.list_extend(all_parts, arg_parts)
        end
        return table.concat(all_parts, M.path_separator)
    end

    - { "git", "rg", { "fd", "fdfind" }, "lazygit" }
M.check_if_cmd_exist = function(cmds)
    local result = {}
    for _, cmd in ipairs(cmds) do
        local name = type(cmd) == "string" and cmd or vim.inspect(cmd)
        local commands = type(cmd) == "string" and { cmd } or cmd
        ---@cast commands string[]
        local found = false
        for _, c in ipairs(commands) do
            if vim.fn.executable(c) == 1 then
                name = c
                found = true
            end
            result[name] = { found }
        end
    end
    return result
end

---@param editor_variable? {global: boolean}
---@param values? {[1]:any, [2]:any}
---@param option string
function M.toggle(option, editor_variable, values)
    if values then
        if not editor_variable then
            if vim.deep_equal(vim.opt_local[option]:get(), values[1]) then
                vim.opt_local[option] = values[2]
            else
                vim.opt_local[option] = values[1]
            end
            vim.notify(
                "set editor option "
                .. option
                .. " to "
                .. tostring(vim.opt_local[option]:get()),
                vim.log.levels.INFO,
                { title = "toggle editor option" }
            )
        else
            if not editor_variable.global then
                local bufnr = vim.api.nvim_get_current_buf()
                if vim.b[bufnr][option] == values[1] then
                    vim.b[bufnr][option] = values[2]
                else
                    --if option is unset or nil
                    vim.b[bufnr][option] = values[1]
                end
                --:h debug.getinfo() or lua_getinfo() to get information about a function
                vim.notify(
                    "set option "
                    .. option
                    .. " to "
                    .. tostring(vim.b[bufnr][option]),
                    vim.log.levels.INFO,
                    {
                        title = "toggle local option",
                    }
                )
            else
                if vim.g[option] == values[1] then
                    vim.g[option] = values[2]
                else
                    --if option is unset or nil
                    vim.g[option] = values[1]
                end
                vim.notify(
                    "set global option "
                    .. option
                    .. " to "
                    .. tostring(vim.g[option]),
                    vim.log.levels.INFO,
                    {
                        title = "toggle global option",
                    }
                )
            end
        end
    else
        if not editor_variable then
            vim.opt_local[option] = not vim.opt_local[option]:get()
            vim.notify(
                "set editor option "
                .. option
                .. " to "
                .. tostring(vim.opt_local[option]:get()),
                vim.log.levels.INFO,
                {
                    title = "toggle editor option",
                }
            )
        else
            if not editor_variable.global then
                local bufnr = vim.api.nvim_get_current_buf()
                vim.b[bufnr][option] = not vim.b[bufnr][option] and true
                    or false
                vim.notify(
                    "set option "
                    .. option
                    .. " to "
                    .. tostring(vim.b[bufnr][option]),
                    vim.log.levels.INFO,
                    {
                        title = "toggle local option",
                    }
                )
            else
                vim.g[option] = not vim.g[option]
                vim.notify(
                    "set global option "
                    .. option
                    .. " to "
                    .. tostring(vim.g[option]),
                    vim.log.levels.INFO,
                    {
                        title = "toggle global option",
                    }
                )
            end
        end
    end
end

return M
