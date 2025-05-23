--[[ Convert stone-furnace and steel-furnace to internally be assembling-machine, so that we can set eg char recipe.
Doing this in data-final-fixes stage, so that other mods are less likely to crash if they want to change these entities.
]]
for _, furnaceName in pairs{"stone-furnace", "steel-furnace", "ff-furnace", "electric-furnace"} do
	local furnace = FURNACE[furnaceName]
	furnace.type = "assembling-machine"
	extend{furnace}
	FURNACE[furnaceName] = nil
end

-- Edit pollution to be zero for steel/ff furnaces.
for _, furnaceName in pairs{"steel-furnace", "ff-furnace"} do
	local furnace = ASSEMBLER[furnaceName]
	furnace.energy_source.emissions_per_minute = {}
end

-- Give fluid input and output to canonical "stone-furnace", for Factoriopedia.
local stoneFurnace = ASSEMBLER["stone-furnace"]
stoneFurnace.fluid_boxes = {
	{
		production_type = "input",
		pipe_picture = nil,
		pipe_covers = nil,
		pipe_connections = {
			{
				flow_direction = "input",
				position = {0.5, 0.5},
				direction = SOUTH,
			}
		},
		volume = 100,
	},
	{
		production_type = "output",
		pipe_picture = nil,
		pipe_covers = nil,
		pipe_connections = {
			{
				flow_direction = "output",
				position = {-0.5, 0.5},
				direction = NORTH,
			}
		},
		volume = 100,
	}
}

-- Create alternate versions of the furnaces for planets with and without air in the atmosphere.
for _, furnaceName in pairs{"stone-furnace", "steel-furnace", "ff-furnace"} do
	local furnace = ASSEMBLER[furnaceName]
	for _, suffix in pairs{"-noair", "-air"} do
		local newFurnace = copy(furnace)
		newFurnace.name = newFurnace.name..suffix
		newFurnace.localised_name = {"entity-name."..furnace.name}
		newFurnace.localised_description = {"entity-description."..furnace.name}
		newFurnace.hidden_in_factoriopedia = true
		newFurnace.hidden = true
		newFurnace.factoriopedia_alternative = furnace.name
		newFurnace.placeable_by = {item = furnace.name, count = 1}
		newFurnace.minable.result = furnace.name
		if furnaceName == "stone-furnace" then
			newFurnace.energy_source.emissions_per_minute = {pollution = 1} -- This gets multiplied by the emissions multiplier for the specific vented gas.
		else
			newFurnace.energy_source.emissions_per_minute = {}
		end
		newFurnace.crafting_categories = {}
		extend{newFurnace}
	end
end

-- Remove fluid output from non-canonical stone furnaces.
for _, furnaceName in pairs{"stone-furnace-noair", "stone-furnace-air"} do
	local furnace = ASSEMBLER[furnaceName]
	furnace.fluid_boxes = {furnace.fluid_boxes[1]}
end


--[[ Create recipe variants for the furnaces, with inputs/outputs changed.
Two reasons:
* Stone furnaces automatically vent their output gases, while steel/ff furnaces output them.
* On Nauvis/Gleba, we get air for free (but not oxygen), so we remove that input.

Given a recipe for furnaces, with gas input (air or oxygen) and gas outputs (flue gas etc), we want these recipes:
* If the input gas is air:
	* "Canonical" recipe with air input and gas output, shown in Factoriopedia. Used for steel/ff furnace on planets without air.
	* Recipe with air input removed, and gas output, used for steel/ff furnace on planets with air.
	* Recipe with air input removed, and gas output removed, used for stone furnaces on planets with air.
	* Recipe with air input, and gas output removed, used for stone furnaces on planets without air.
* If the input gas is oxygen:
	* "Canonical" recipe with oxygen input and gas output, shown in Factoriopedia. Used for steel/ff furnace on all planets.
	* Recipe with oxygen input, and gas output removed, used for stone furnaces on all planets.

Our recipe categories are:
* smelting -- This is the vanilla category. Given to canonical recipes with air or oxygen input in the rest of the mod, then this file handles changing crafting category and making variants.
* smelting-ox-output -- for canonical recipes with oxygen input, gas output. (Crafted in steel/ff furnace, with or without air.)
* smelting-air-output -- for canonical recipes that both input and output gases. (Crafted in steel/ff furnace no-air.)
* smelting-freeair-output -- for variant removing air input, and still having gas output. (Crafted in steel/ff furnace with free air.)
* smelting-ox-vent -- for variant removing gas output, and still having oxygen input. (Crafted in stone furnace, with or without air.)
* smelting-air-vent -- for variant removing gas output, and still having air input. (Crafted in stone furnace no-air.)
* smelting-freeair-vent -- for variant removing air input and gas output. (Crafted in stone furnace with free air.)
]]

-- Create recipe categories and assign to furnace variants. Also assigning some to canonical furnaces for Factoriopedia.
for categoryName, furnaceNames in pairs{
	["smelting-ox-output"] = {"steel-furnace-air", "ff-furnace-air", "steel-furnace-noair", "ff-furnace-noair"},
	["smelting-air-output"] = {"steel-furnace-noair", "ff-furnace-noair"},
	["smelting-freeair-output"] = {"steel-furnace-air", "ff-furnace-air"},
	["smelting-ox-vent"] = {"stone-furnace-air", "stone-furnace-noair"},
	["smelting-air-vent"] = {"stone-furnace-noair"},
	["smelting-freeair-vent"] = {"stone-furnace-air"},
} do
	extend{{
		type = "recipe-category",
		name = categoryName,
	}}
	for _, furnaceName in pairs(furnaceNames) do
		table.insert(ASSEMBLER[furnaceName].crafting_categories, categoryName)
	end
	-- Add categories to all canonical furnaces too.
	for _, canonicalName in pairs{"stone-furnace", "steel-furnace", "ff-furnace"} do
		table.insert(ASSEMBLER[canonicalName].crafting_categories, categoryName)
	end
end

local VentableConst = require("const.ventable-const")
local function getFluidEmissionsMultiplier(fluidName)
	local ventable = VentableConst[fluidName]
	if ventable == nil then
		log("Warning: fluid "..fluidName.." not found in ventable-const, assuming emissions multiplier 0.")
		return 0
	end
	return ventable[1]
end

---@param recipe data.RecipePrototype
---@param variantName "ox-output"|"air-output"|"freeair-output"|"ox-vent"|"air-vent"|"freeair-vent"
---@param removeInput string?
---@param removeOutput string?
local function createSmeltingVariant(recipe, variantName, removeInput, removeOutput)
	local newRecipe = copy(recipe)
	newRecipe.name = recipe.name .. "-" .. variantName
	newRecipe.category = "smelting-" .. variantName

	if newRecipe.localised_name == nil then
		newRecipe.localised_name = {"recipe-name."..recipe.name}
	end
	if newRecipe.localised_description == nil then
		newRecipe.localised_description = {"recipe-description."..recipe.name}
		-- TODO add note to localised_description about vented gas and free air, if applicable.
	end

	newRecipe.hidden = false
	newRecipe.hidden_in_factoriopedia = true
	newRecipe.factoriopedia_alternative = recipe.name
	newRecipe.hide_from_player_crafting = true
	newRecipe.hide_from_signal_gui = true
		-- TODO think about how this works with signals. Might have to show it.

	-- TODO icons. Especially if we add it to signal gui.

	if removeInput ~= nil then
		Recipe.removeIngredient(newRecipe, removeInput)
	end
	if removeOutput ~= nil then
		local removed = Recipe.removeResult(newRecipe, removeOutput)
		assert(removed ~= nil)
		local fluidEmissionsMult = getFluidEmissionsMultiplier(removeOutput) * removed.amount / 100
		newRecipe.emissions_multiplier = fluidEmissionsMult
	end
	extend{newRecipe}
end

---@param recipe data.RecipePrototype
local function handleSmeltingRecipe(recipe)
	local hasAirInput = Recipe.getIngredient(recipe, "air") ~= nil
	local hasOxygenInput = Recipe.getIngredient(recipe, "oxygen") ~= nil
	local gasOutput = Recipe.getFluidOutput(recipe)
	if hasAirInput and hasOxygenInput then
		log("Warning: smelting recipe "..recipe.name.." has both air and oxygen input, skipping variant creation.")
		return
	end
	if not hasAirInput and not hasOxygenInput then
		log("Warning: smelting recipe "..recipe.name.." has no air or oxygen input, skipping variant creation.")
		return
	end
	if recipe.emissions_multiplier ~= 0 then
		log("Warning: smelting recipe "..recipe.name.." shouldn't have emissions multiplier, since gas is captured.")
	end

	if hasOxygenInput then
		if gasOutput == nil then
			log("Warning: smelting recipe "..recipe.name.." has oxygen input but no gas output, skipping variant creation.")
			return
		end
		createSmeltingVariant(recipe, "ox-output", nil, nil)
		createSmeltingVariant(recipe, "ox-vent", nil, gasOutput.name)
	elseif hasAirInput then
		if gasOutput == nil then
			log("Warning: smelting recipe "..recipe.name.." has air input but no gas output, skipping variant creation.")
			return
		end
		createSmeltingVariant(recipe, "air-output", nil, nil)
		createSmeltingVariant(recipe, "air-vent", nil, gasOutput.name)
		createSmeltingVariant(recipe, "freeair-output", "air", nil)
		createSmeltingVariant(recipe, "freeair-vent", "air", gasOutput.name)
	end
end

for _, recipe in pairs(RECIPE) do
	if recipe.category == "smelting" then
		handleSmeltingRecipe(recipe)
	end
end


-- TODO add recipe variants for heating too, with oxygen or air input and CO2 or flue gas output.
-- TODO