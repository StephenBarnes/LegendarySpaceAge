--[[ This file creates new items and recipes, eg for products of borehole drills on Gleba - geoplasm, chitin, marrow.
]]

local Item = require("code.util.item")
local Tech = require("code.util.tech")

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
local geoplasmPinkColor = {r=.8, g=.404, b=.388}
local geoplasmGreenColor = {r=.345, g = .518, b = .098}
geoplasmFluid.base_color = geoplasmPinkColor
geoplasmFluid.flow_color = geoplasmGreenColor
geoplasmFluid.visualization_color = geoplasmPinkColor
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
marrowItem.spoil_ticks = 60 * 60 * 60 -- 1 hour
marrowItem.spoil_result = "spoilage"
Item.clearFuel(marrowItem)
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
local chitinDarkColor = {r = .365, g = .263, b = .224}
local chitinLightColor = {r = .663, g = .58, b = .482}
chitinBrothFluid.base_color = chitinDarkColor
chitinBrothFluid.flow_color = chitinLightColor
chitinBrothFluid.visualization_color = chitinDarkColor
-- Remove temperature stats from chitin-broth.
chitinBrothFluid.max_temperature = nil
chitinBrothFluid.heat_capacity = nil
data:extend{chitinBrothFluid}

-- Create appendage item.
local appendageItem = table.deepcopy(marrowItem)
appendageItem.name = "appendage"
local appendageDir = "__LegendarySpaceAge__/graphics/gleba/appendage/"
appendageItem.icon = appendageDir.."1.png"
appendageItem.pictures = {}
for i = 1, 9 do
	appendageItem.pictures[i] = {filename = appendageDir..i..".png", size = 64, scale = 0.5}
end
appendageItem.subgroup = "gleba-non-agriculture"
appendageItem.icon = appendageDir.."1.png"
appendageItem.spoil_ticks = 60 * 60 * 10
appendageItem.spoil_result = "spoilage"
data:extend{appendageItem}

-- Create sencytium item.
local sencytiumItem = table.deepcopy(appendageItem)
sencytiumItem.name = "sencytium"
local sencytiumDir = "__LegendarySpaceAge__/graphics/gleba/sencytium/"
sencytiumItem.icon = sencytiumDir.."1.png"
sencytiumItem.pictures = {}
for i = 1, 11 do
	sencytiumItem.pictures[i] = {filename = sencytiumDir..i..".png", size = 64, scale = 0.5}
end
sencytiumItem.subgroup = "gleba-non-agriculture"
sencytiumItem.spoil_ticks = 60 * 60 * 10
sencytiumItem.spoil_result = "spoilage"
data:extend{sencytiumItem}

------------------------------------------------------------------------

-- Create chitin-broth recipe: 4 chitin fragments + 100 water + 4 nutrients -> 100 chitin-broth.
local chitinBrothRecipe = table.deepcopy(data.raw.recipe["lubricant"])
chitinBrothRecipe.name = "making-chitin-broth" -- Different name from fluid, so it doesn't get combined in factoriopedia.
chitinBrothRecipe.category = "organic-or-chemistry"
chitinBrothRecipe.ingredients = {
	{ type = "item",  name = "chitin-fragments", amount = 4 },
	{ type = "item",  name = "nutrients",        amount = 4 },
	{ type = "fluid", name = "water",            amount = 100 },
}
chitinBrothRecipe.results = {{type = "fluid", name = "chitin-broth", amount = 100}}
chitinBrothRecipe.main_product = "chitin-broth"
chitinBrothRecipe.energy_required = 2
chitinBrothRecipe.enabled = false
chitinBrothRecipe.subgroup = "gleba-non-agriculture"
chitinBrothRecipe.crafting_machine_tint = {
	primary = chitinLightColor,
	secondary = chitinDarkColor,
	tertiary = chitinLightColor,
}
data:extend{chitinBrothRecipe}
-- TODO consider adding a recipe to cast structures out of chitin broth?

-- Create recipe for tubules: 4 pearl + 40 chitin broth -> 3 pearls (20% fresh) + 4 tubules
local tubuleRecipe = table.deepcopy(data.raw.recipe["bioflux"])
tubuleRecipe.name = "tubule"
tubuleRecipe.ingredients = {
	{type = "item", name = "slipstack-pearl", amount = 4},
	{type = "fluid", name = "chitin-broth", amount = 40},
}
tubuleRecipe.results = {
	{type = "item", name = "tubule", amount = 4},
	{type = "fluid", name = "slime", amount = 10}, -- Kind of just an annoyance (have to pump it into a lake) but I like this aesthetically. Also it's exactly enough for making frames.
	{type = "item", name = "slipstack-pearl", amount = 2, percent_spoiled = 0.8},
		-- With productivity, this is 3 pearls.
}
tubuleRecipe.main_product = "tubule"
tubuleRecipe.energy_required = 8
tubuleRecipe.enabled = false
tubuleRecipe.icon = nil -- So it defaults to tubule icon.
tubuleRecipe.subgroup = "gleba-non-agriculture"
tubuleRecipe.crafting_machine_tint = table.deepcopy(chitinBrothRecipe.crafting_machine_tint)
data:extend{tubuleRecipe}

-- Create smelting recipe for chitin fragments to block.
local chitinBlockRecipe = table.deepcopy(data.raw.recipe["stone-brick"])
chitinBlockRecipe.name = "chitin-block"
chitinBlockRecipe.ingredients = {
	{type = "item", name = "chitin-fragments", amount = 2},
}
chitinBlockRecipe.results = {{type = "item", name = "chitin-block", amount = 1}}
chitinBlockRecipe.enabled = false
chitinBlockRecipe.auto_recycle = true
chitinBlockRecipe.subgroup = "gleba-non-agriculture"
chitinBlockRecipe.crafting_machine_tint = table.deepcopy(chitinBrothRecipe.crafting_machine_tint)
data:extend{chitinBlockRecipe}

-- Create recipe for appendages: 10 geoplasm + 1 tubule -> 1 appendage
local appendageRecipe = table.deepcopy(tubuleRecipe)
appendageRecipe.name = "appendage"
appendageRecipe.ingredients = {
	{type = "fluid", name = "geoplasm", amount = 10},
	{type = "item", name = "tubule", amount = 1},
}
appendageRecipe.results = {{type = "item", name = "appendage", amount = 1}}
appendageRecipe.main_product = "appendage"
appendageRecipe.energy_required = 4
appendageRecipe.enabled = false
appendageRecipe.subgroup = "gleba-non-agriculture"
appendageRecipe.crafting_machine_tint = {
	primary = geoplasmGreenColor,
	secondary = geoplasmPinkColor,
	tertiary = geoplasmGreenColor,
}
data:extend{appendageRecipe}

-- Create recipe for sencytium: 20 geoplasm + 1 activated pentapod egg -> 1 sencytium
local sencytiumRecipe = table.deepcopy(appendageRecipe)
sencytiumRecipe.name = "sencytium"
sencytiumRecipe.ingredients = {
	{type = "fluid", name = "geoplasm", amount = 20},
	{type = "item", name = "activated-pentapod-egg", amount = 1},
}
sencytiumRecipe.results = {{type = "item", name = "sencytium", amount = 1}}
sencytiumRecipe.main_product = "sencytium"
sencytiumRecipe.energy_required = 8
sencytiumRecipe.enabled = false
sencytiumRecipe.subgroup = "gleba-non-agriculture"
sencytiumRecipe.icon = nil -- So it defaults to sencytium icon.
sencytiumRecipe.crafting_machine_tint = table.deepcopy(appendageRecipe.crafting_machine_tint)
data:extend{sencytiumRecipe}

------------------------------------------------------------------------

-- Set orders for items. (TODO later recipes too?)
for i, itemName in pairs{
	"marrow",
	"chitin-fragments",
	"chitin-block",
	"tubule",
	"appendage",
	"sencytium",
} do
	data.raw.item[itemName].order = string.format("%02d", i)
end

------------------------------------------------------------------------

-- Create 2 techs for chitin processing.
local chitinTech1 = table.deepcopy(data.raw.technology["jellynut"])
chitinTech1.name = "chitin-processing-1"
chitinTech1.effects = {
	{type = "unlock-recipe", recipe = "chitin-block"},
	{type = "unlock-recipe", recipe = "structure-from-chitin"},
}
chitinTech1.prerequisites = {"planet-discovery-gleba"}
chitinTech1.research_trigger = {
	type = "mine-entity",
	entity = "small-stomper-shell-no-corpse",
}
chitinTech1.icon = "__LegendarySpaceAge__/graphics/gleba/chitin-tech-1.png"
chitinTech1.localised_description = {"technology-description.chitin-processing-1"}
data:extend{chitinTech1}

local chitinTech2 = table.deepcopy(chitinTech1)
chitinTech2.name = "chitin-processing-2"
chitinTech2.effects = {
	{type = "unlock-recipe", recipe = "making-chitin-broth"},
	{type = "unlock-recipe", recipe = "tubule"},
	{type = "unlock-recipe", recipe = "frame-from-tubules"},
}
chitinTech2.prerequisites = {"chitin-processing-1", "biochamber"}
chitinTech2.research_trigger = {
	type = "craft-item",
	item = "chitin-block",
	count = 20,
}
chitinTech2.icon = "__LegendarySpaceAge__/graphics/gleba/chitin-tech-2.png"
chitinTech2.localised_description = {"technology-description.chitin-processing-2"}
data:extend{chitinTech2}

-- Create tech for geoplasm.
local geoplasmTech = table.deepcopy(chitinTech1)
geoplasmTech.name = "geoplasm"
geoplasmTech.effects = {
	{type = "unlock-recipe", recipe = "appendage"},
	{type = "unlock-recipe", recipe = "sencytium"},
	{type = "unlock-recipe", recipe = "mechanism-from-appendage"},
	{type = "unlock-recipe", recipe = "sensor-from-sencytium"},
	{type = "unlock-recipe", recipe = "actuator-from-appendage"},
}
geoplasmTech.prerequisites = {"chitin-processing-2"}
geoplasmTech.research_trigger = {
	type = "craft-fluid",
	fluid = "geoplasm",
	count = 100,
}
geoplasmTech.icon = "__LegendarySpaceAge__/graphics/gleba/geoplasm-tech.png"
geoplasmTech.localised_description = nil
data:extend{geoplasmTech}
Tech.addTechDependency("geoplasm", "agricultural-science-pack")
