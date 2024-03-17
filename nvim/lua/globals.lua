---------------------------------------------------------
-- Usefull global functions for plugin development
---------------------------------------------------------

-- Prints the table passed in
P = function(v)
	print(vim.inspect(v))
	return v
end

RELOAD = function(...)
	return require("plenary.reload").reload_module(...)
end

-- Reloads a module and requires it
R = function(name)
  print("Module reloaded: [{" .. name.. "}]")
	RELOAD(name)
	return require(name)
end


-- autocommands
local vim = vim
local api = vim.api
M = {}
-- function to create a list of commands and convert them to autocommands
-------- This function is taken from https://github.com/norcalli/nvim_utils
function M.nvim_create_augroups(definitions)
    for group_name, definition in pairs(definitions) do
        api.nvim_command('augroup '..group_name)
        api.nvim_command('autocmd!')
        for _, def in ipairs(definition) do
            local command = table.concat(vim.tbl_flatten{'autocmd', def}, ' ')
            api.nvim_command(command)
        end
        api.nvim_command('augroup END')
    end
end
