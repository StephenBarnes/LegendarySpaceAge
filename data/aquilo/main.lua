--[[
local mineralDustItem = copy(ITEM.stone)
mineralDustItem.name = "mineral-dust"
mineralDustItem.order = (mineralDustItem.order or "") .. "-b"
extend({mineralDustItem})
]]

-- Add heating energy to offshore pump and waste pump.
RAW["offshore-pump"]["offshore-pump"].heating_energy = "50kW"

-- Change autoplace control for Aquilo crude oil to one for natural gas wells.
-- Leaving it with the same prototype name, so we don't need to disturb the autoplace expressions. Rather just change the autoplace control's name and rewire it to control natgas instead of oil wells.
local mapGen = RAW.planet.aquilo.map_gen_settings
assert(mapGen ~= nil)
RAW["autoplace-control"]["aquilo_crude_oil"].localised_name = {"", "[entity=natural-gas-well]", {"entity-name.natural-gas-well"}}
mapGen.autoplace_settings.entity.settings["natural-gas-well"] = mapGen.autoplace_settings.entity.settings["crude-oil"]
mapGen.autoplace_settings.entity.settings["crude-oil"] = nil
mapGen.property_expression_names["entity:natural-gas-well:probability"] = mapGen.property_expression_names["entity:crude-oil:probability"]
mapGen.property_expression_names["entity:natural-gas-well:richness"] = mapGen.property_expression_names["entity:crude-oil:richness"]
mapGen.property_expression_names["entity:crude-oil:probability"] = nil
mapGen.property_expression_names["entity:crude-oil:richness"] = nil

-- Change icon for lithium brine, which is now "mineral brine".
Icon.set(FLUID["lithium-brine"], "LSA/aquilo/mineral-brine")

-- Clear temperature spam for fluids.
Fluid.setSimpleTemp(FLUID["ammoniacal-solution"], -33, true, -50)

-- Remove fluoroketone and recipes.
Recipe.hide("fluoroketone")
Recipe.hide("fluoroketone-cooling")
Tech.removeRecipeFromTech("fluoroketone", "cryogenic-plant")
Tech.removeRecipeFromTech("fluoroketone-cooling", "cryogenic-plant")
Fluid.hide("fluoroketone-cold")
Fluid.hide("fluoroketone-hot")
FLUID["fluoroketone-cold"].auto_barrel = false
FLUID["fluoroketone-hot"].auto_barrel = false
-- TODO maybe add liquid helium (since it has even lower boiling point than hydrogen) and use that for Aquilo processes.
-- TODO and maybe instead of making that a new fluid, use fluoroketone-cold/hot but change locale and icons to helium gas / liquid helium.
Recipe.edit{
	recipe = "cryogenic-science-pack",
	ingredients = { -- Originally 3 ice + 1 lithium plate + 6 fluoroketone-cold -> 1 science pack + 3 fluoroketone-hot.
		{"lithium-plate", 1},
		{"ice", 5}, -- TODO remove this
		{"liquid-nitrogen", 5, type = "fluid"},
	},
	results = {
		{"cryogenic-science-pack", 1},
		{"nitrogen-gas", 3, type = "fluid"},
	},
	time = 10,
}
Recipe.edit{
	recipe = "quantum-processor",
	ingredients = { -- Originally 1 blue circuit + 1 tungsten carbide + 1 carbon fiber + 1 superconductor + 2 lithium plate + 10 fluoroketone-cold -> 1 quantum processor + 5 fluoroketone-hot.
		{"white-circuit", 1},
		{"tungsten-carbide", 1},
		{"carbon-fiber", 1},
		{"lithium-plate", 2},
		{"liquid-nitrogen", 10, type = "fluid"},
	},
	results = {
		{"quantum-processor", 1},
		{"nitrogen-gas", 5, type = "fluid"},
	},
	time = 10,
}
Recipe.substituteIngredient("foundation", "fluoroketone-cold", "liquid-nitrogen")
Recipe.substituteIngredient("captive-biter-spawner", "fluoroketone-cold", "liquid-nitrogen")
Recipe.substituteIngredient("railgun", "fluoroketone-cold", "liquid-nitrogen")
Recipe.substituteIngredient("railgun-turret", "fluoroketone-cold", "liquid-nitrogen")
-- Edit everywhere else that fluoroketone shows up.
RAW["fusion-generator"]["fusion-generator"].output_fluid_box.filter = "nitrogen-gas"
RAW["fusion-reactor"]["fusion-reactor"].input_fluid_box.filter = "liquid-nitrogen"

Recipe.edit{
	recipe = "ammoniacal-solution-separation",

	-- Change to filtration plant.
	category = "filtration",

	-- Change icons to match other filtration recipes.
	iconsLiteral = {
		{icon = "__LegendarySpaceAge__/graphics/filtration/filter.png", icon_size = 64, scale = 0.4, mipmap_count = 4, shift = {0, 8}},
		{icon = FLUID["ammoniacal-solution"].icon, icon_size = 64, scale = 0.4, mipmap_count = 4, shift = {0, -4}},
	},

	-- Set recipe colors for filtration plant. Recipe already has tints but they're too light-colored I think, prefer deeper blue.
	crafting_machine_tint = {
		primary = FLUID["ammoniacal-solution"].base_color,
		secondary = FLUID["ammoniacal-solution"].flow_color,
		tertiary = FLUID["ammoniacal-solution"].visualization_color,
	},

	-- Clear description.
	localised_description = {"recipe-description.no-description"},

	ingredients = {
		{"ammoniacal-solution", 100},
	},
	results = { -- Originally 50 ammoniacal solution -> 50 ammonia + 5 ice.
		{"ammonia", 100}, -- For some reason this gets forced to one of the 2 outputs of the filtration plant. Not sure why.
		{"dry-gas", 10},
			-- This has 7MJ, for 50s, and costs 0.5 carbon = 0.5 MJ. But it takes 50s, so that's 6.5MJ/50s = 130kW, not terribly significant.
		{"ice", 10},
		-- TODO later add gas ice, etc.
	},
	time = 1,
}
