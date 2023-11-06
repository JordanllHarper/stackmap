local find_map = function(maps, lhs)
	for _, map in ipairs(maps) do
		if map.lhs == lhs then
			return map
		end
	end
end

describe("stackmap", function()
	it("can be required", function()
		--[ Run test and Verify ]--
		require("stackmap")
	end)

	it("can push a single mapping", function()
		--[ Run test and Verify ]--
		local expected = "echo 'This is a test"
		require("stackmap").push("test1", "n", {
			asdfasdf = expected
		})


		local maps = vim.api.nvim_get_keymap('n')
		local found = find_map(maps, "asdfasdf")
		assert.are.same(expected, found.rhs)
	end)

	it("can push multiple mappings", function()
		--[ Run test and Verify ]--
		local expected = "echo 'This is a test"
		require("stackmap").push("test1", "n", {
			["asdf_1"] = expected .. "1",
			["asdf_2"] = expected .. "2"
		})


		local maps = vim.api.nvim_get_keymap('n')
		local found = find_map(maps, "asdf_1")
		assert.are.same(expected .. "1", found.rhs)
		local found2 = find_map(maps, "asdf_2")
		assert.are.same(expected .. "2", found2.rhs)
	end)
end)
