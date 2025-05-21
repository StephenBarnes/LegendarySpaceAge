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
wastePump.energy_source.emissions_per_minute = {pollution = 1} -- This gets multiplied by the emissions multiplier for the specific venting recipe.
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

local wastePumpCraftingCategory = copy(RAW["recipe-category"]["crafting"])
wastePumpCraftingCategory.name = "waste-pump"
extend{wastePumpCraftingCategory}

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

-- Create fluid-venting recipes.
local effluentFluidsAndPollution = {
	{"water", 0},
	{"lake-water", 0},
	{"latex", 5},
	{"cement", 0},
	{"sulfuric-acid", 20},
	{"crude-oil", 20},
	{"tar", 30},
	{"heavy-oil", 25},
	{"light-oil", 15},
	{"diesel", 20},
	{"lubricant", 20},
	{"slime", 0},
	{"geoplasm", 5},
	{"chitin-broth", 0},
	{"thruster-fuel", 0}, -- hydrogen
	{"thruster-oxidizer", 0}, -- oxygen
	{"liquid-nitrogen", 0},
	{"lava", 0},
	{"molten-iron", 20},
	{"molten-copper", 20},
	{"molten-steel", 20},
	{"molten-tungsten", 20},
	{"holmium-solution", 0},
	{"fulgoran-sludge", 0},
	{"electrolyte", 0},
	{"ammoniacal-solution", 0},
	{"ammonia", 0},
	{"fluoroketone-hot", 0}, -- TODO remove this later, will replace fluoroketone with refrigerant and liquid nitrogen
	{"fluoroketone-cold", 0}, -- TODO remove this later, will replace fluoroketone with refrigerant and liquid nitrogen
	{"lithium-brine", 0},
	-- TODO check that all liquids are included here.
}
for _, effluentFluidAndPollution in pairs(effluentFluidsAndPollution) do
	local effluentFluid = effluentFluidAndPollution[1]
	local effluentPollution = effluentFluidAndPollution[2]
	local fluid = FLUID[effluentFluid]
	local effluentRecipe = copy(RECIPE["offshore-pump"])
	effluentRecipe.name = "vent-" .. effluentFluid
	effluentRecipe.localised_name = {"recipe-name.waste-pumping", {"fluid-name."..effluentFluid}}
	effluentRecipe.localised_description = {"recipe-description.waste-pumping"}
	effluentRecipe.enabled = true
	effluentRecipe.ingredients = {{type = "fluid", name = effluentFluid, amount = 1000}}
	effluentRecipe.results = {}
	effluentRecipe.energy_required = 1
	effluentRecipe.allow_productivity = false
	effluentRecipe.allow_quality = false
	-- I'm not hiding these recipes - rather show the player eg what pollution mult will be, and keep it as reminder that fluids can be vented.
	effluentRecipe.hidden = false
	effluentRecipe.hidden_in_factoriopedia = false
	effluentRecipe.hide_from_player_crafting = true
	effluentRecipe.emissions_multiplier = effluentPollution
	effluentRecipe.crafting_machine_tint = { -- This is shown on the waste pump graphics.
		primary = fluid.base_color,
	}
	effluentRecipe.category = "waste-pump"

	local fluidIcon
	if fluid.icons then
		fluidIcon = copy(fluid.icons[1])
	else
		fluidIcon = {icon = fluid.icon, icon_size = fluid.icon_size}
	end
	fluidIcon.scale = 0.3
	fluidIcon.shift = {4, -4}
	effluentRecipe.icons = {
		fluidIcon,
		{icon = "__LegendarySpaceAge__/graphics/misc/no.png", icon_size = 64, scale = 0.21, shift = {4, -4}},
		{icon = "__base__/graphics/icons/offshore-pump.png", icon_size = 64, scale = 0.2, shift = {-4, 4}},
	}

	extend{effluentRecipe}
end

-- Will add to tech in tech-progression.lua.