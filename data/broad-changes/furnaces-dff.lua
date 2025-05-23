--[[ Convert stone-furnace and steel-furnace to internally be assembling-machine, so that we can set eg char recipe.
Doing this in data-final-fixes stage, so that other mods are less likely to crash if they want to change these entities.
]]
for _, furnaceName in pairs{"stone-furnace", "steel-furnace", "ff-furnace", "electric-furnace"} do
	local furnace = FURNACE[furnaceName]
	furnace.type = "assembling-machine"
	extend{furnace}
	FURNACE[furnaceName] = nil
end

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
		extend{newFurnace}
	end
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

---@param recipe data.RecipePrototype
---@param variantCategory "smelting-ox-output"|"smelting-air-output"|"smelting-freeair-output"|"smelting-ox-vent"|"smelting-air-vent"|"smelting-freeair-vent"
---@param removeInput string?
---@param removeOutput string?
local function createSmeltingVariant(recipe, variantCategory, removeInput, removeOutput)
	local newRecipe = copy(recipe)
	newRecipe.category = variantCategory
	extend{newRecipe}
end
for recipeName, recipe in pairs(RECIPE) do
	if recipe.category == "smelting" then
		local hasAirInput = Recipe.getIngredient(recipe, "air") ~= nil
		local hasOxygenInput = Recipe.getIngredient(recipe, "oxygen") ~= nil
		local hasGasOutput = Recipe.hasFluidOutput(recipe) ~= nil
		if not hasAirInput and not hasOxygenInput then
			log("Warning: smelting recipe "..recipeName.." has no air or oxygen input, skipping variant creation.")
		elseif hasOxygenInput then
			if not hasGasOutput then
				log("Warning: smelting recipe "..recipeName.." has oxygen input but no gas output, skipping variant creation.")
			else
				--createSmeltingVariant(recipe, 
				-- TODO
			end
		end
	end
end


-- TODO add recipe variants for heating too, with oxygen or air input and CO2 or flue gas output.
-- TODO