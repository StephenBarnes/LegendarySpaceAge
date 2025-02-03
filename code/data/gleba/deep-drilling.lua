--[[ This file creates products of borehole drills on Gleba - geoplasm, chitin, marrow.
Also later recipes for them.
]]

-- Make the subgroup
data:extend{
	{
		type = "item-subgroup",
		name = "gleba-non-agriculture",
		group = "space",
		order = "0211",
	}
}

-- Create geoplasm fluid
local geoplasmFluid = table.deepcopy(data.raw.fluid["lubricant"])
geoplasmFluid.name = "geoplasm"
geoplasmFluid.icon = "__LegendarySpaceAge__/graphics/gleba/geoplasm.png"
-- TODO set colors
data:extend{geoplasmFluid}

-- Create chitin fragments item
local chitinFragments = table.deepcopy(data.raw.item["calcite"])
chitinFragments.name = "chitin-fragments"
local chitinDir = "__LegendarySpaceAge__/graphics/gleba/chitin-fragments/"
chitinFragments.icon = chitinDir.."3.png"
chitinFragments.pictures = {}
for i = 1, 3 do
	chitinFragments.pictures[i] = {filename = chitinDir..i..".png", size = 64, scale = 0.5}
end
chitinFragments.subgroup = "gleba-non-agriculture"
data:extend{chitinFragments}

-- Create chitin block item
local chitinBlock = table.deepcopy(data.raw.item["calcite"])
chitinBlock.name = "chitin-block"
local chitinBlockDir = "__LegendarySpaceAge__/graphics/gleba/chitin-block/"
chitinBlock.icon = chitinBlockDir.."3.png"
chitinBlock.pictures = {}
for i = 1, 3 do
	chitinBlock.pictures[i] = {filename = chitinBlockDir..i..".png", size = 64, scale = 0.5}
end
chitinBlock.subgroup = "gleba-non-agriculture"
data:extend{chitinBlock}

-- Create marrow item
local marrowItem = table.deepcopy(data.raw.item["spoilage"])
marrowItem.name = "marrow"
local marrowDir = "__LegendarySpaceAge__/graphics/gleba/marrow/"
marrowItem.icon = marrowDir.."pillar-2.png"
marrowItem.pictures = {}
for _, picName in pairs{
	"pillar-1",
	"pillar-2",
	"pillar-3",
	"pillar-4",
	"pillar-5",
	"roll-1",
	"roll-2",
	"roll-3",
	"roll-4",
	"roll-5",
	"steak-1",
	"steak-2",
} do
	table.insert(marrowItem.pictures, {filename = marrowDir..picName..".png", size = 64, scale = 0.5})
end
marrowItem.subgroup = "gleba-non-agriculture"
marrowItem.spoil_ticks = nil
do
	marrowItem.fuel_value = nil
	marrowItem.fuel_acceleration_multiplier = nil
	marrowItem.fuel_emissions_multiplier = nil
	marrowItem.fuel_category = nil
	marrowItem.fuel_top_speed_multiplier = nil
	marrowItem.fuel_emissions_multiplier = nil
	marrowItem.fuel_glow_color = nil
end
marrowItem.stack_size = 50
marrowItem.weight = 1e6 / 500
data:extend{marrowItem}

-- Create tubule item
local tubuleItem = table.deepcopy(data.raw.item["calcite"])
tubuleItem.name = "tubule"
local tubuleDir = "__LegendarySpaceAge__/graphics/gleba/tubule/"
tubuleItem.icon = tubuleDir.."1.png"
tubuleItem.pictures = {}
for i = 1, 3 do
	tubuleItem.pictures[i] = {filename = tubuleDir..i..".png", size = 64, scale = 0.5}
end
tubuleItem.subgroup = "gleba-non-agriculture"
data:extend{tubuleItem}

-- Create chitin-broth fluid.
local chitinBrothFluid = table.deepcopy(data.raw.fluid["water"])
chitinBrothFluid.name = "chitin-broth"
chitinBrothFluid.icon = "__LegendarySpaceAge__/graphics/gleba/chitin-broth.png"
-- TODO set colors
-- Remove temperature stats from chitin-broth.
chitinBrothFluid.max_temperature = nil
chitinBrothFluid.heat_capacity = nil
data:extend{chitinBrothFluid}

-- Create chitin-broth recipe: 10 chitin fragments + 100 water + 4 nutrients -> 100 chitin-broth.
local chitinBrothRecipe = table.deepcopy(data.raw.recipe["lubricant"])
chitinBrothRecipe.name = "making-chitin-broth" -- Different name from fluid, so it doesn't get combined in factoriopedia.
chitinBrothRecipe.category = "organic-or-chemistry"
chitinBrothRecipe.ingredients = {
	{ type = "item",  name = "chitin-fragments", amount = 10 },
	{ type = "item",  name = "nutrients",        amount = 4 },
	{ type = "fluid", name = "water",            amount = 100 },
}
chitinBrothRecipe.results = {{type = "fluid", name = "chitin-broth", amount = 100}}
chitinBrothRecipe.main_product = "chitin-broth"
chitinBrothRecipe.energy_required = 2
chitinBrothRecipe.enabled = true -- TODO make tech
chitinBrothRecipe.subgroup = "gleba-non-agriculture"
data:extend{chitinBrothRecipe}
-- TODO consider adding a recipe to cast structures out of chitin broth?

-- Create recipe for tubules: bioflux + 4 pearl + 40 chitin broth -> 3 pearls (20% fresh) + 4 tubules
local tubuleRecipe = table.deepcopy(data.raw.recipe["bioflux"])
tubuleRecipe.name = "tubule"
tubuleRecipe.ingredients = {
	{type = "item", name = "bioflux", amount = 1},
	{type = "item", name = "slipstack-pearl", amount = 4},
	{type = "fluid", name = "chitin-broth", amount = 40},
}
tubuleRecipe.results = {
	{type = "item", name = "tubule", amount = 4},
	{type = "fluid", name = "slime", amount = 20}, -- Kind of just an annoyance (have to pump it into a lake) but I like this aesthetically.
	{type = "item", name = "slipstack-pearl", amount = 2, percent_spoiled = 0.8},
		-- With productivity, this is 3 pearls.
}
tubuleRecipe.main_product = "tubule"
tubuleRecipe.energy_required = 8
tubuleRecipe.enabled = true
tubuleRecipe.subgroup = "gleba-non-agriculture"
tubuleRecipe.icon = nil -- So it defaults to tubule icon.
data:extend{tubuleRecipe}

-- Create smelting recipe for chitin fragments to block.
local chitinBlockRecipe = table.deepcopy(data.raw.recipe["stone-brick"])
chitinBlockRecipe.name = "chitin-block"
chitinBlockRecipe.ingredients = {
	{type = "item", name = "chitin-fragments", amount = 4},
}
chitinBlockRecipe.results = {{type = "item", name = "chitin-block", amount = 1}}
chitinBlockRecipe.enabled = true -- TODO make tech
chitinBlockRecipe.auto_recycle = true
data:extend{chitinBlockRecipe}

------------------------------------------------------------------------

-- Set orders for items. (TODO later recipes too?)
for i, itemName in pairs{
	"marrow",
	"chitin-fragments",
	"chitin-block",
	"tubule",
} do
	data.raw.item[itemName].order = string.format("%02d", i)
end