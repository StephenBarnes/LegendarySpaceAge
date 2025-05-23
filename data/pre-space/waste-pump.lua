-- This file makes the waste pump, used to dump waste fluids into lakes.

---@type data.FurnacePrototype
---@diagnostic disable-next-line: assign-type-mismatch
local wastePump = copy(RAW["offshore-pump"]["offshore-pump"])
wastePump.type = "furnace"
wastePump.name = "waste-pump"
wastePump.crafting_categories = {"waste-pump"}
wastePump.crafting_speed = 1
wastePump.source_inventory_size = 0
wastePump.result_inventory_size = 0
wastePump.energy_source = copy(RAW.pump.pump.energy_source)
wastePump.energy_source.emissions_per_minute = {pollution = 1, spores = 1} -- This gets multiplied by the emissions multiplier for the specific venting recipe.
wastePump.energy_source.drain = "0W"
wastePump.energy_usage = "50kW"
wastePump.heating_energy = "50kW"
wastePump.minable.result = "waste-pump"
wastePump.placeable_by = {item = "waste-pump", count = 1}
wastePump.show_recipe_icon = true -- Just so player can distinguish them from the non-waste pumps.
wastePump.icon = nil
wastePump.icons = {
	{icon = "__base__/graphics/icons/offshore-pump.png", icon_size = 64, scale = 0.5},
	{icon = "__LegendarySpaceAge__/graphics/misc/no.png", icon_size = 64, scale = 0.25, shift = {-8, 8}},
}
wastePump.fluid_boxes = {
	{
		production_type = "input",
		pipe_covers = pipecoverspictures(),
		base_area = 1,
		base_level = -1,
		volume = 2400,
		pipe_connections = {
			{position = {0, 0}, flow_direction = "input", direction = SOUTH},
		},
	},
}
wastePump.surface_conditions = nil
wastePump.hidden_in_factoriopedia = false
-- Now the colored bars shown in the pump (showing the fluid pumped) are gone. Those are offshorePump.graphics_set.fluid_animation, but for furnace we need furnace.graphics_set.working_visualisations.
local workingVis = {
	apply_recipe_tint = "primary", -- So it's tinted for the fluid, see recipes below.
}
for _, dir in pairs{"north", "east", "south", "west"} do
	---@diagnostic disable-next-line: undefined-field
	local fluidAnimation = wastePump.graphics_set.fluid_animation[dir]
	-- Also make animations run backwards. I think the waste pump looks more like it's pumping into the lake if animations are reversed.
	fluidAnimation.run_mode = "backward"
	workingVis[dir .. "_animation"] = fluidAnimation
end
wastePump.graphics_set.working_visualisations = {workingVis}
-- Also make the main animations run backwards, not just the fluid but also the plunger.
for _, dir in pairs(wastePump.graphics_set.animation) do
	for _, layer in pairs(dir.layers) do
		layer.run_mode = "backward"
	end
end
extend{wastePump}

-- Create recipe.
local wastePumpRecipe = copy(RECIPE["pump"])
wastePumpRecipe.name = "waste-pump"
wastePumpRecipe.results = {{type = "item", name = "waste-pump", amount = 1}}
wastePumpRecipe.ingredients = copy(RECIPE["offshore-pump"].ingredients)
extend{wastePumpRecipe}

-- Create item.
local wastePumpItem = copy(ITEM["pump"])
wastePumpItem.name = "waste-pump"
wastePumpItem.place_result = "waste-pump"
wastePumpItem.icon = nil
wastePumpItem.icons = {
	{icon = "__base__/graphics/icons/offshore-pump.png", icon_size = 64, scale = 0.5},
	{icon = "__LegendarySpaceAge__/graphics/misc/no.png", icon_size = 64, scale = 0.25, shift = {-8, 8}},
}
extend{wastePumpItem}

-- Recipes for venting will be created in vent-recipes.lua.

-- Will add to tech in tech-progression.lua.