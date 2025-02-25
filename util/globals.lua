-- Global shortcuts for indexing data.raw.
RAW = data.raw
RECIPE = RAW.recipe
ITEM = RAW.item
MODULE = RAW.module
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
FLUID_PER_BARREL = 50 -- 50 fluid units per barrel, from vanilla.
	-- That number also applies to gas tanks. Considered having it higher, but doesn't really make sense realistically, and gas tanks aren't more expensive than barrels. Also note currently filled gas tanks are also named "[something]-barrel".
