--[[ This file specifies arrangement of all items/fluids/recipes that aren't hidden. Applies to Factoriopedia, player crafting menu, and machine crafting menus.
The actual order is defined in a giant table in util/const/item-recipe-arrangement-const.lua.
Also creates new groups (top-level tabs).

Subgroup/order shouldn't be set anywhere else in the mod. This file handles everything.

NOTE that we want 6 groups per row in Factoriopedia and in player inventory, and preferably it should fill up a whole number of rows.

TODO check that all non-hidden items/fluids/recipes are included in the ARRANGEMENT below. In auto-debugger.
]]


-- Create item groups.
extend{
	{
		type = "item-group",
		name = "material-processing",
		order = "c3",
		icon = "__LegendarySpaceAge__/graphics/tabs/material-processing.png",
		icon_size = 256,
	},
	{
		type = "item-group",
		name = "metallurgy",
		order = "c3",
		icon = "__LegendarySpaceAge__/graphics/tabs/metallurgy.png",
		icon_size = 256,
	},
	{
		type = "item-group",
		name = "petrochemistry",
		order = "c3",
		icon = "__base__/graphics/technology/advanced-oil-processing.png",
		icon_size = 256,
	},
	{
		type = "item-group",
		name = "chemistry",
		order = "c3",
		icon = "__LegendarySpaceAge__/graphics/tabs/chemistry.png",
		icon_size = 256,
	},
	{
		type = "item-group",
		name = "heat",
		order = "d2",
		icon = "__LegendarySpaceAge__/graphics/tabs/heat.png",
		icon_size = 256,
	},
	{
		type = "item-group",
		name = "intermediate-factors",
		order = "c2",
		icon = "__LegendarySpaceAge__/graphics/intermediate-factors/factors-tab.png",
		icon_size = 256,
	},
	{
		type = "item-group",
		name = "bio-processing",
		order = "d1",
		icon = "__space-age__/graphics/technology/tree-seeding.png",
		icon_size = 256,
	},
}

-- Change logistics and production tabs to use new icons, so they fit better with the rest of the tabs' icons.
RAW["item-group"]["logistics"].icon = "__LegendarySpaceAge__/graphics/tabs/logistics.png"
RAW["item-group"]["logistics"].icon_size = 256
RAW["item-group"]["production"].icon = "__LegendarySpaceAge__/graphics/tabs/production.png"
RAW["item-group"]["production"].icon_size = 256

-- Change intermediate-products tab to use manufacturing icon.
-- (Could create a new tab, but rather reusing it in case other mods want to put stuff in there.)
RAW["item-group"]["intermediate-products"].icon = "__LegendarySpaceAge__/graphics/tabs/manufacturing.png"
RAW["item-group"]["intermediate-products"].icon_size = 256

-- Change the space tab's icon, from satellite to rocket silo, since it's now anything after Nauvis.
RAW["item-group"]["space"].icon = "__base__/graphics/technology/rocket-silo.png"
RAW["item-group"]["space"].icon_size = 256

-- Hide infinity cargo wagon.
RAW["infinity-cargo-wagon"]["infinity-cargo-wagon"].hidden = true
RAW["infinity-cargo-wagon"]["infinity-cargo-wagon"].hidden_from_player_crafting = true

-- Import big table of item/recipe/fluid/etc orders.
local ARRANGEMENT = require("const.item-recipe-arrangement-const")
-- Apply the big table, by creating subgroups and setting subgroups and orders.
local groupCount = 0
for groupName, subgroups in pairs(ARRANGEMENT) do
	local group = RAW["item-group"][groupName]
	assert(group ~= nil, "Group " .. groupName .. " not found")
	groupCount = groupCount + 1
	group.order = string.format("a-%02d", groupCount)
	local subgroupCount = 0
	for subgroupName, entries in pairs(subgroups) do
		subgroupCount = subgroupCount + 1
		if RAW["item-subgroup"][subgroupName] == nil then
			extend{{
				type = "item-subgroup",
				name = subgroupName,
				group = groupName,
				order = string.format("%02d", subgroupCount),
			}}
			subgroupCount = subgroupCount + 1
		else
			local subgroup = RAW["item-subgroup"][subgroupName]
			subgroup.group = groupName
			subgroup.order = string.format("%02d", subgroupCount)
		end
		local entryCount = 0
		for _, entry in pairs(entries) do
			entryCount = entryCount + 1
			local thing = nil
			local thingType = nil
			for _, kind in pairs{"item", "fluid", "recipe", "module", "tool", "ammo", "gun"} do -- Prefer using item, then fluid, etc.
				if RAW[kind][entry] ~= nil then
					thing = RAW[kind][entry]
					thingType = kind
					break
				end
			end
			if thing == nil then -- If not item/fluid/recipe, check all other types.
				for _, kind in pairs(RAW) do
					if kind[entry] ~= nil then
						thing = kind[entry]
						thingType = kind
						break
					end
				end
			end
			if thing == nil then
				log("ERROR: Item " .. entry .. " not found")
			else
				---@cast thing data.Prototype
				thing.subgroup = subgroupName
				thing.order = string.format("%02d", entryCount)

				-- Copy the subgroup and order to recipes (and some other types) of the same name. (Could zero it out, but that doesn't always seem to work, eg for rail planners.)
				-- for mimicKind, _ in pairs(RAW) do -- This somehow makes the game hang at "loading prototypes", weird.
				for _, mimicKind in pairs{
					"fluid", "recipe", "module", "tool", "resource",
					"rail-planner", "straight-rail", "item-with-entity-data",
					"space-platform-starter-pack", "space-platform-hub",
					"combat-robot", "capsule", "ammo", "gun",
				} do
					if thingType ~= mimicKind then
						local mimicThing = RAW[mimicKind][thing.name]
						if mimicThing ~= nil then
							mimicThing.subgroup = thing.subgroup
							mimicThing.order = thing.order
						end
					end
				end
			end
		end
	end
end

-- Assign orders to waste pump recipes, to be the same as the fluids.
local excludedFluids = Table.listToSet{"fluid-unknown", "plasma"}
local function assignVentRecipeOrder(fluidName, fluid)
	if excludedFluids[fluidName] == nil then return end
	local fluidOrder = fluid.order
	if fluid.subgroup == nil then
		log("Warning: fluid "..fluidName.." has no subgroup")
		return
	end
	local subgroupOrder = RAW["item-subgroup"][fluid.subgroup].order
	if subgroupOrder == nil then
		log("Warning: fluid "..fluidName.." has subgroup "..fluid.subgroup.." which has no order")
		return
	end
	local ventRecipeOrder = subgroupOrder .. "-" .. fluidOrder

	local gasVentRecipe = RECIPE["gas-vent-"..fluidName]
	if gasVentRecipe ~= nil then
		gasVentRecipe.order = ventRecipeOrder
	else
		log("Warning: fluid "..fluidName.." has no gas vent recipe")
	end
	local wastePumpRecipe = RECIPE["waste-pump-"..fluidName]
	if wastePumpRecipe ~= nil then
		wastePumpRecipe.order = ventRecipeOrder
	end
end
for fluidName, fluid in pairs(FLUID) do
	assignVentRecipeOrder(fluidName, fluid)
end