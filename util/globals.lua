-- Global function aliases with some asserts.
---@generic T
---@param x T
---@return T
copy = function(x)
	assert(x ~= nil)
	assert(type(x) == "table")
	return table.deepcopy(x)
end

---@param x data.Prototype[]
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
FLUID_PER_BARREL = 100 -- 100 fluid units per barrel. Vanilla was 50.
	-- That number also applies to gas tanks. Considered having it higher, but doesn't really make sense realistically, and gas tanks aren't more expensive than barrels. Also note currently filled gas tanks are also named "[something]-barrel".
NORTH, SOUTH, EAST, WEST = defines.direction.north, defines.direction.south, defines.direction.east, defines.direction.west
NORTH_FLOAT, SOUTH_FLOAT, EAST_FLOAT, WEST_FLOAT = 0, .5, .25, .75