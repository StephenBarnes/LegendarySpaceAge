-- This file changes cargo bays. We disallow them on space platforms, and prevent launching them on rockets. So it's harder to store anything. (Except belt weaving; might nerf that later, TODO.)

-- Block building in space.
local ent = data.raw["cargo-bay"]["cargo-bay"]
ent.surface_conditions = {{
	property = "gravity",
	min = 0.1,
}}

-- Block launching in rockets.
ITEM["cargo-bay"].weight = 1e7

-- Should be next to landing pad in menus.
ITEM["cargo-bay"].subgroup = "space-interactors"
ITEM["cargo-bay"].order = "b[cargo-landing-pad]-a"

--[[ Make the space platform hub receive cargo faster - since you can't build cargo expansions, and it's best to not have too many platforms.
Note this stuff isn't documented anywhere, aren't even set in Wube's Lua code, so TODO test that this actually works.
Testing: with busy_timeout_ticks = 60, we can receive 3 pods every ~8 seconds.
Tried doubling the number of cargo hatches, but it seems to cause a visual bug sometimes with it landing before the big hatch opens.
	Seems you need to set giga hatch's covered_hatches so that works correctly.
Looks like giga hatch 1 is for receiving, giga hatch 2 is for sending cargo pods.
And hatches 1-3 are receiving, 4-6 are sending.
So, tripled the number of cargo hatches, and assigned covered_hatches. Now it receives up to 9 pods each load, good.
]]
local cargoParams = data.raw["space-platform-hub"]["space-platform-hub"].cargo_station_parameters
local hatches = cargoParams.hatch_definitions
assert(hatches ~= nil)
assert(#hatches == 6)
for i = 1, 3 do
	hatches[i].busy_timeout_ticks = 60 -- Default 120, TODO test
	table.insert(hatches, table.deepcopy(hatches[i]))
	table.insert(hatches, table.deepcopy(hatches[i]))
	--hatch.hatch_opening_ticks
end
cargoParams.giga_hatch_definitions[1].covered_hatches = {1, 2, 3, 7, 8, 9, 10, 11, 12}