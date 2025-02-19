-- Global shortcuts for indexing data.raw.
RAW = data.raw
RECIPE = RAW.recipe
ITEM = RAW.item
FLUID = RAW.fluid
TECH = RAW.technology
ASSEMBLER = RAW["assembling-machine"]
FURNACE = RAW.furnace

-- Global function aliases with some asserts.
---@generic T
---@param x T
---@return T
copy = function(x)
	assert(x ~= nil)
	assert(type(x) == "table")
	return table.deepcopy(x)
end
extend = function(x)
	assert(x ~= nil)
	assert(type(x) == "table")
	assert(#x > 0)
	for _, v in pairs(x) do
		assert(v ~= nil)
		assert(type(v) == "table")
	end
	data:extend(x)
end

-- Global constants.
SECONDS = 60
MINUTES = 60 * SECONDS
HOURS = 60 * MINUTES
ROCKET = 1e6