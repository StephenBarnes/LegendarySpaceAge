-- Create slime fluid.
local slimeFluid = copy(FLUID["water"])
slimeFluid.name = "slime"
Icon.set(slimeFluid, "LSA/water-types/slime")
slimeFluid.auto_barrel = true
slimeFluid.base_color = {.176, .255, .200}
slimeFluid.flow_color = {.393, .453, .333}
slimeFluid.visualization_color = {.482, .745, .215}
slimeFluid.max_temperature = nil
slimeFluid.heat_capacity = nil
extend{slimeFluid}

-- Create recipe to filter slime.
Recipe.make{
	copy = "iron-gear-wheel",
	recipe = "filter-slime",
	ingredients = {
		{"slime", 100, type = "fluid"},
	},
	results = {
		{"water", 50},
		{"spoilage", 1, show_details_in_recipe_tooltip = false},
		{"petrophage", 1, probability = .01, show_details_in_recipe_tooltip = false},
		-- Could give eggs or fruits with some small probability. But rather not, since that makes it too easy to restart cycles.
	},
	main_product = "water",
	category = "filtration",
	enabled = false,
	time = 1,
	specialIcons = {
		{icon = "__LegendarySpaceAge__/graphics/filtration/filter.png", icon_size = 64, scale = 0.4, mipmap_count = 4, shift = {0, 8}},
		{icon = "__LegendarySpaceAge__/graphics/water-types/slime.png", icon_size = 64, scale = 0.4, mipmap_count = 4, shift = {0, -4}},
	},
	crafting_machine_tint = {
		primary = {.482, .745, .215},
		secondary = {.176, .255, .200},
		tertiary = {.393, .453, .333},
	}
}

-- Make Gleba water tiles yield slime.
for _, tileName in pairs{
	"gleba-deep-lake",
	"wetland-blue-slime",
	"wetland-light-green-slime",
	"wetland-green-slime",
	"wetland-light-dead-skin",
	"wetland-dead-skin",
	"wetland-pink-tentacle",
	"wetland-red-tentacle",
	"wetland-yumako",
	"wetland-jellynut",
} do
	RAW.tile[tileName].fluid = "slime"
end

-- Create filtration-gleban-slime tech.
local filtrationGlebanSlimeTech = copy(TECH["jellynut"])
filtrationGlebanSlimeTech.name = "filtration-gleban-slime"
filtrationGlebanSlimeTech.icon = nil
filtrationGlebanSlimeTech.icons = {
	{icon = "__LegendarySpaceAge__/graphics/filtration/tech.png", icon_size = 256, scale = 0.5, shift = {-25, 0}},
	{icon = "__LegendarySpaceAge__/graphics/water-types/slime-tech.png", icon_size = 256, scale = 0.4, shift = {25, 0}},
}
filtrationGlebanSlimeTech.prerequisites = {"planet-discovery-gleba"}
filtrationGlebanSlimeTech.effects = {
	{type = "unlock-recipe", recipe = "filter-slime"},
}
filtrationGlebanSlimeTech.research_trigger = {
	type = "craft-fluid",
	fluid = "slime",
	amount = 100,
}
extend{filtrationGlebanSlimeTech}