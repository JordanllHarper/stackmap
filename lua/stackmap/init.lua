local M = {}
-- M.setup = function(opts)
-- 	print("Options: ", opts)
-- end

-- functions we need
-- - vim.keymap.set(...) -> create new keymaps
-- - nvim.keymap.get(...) -> create new keymaps

-- iterates through given maps (table)
-- if it finds one with the given lhs, return that mapping
local find_mapping = function(maps, lhs)
	-- pairs -> iterates over every key && order not guarateed
	-- ipairs -> iterates over ONLY numeric keys in a tables and && order IS guaranteed
	for _, this_table in ipairs(maps) do
		if this_table.lhs == lhs then
			return this_table
		end
	end
end

--[
-- Pushes user mappings onto the stack.
-- Mapping name : string - the name of the override - e.g. "debug_mode"
-- Mapping mode : string - the mode the user is in - e.g. "n" for normal mode
-- Given mappings : string - the mappings the user wants to push onto the stack - e.g. { [" sf"] = "echo 'print stack trace'"}
--]
M._stack = {}
M.push = function(new_mapping_stack_name, new_mapping_stack_mode, new_mappings)
	local existing_mappings = vim.api.nvim_get_keymap(new_mapping_stack_mode) -- get the keymaps from nvim
	local existing_maps = {}                                               -- initialise a table for saving existing maps
	for lhs, rhs in pairs(new_mappings) do                                 -- iterate through the given mappings to push
		local existing = find_mapping(existing_mappings, lhs)              -- try to find existing mappings
		if existing then
			--[
			-- If we find a mapping in the vim mappings...
			-- that matches the given mappings (a.k.a it is a valid mapping to add)
			-- Insert into table
			--]
			table.insert(existing_maps, existing)
		end
	end
	M._stack[new_mapping_stack_name] = existing_maps -- add the new mappings we want to get rid of
	for lhs, rhs in pairs(new_mappings) do
		-- TODO: Pass in options here!
		vim.keymap.set(new_mapping_stack_mode, lhs, rhs)
	end
end

M.pop = function(name)
	-- TODO: Implement
end

M.push("debug_mode", "n", {
	[" gf"] = "echo 'Hello'",
	[" gz"] = "echo 'Goodbye'"
})


return M
