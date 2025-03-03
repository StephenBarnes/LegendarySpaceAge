--[[ This file creates new items and recipes, eg for products of borehole drills on Gleba - geoplasm, chitin, marrow.
]]

-- Make the subgroup
extend{
	{
		type = "item-subgroup",
		name = "gleba-non-agriculture",
		group = "post-space",
		order = "0211",
	}
}

-- Create geoplasm fluid
local geoplasmFluid = copy(FLUID["lubricant"])
geoplasmFluid.name = "geoplasm"
Icon.set(geoplasmFluid, "LSA/gleba/geoplasm")
local geoplasmPinkColor = {r=.8, g=.404, b=.388}
local geoplasmGreenColor = {r=.345, g = .518, b = .098}
geoplasmFluid.base_color = geoplasmPinkColor
geoplasmFluid.flow_color = geoplasmGreenColor
geoplasmFluid.visualization_color = geoplasmPinkColor
extend{geoplasmFluid}

-- Create chitin fragments item
local chitinFragments = copy(ITEM["calcite"])
chitinFragments.name = "chitin-fragments"
Icon.set(chitinFragments, "LSA/gleba/chitin-fragments/3")
Icon.variants(chitinFragments, "LSA/gleba/chitin-fragments/%", 3)
chitinFragments.subgroup = "gleba-non-agriculture"
extend{chitinFragments}

-- Create chitin block item
local chitinBlock = copy(ITEM["calcite"])
chitinBlock.name = "chitin-block"
Icon.set(chitinBlock, "LSA/gleba/chitin-block/3")
Icon.variants(chitinBlock, "LSA/gleba/chitin-block/%", 3)
chitinBlock.subgroup = "gleba-non-agriculture"
extend{chitinBlock}

-- Create marrow item
local marrowItem = copy(ITEM["spoilage"])
marrowItem.name = "marrow"
Icon.set(marrowItem, "LSA/gleba/marrow/2")
Icon.variants(marrowItem, "LSA/gleba/marrow/%", 12)
marrowItem.subgroup = "gleba-non-agriculture"
marrowItem.spoil_ticks = 20 * MINUTES
marrowItem.spoil_result = "spoilage"
Item.clearFuel(marrowItem)
marrowItem.stack_size = 50
Item.perRocket(marrowItem, 500)
extend{marrowItem}

-- Create tubule item
local tubuleItem = copy(ITEM["calcite"])
tubuleItem.name = "tubule"
Icon.set(tubuleItem, "LSA/gleba/tubule/1")
Icon.variants(tubuleItem, "LSA/gleba/tubule/%", 3)
tubuleItem.subgroup = "gleba-non-agriculture"
extend{tubuleItem}

-- Create chitin-broth fluid.
local chitinBrothFluid = copy(FLUID["water"])
chitinBrothFluid.name = "chitin-broth"
Icon.set(chitinBrothFluid, "LSA/gleba/chitin-broth")
local chitinDarkColor = {r = .365, g = .263, b = .224}
local chitinLightColor = {r = .663, g = .58, b = .482}
chitinBrothFluid.base_color = chitinDarkColor
chitinBrothFluid.flow_color = chitinLightColor
chitinBrothFluid.visualization_color = chitinDarkColor
-- Remove temperature stats from chitin-broth.
chitinBrothFluid.max_temperature = nil
chitinBrothFluid.heat_capacity = nil
extend{chitinBrothFluid}

-- Create appendage item.
local appendageItem = copy(marrowItem)
appendageItem.name = "appendage"
Icon.set(appendageItem, "LSA/gleba/appendage/1")
Icon.variants(appendageItem, "LSA/gleba/appendage/%", 9)
appendageItem.subgroup = "gleba-non-agriculture"
appendageItem.spoil_ticks = 10 * MINUTES
appendageItem.spoil_result = "spoilage"
extend{appendageItem}

-- Create sencytium item.
local sencytiumItem = copy(appendageItem)
sencytiumItem.name = "sencytium"
Icon.set(sencytiumItem, "LSA/gleba/sencytium/1")
Icon.variants(sencytiumItem, "LSA/gleba/sencytium/%", 11, {draw_as_glow = true})
sencytiumItem.subgroup = "gleba-non-agriculture"
sencytiumItem.spoil_ticks = 10 * MINUTES
sencytiumItem.spoil_result = "spoilage"
extend{sencytiumItem}

------------------------------------------------------------------------

-- Create chitin-broth recipe: 5 chitin fragments + 100 water + 5 nutrients -> 100 chitin-broth.
local chitinBrothRecipe = copy(RECIPE["lubricant"])
chitinBrothRecipe.name = "making-chitin-broth" -- Different name from fluid, so it doesn't get combined in factoriopedia.
chitinBrothRecipe.category = "chemistry"
chitinBrothRecipe.ingredients = {
	{ type = "item",  name = "chitin-fragments", amount = 5 },
	{ type = "item",  name = "nutrients",        amount = 5 },
	{ type = "fluid", name = "water",            amount = 100 },
}
chitinBrothRecipe.results = {{type = "fluid", name = "chitin-broth", amount = 100}}
chitinBrothRecipe.main_product = "chitin-broth"
chitinBrothRecipe.energy_required = 1
chitinBrothRecipe.enabled = false
chitinBrothRecipe.subgroup = "gleba-non-agriculture"
chitinBrothRecipe.crafting_machine_tint = {
	primary = chitinLightColor,
	secondary = chitinDarkColor,
	tertiary = chitinLightColor,
}
extend{chitinBrothRecipe}
-- TODO consider adding a recipe to cast structures out of chitin broth?

-- Create recipe for tubules: 4 pearl + 40 chitin broth -> 3 pearls (20% fresh) + 4 tubules
local tubuleRecipe = copy(RECIPE["bioflux"])
tubuleRecipe.name = "tubule"
tubuleRecipe.ingredients = {
	{type = "item", name = "slipstack-pearl", amount = 5},
	{type = "fluid", name = "chitin-broth", amount = 50},
}
tubuleRecipe.results = {
	{type = "item", name = "tubule", amount = 5},
	{type = "item", name = "slipstack-pearl", amount = 4, percent_spoiled = 0.8, ignored_by_productivity = 4},
	{type = "fluid", name = "slime", amount = 10, ignored_by_productivity = 10}, -- Kind of just an annoyance (have to pump it into a lake) but I like this aesthetically. Also it's exactly enough for making frames.
		-- Also, have to ignore prod for the slime, to avoid allowing a loop that creates water out of nothing.
}
tubuleRecipe.main_product = "tubule"
tubuleRecipe.energy_required = 10
tubuleRecipe.enabled = false
Icon.clear(tubuleRecipe)
tubuleRecipe.subgroup = "gleba-non-agriculture"
tubuleRecipe.crafting_machine_tint = copy(chitinBrothRecipe.crafting_machine_tint)
extend{tubuleRecipe}

-- Create recipe for compressing chitin fragments into blocks.
local chitinBlockRecipe = copy(RECIPE["rail"])
chitinBlockRecipe.name = "chitin-block"
chitinBlockRecipe.ingredients = {
	{type = "item", name = "chitin-fragments", amount = 2},
}
chitinBlockRecipe.results = {{type = "item", name = "chitin-block", amount = 1}}
chitinBlockRecipe.enabled = false
chitinBlockRecipe.auto_recycle = true
chitinBlockRecipe.subgroup = "gleba-non-agriculture"
chitinBlockRecipe.crafting_machine_tint = copy(chitinBrothRecipe.crafting_machine_tint)
extend{chitinBlockRecipe}

-- Create recipe for appendages: 10 geoplasm + 1 tubule -> 1 appendage
local appendageRecipe = copy(tubuleRecipe)
appendageRecipe.name = "appendage"
appendageRecipe.ingredients = {
	{type = "fluid", name = "geoplasm", amount = 10},
	{type = "item", name = "tubule", amount = 1},
}
appendageRecipe.results = {{type = "item", name = "appendage", amount = 1}}
appendageRecipe.main_product = "appendage"
appendageRecipe.energy_required = 5
appendageRecipe.enabled = false
appendageRecipe.subgroup = "gleba-non-agriculture"
appendageRecipe.crafting_machine_tint = {
	primary = geoplasmGreenColor,
	secondary = geoplasmPinkColor,
	tertiary = geoplasmGreenColor,
}
extend{appendageRecipe}

-- Create recipe for sencytium: 20 geoplasm + 1 activated pentapod egg -> 1 sencytium
local sencytiumRecipe = copy(appendageRecipe)
sencytiumRecipe.name = "sencytium"
sencytiumRecipe.ingredients = {
	{type = "fluid", name = "geoplasm", amount = 20},
	{type = "item", name = "activated-pentapod-egg", amount = 1},
}
sencytiumRecipe.results = {{type = "item", name = "sencytium", amount = 1}}
sencytiumRecipe.main_product = "sencytium"
sencytiumRecipe.energy_required = 10
sencytiumRecipe.enabled = false
sencytiumRecipe.subgroup = "gleba-non-agriculture"
Icon.clear(sencytiumRecipe)
sencytiumRecipe.crafting_machine_tint = copy(appendageRecipe.crafting_machine_tint)
extend{sencytiumRecipe}

-- Create recipe for nutrients from marrow: 5 marrow + 1 bioflux + 10 sulfuric acid -> 40 nutrients.
local nutrientsFromMarrowRecipe = copy(RECIPE["nutrients-from-bioflux"])
nutrientsFromMarrowRecipe.name = "nutrients-from-marrow"
nutrientsFromMarrowRecipe.ingredients = {
	{type = "item", name = "marrow", amount = 5},
	{type = "item", name = "bioflux", amount = 1},
		-- I like this since it links the bioflux-yumako-jellynut recipes to the borehole stuff.
	{type = "fluid", name = "sulfuric-acid", amount = 10},
}
nutrientsFromMarrowRecipe.results = {{type = "item", name = "nutrients", amount = 40}}
nutrientsFromMarrowRecipe.enabled = false
nutrientsFromMarrowRecipe.subgroup = "gleba-non-agriculture"
Icon.set(nutrientsFromMarrowRecipe, {"nutrients", "marrow"})
nutrientsFromMarrowRecipe.crafting_machine_tint = copy(RECIPE["sulfuric-acid"].crafting_machine_tint)
extend{nutrientsFromMarrowRecipe}

-- Use the same icon function for built-in recipes, so they look the same.
Icon.set(RECIPE["nutrients-from-spoilage"], {"nutrients", "spoilage"})
Icon.set(RECIPE["nutrients-from-bioflux"], {"nutrients", "bioflux"})
Icon.set(RECIPE["nutrients-from-yumako-mash"], {"nutrients", "yumako-mash"})

-- Create recipe for landfill from chitin fragments.
local landfillFromChitinRecipe = copy(RECIPE["landfill"])
landfillFromChitinRecipe.name = "landfill-from-chitin"
landfillFromChitinRecipe.ingredients = {
	{type = "item", name = "marrow", amount = 20},
	{type = "item", name = "chitin-fragments", amount = 20},
}
Icon.set(landfillFromChitinRecipe, {"landfill", "marrow", "chitin-fragments"})
landfillFromChitinRecipe.subgroup = "gleba-non-agriculture"
landfillFromChitinRecipe.order = "d"
extend{landfillFromChitinRecipe}

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
	ITEM[itemName].order = string.format("%02d", i)
end

------------------------------------------------------------------------

-- Create 2 techs for chitin processing.
local chitinTech1 = copy(TECH["jellynut"])
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
Icon.set(chitinTech1, "LSA/gleba/chitin-tech-1")
chitinTech1.localised_description = {"technology-description.chitin-processing-1"}
extend{chitinTech1}

local chitinTech2 = copy(chitinTech1)
chitinTech2.name = "chitin-processing-2"
chitinTech2.effects = {
	{type = "unlock-recipe", recipe = "making-chitin-broth"},
	{type = "unlock-recipe", recipe = "tubule"},
	{type = "unlock-recipe", recipe = "frame-from-tubules"},
}
chitinTech2.prerequisites = {"chitin-processing-1", "biochamber", "slipstack-propagation"}
chitinTech2.research_trigger = {
	type = "craft-item",
	item = "chitin-block",
	count = 20,
}
Icon.set(chitinTech2, "LSA/gleba/chitin-tech-2")
chitinTech2.localised_description = {"technology-description.chitin-processing-2"}
extend{chitinTech2}

-- Create tech for marrow.
local marrowTech = copy(chitinTech1)
marrowTech.name = "marrow"
marrowTech.effects = {
	{type = "unlock-recipe", recipe = "nutrients-from-marrow"},
	{type = "unlock-recipe", recipe = "landfill-from-chitin"},
}
marrowTech.prerequisites = {"planet-discovery-gleba"}
marrowTech.research_trigger = {
	type = "craft-item",
	item = "marrow",
	count = 10,
}
Icon.set(marrowTech, "LSA/gleba/marrow-tech")
marrowTech.localised_description = nil
extend{marrowTech}

local biomechanismsTech = copy(marrowTech)
biomechanismsTech.name = "biomechanisms"
biomechanismsTech.prerequisites = {"marrow", "chitin-processing-2", "egg-duplication"}
biomechanismsTech.research_trigger = {
	type = "craft-item",
	item = "biochamber",
	count = 10,
}
biomechanismsTech.effects = {
	{type = "unlock-recipe", recipe = "appendage"},
	{type = "unlock-recipe", recipe = "sencytium"},
	{type = "unlock-recipe", recipe = "mechanism-from-appendage"},
	{type = "unlock-recipe", recipe = "sensor-from-sencytium"},
	{type = "unlock-recipe", recipe = "actuator-from-appendage"},
}
Icon.set(biomechanismsTech, "LSA/gleba/biomechanisms-tech")
extend{biomechanismsTech}
Tech.addTechDependency("biomechanisms", "agricultural-science-pack")