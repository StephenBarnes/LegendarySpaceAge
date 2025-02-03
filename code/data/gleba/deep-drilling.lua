--[[ This file creates products of borehole drills on Gleba - geoplasm, chitin, marrow.
Also later recipes for them.
]]

-- Make the subgroup
data:extend{
	{
		type = "item-subgroup",
		name = "gleba-non-agriculture",
		group = "space",
		order = "0311",
	}
}

-- Create geoplasm fluid
local geoplasmFluid = table.deepcopy(data.raw.fluid["lubricant"])
geoplasmFluid.name = "geoplasm"
geoplasmFluid.icon = "__LegendarySpaceAge__/graphics/gleba/geoplasm.png"
-- TODO set colors
data:extend{geoplasmFluid}

-- Create chitin item
local chitinItem = table.deepcopy(data.raw.item["calcite"])
chitinItem.name = "chitin"
local chitinDir = "__LegendarySpaceAge__/graphics/gleba/chitin/"
chitinItem.icon = chitinDir.."3.png"
chitinItem.pictures = {}
for i = 1, 3 do
	chitinItem.pictures[i] = {filename = chitinDir..i..".png", size = 64, scale = 0.5}
end
chitinItem.subgroup = "gleba-non-agriculture"
chitinItem.order = "01"
data:extend{chitinItem}

-- Create marrow item
local marrowItem = table.deepcopy(data.raw.item["spoilage"])
marrowItem.name = "marrow"
local marrowDir = "__LegendarySpaceAge__/graphics/gleba/marrow/"
marrowItem.icon = marrowDir.."pillar-2.png"
marrowItem.pictures = {
	{filename = marrowDir.."pillar-1.png", size = 64, scale = 0.5},
	{filename = marrowDir.."pillar-2.png", size = 64, scale = 0.5},
	{filename = marrowDir.."pillar-3.png", size = 64, scale = 0.5},
	{filename = marrowDir.."pillar-4.png", size = 64, scale = 0.5},
	{filename = marrowDir.."pillar-5.png", size = 64, scale = 0.5},
	{filename = marrowDir.."roll-1.png", size = 64, scale = 0.5},
	{filename = marrowDir.."roll-2.png", size = 64, scale = 0.5},
	{filename = marrowDir.."roll-3.png", size = 64, scale = 0.5},
	{filename = marrowDir.."roll-4.png", size = 64, scale = 0.5},
	{filename = marrowDir.."roll-5.png", size = 64, scale = 0.5},
	{filename = marrowDir.."steak-1.png", size = 64, scale = 0.5},
	{filename = marrowDir.."steak-2.png", size = 64, scale = 0.5},
}
marrowItem.subgroup = "gleba-non-agriculture"
marrowItem.order = "02"
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
tubuleItem.order = "03"
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
	{ type = "item",  name = "chitin",    amount = 10 },
	{ type = "item",  name = "nutrients", amount = 4 },
	{ type = "fluid", name = "water",     amount = 100 },
}
chitinBrothRecipe.results = {{type = "fluid", name = "chitin-broth", amount = 100}}
chitinBrothRecipe.main_product = "chitin-broth"
chitinBrothRecipe.energy_required = 2
chitinBrothRecipe.enabled = true -- TODO make tech
chitinBrothRecipe.subgroup = "gleba-non-agriculture"
data:extend{chitinBrothRecipe}

-- Create recipe for tubules: bioflux + 4 pearl + 40 chitin broth -> 3 pearls (20% fresh) + 4 tubules
local tubuleRecipe = table.deepcopy(data.raw.recipe["bioflux"])
tubuleRecipe.name = "tubule"
tubuleRecipe.ingredients = {
	{type = "item", name = "bioflux", amount = 1},
	{type = "item", name = "slipstack-pearl", amount = 4},
	{type = "fluid", name = "chitin-broth", amount = 40},
}
tubuleRecipe.results = {
	{type = "item", name = "slipstack-pearl", amount = 3, percent_spoiled = 0.8, ignored_by_productivity = 3},
	{type = "item", name = "tubule", amount = 4},
	-- {type = "fluid", name = "slime", amount = 20}, -- Could produce slime, but that just seems annoying.
}
tubuleRecipe.main_product = "tubule"
tubuleRecipe.energy_required = 8
tubuleRecipe.enabled = true
tubuleRecipe.subgroup = "gleba-non-agriculture"
tubuleRecipe.icon = nil -- So it defaults to tubule icon.
data:extend{tubuleRecipe}