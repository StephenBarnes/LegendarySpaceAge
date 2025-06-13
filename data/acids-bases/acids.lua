--[[ This file makes acid fluids and corresponding salts and gases, as well as recipes for gas->acid and acid-salt shifts.
Note that this mod deliberately conflates sodium and potassium in many items/fluids, because they have almost the same sources and uses, and conflating them reduces the number of items/recipes we need.
There are 5 acids, each with a corresponding salt and gas.
Namely, from strongest to weakest:
* "Chloric acid" (hydrochloric acid) - "chloride salt" (sodium/potassium chloride) - "chlorine gas"
* "Sulfuric acid" (sulfuric acid) - "salt cake" (sodium/potassium sulfate) - "sulfur gas" (sulfur dioxide)
* "Nitric acid" (nitric acid) - "niter" (sodium/potassium nitrate) - "nox gas"
* "Fluoric acid" (hydrofluoric acid) - "fluoride salt" - "fluorine gas"
* "Phosphoric acid" (phosphoric acid) - "phosphate salt" - "phosphine gas"

Recipes:
* Acid from gas: gas + water + optional extra ingredient -> acid + optional extra product + heat.
* Acid-salt shift: acid A + salt B -> acid B + salt A.
	This is exo/endothermic depending on relative strengths of the acids.
	The intention of this (besides realism) is to create multiple options for players. The recipe converts an acid to salt, and in parallel converts a different salt to its acid. So if you want to e.g. use nitric acid to make niter for gunpowder, you can choose which other salt to turn into its acid. And you can do interesting things like building a circuit system that automatically switches between options for that second parallel salt->acid recipe.
	This is inspired by real chemistry, but fairly unrealistic - for most of these pairs you can't do these reactions IRL by just adding/removing heat, and the reaction won't go to completion.
* TODO more?
]]

local acidData = require("const.chemistry-const").acids

local count = 0
for name, data in pairs(acidData) do
	count = count + 1

	-- Create or modify acid fluid.
	local acidName = name.."-acid"
	local acidFluid = FLUID[acidName]
	if acidFluid == nil then
		acidFluid = copy(FLUID["sulfuric-acid"])
		acidFluid.name = acidName
		extend{acidFluid}
		acidFluid = FLUID[acidName]
	end
	acidFluid.localised_name = {"fluid-name.X-acid", {"acid-prefix-cap."..name}}
	acidFluid.localised_description = nil
	acidFluid.base_color = data.acidLiquidColor
	acidFluid.visualization_color = data.acidLiquidColor
	acidFluid.flow_color = {1, 1, 1}
	Icon.set(acidFluid, {{"LSA/fluids/tintable-drop/tintable-drop", tint = data.acidLiquidColor}, "LSA/fluids/tintable-drop/overlay-reflection"}, "overlay")

	-- Create or modify salt item.
	local saltName = data.saltName
	local saltItem = ITEM[saltName]
	if saltItem == nil then
		saltItem = copy(ITEM.sulfur)
		saltItem.name = saltName
		saltItem.localised_name = nil
		saltItem.localised_description = nil
		extend{saltItem}
		saltItem = ITEM[saltName]
	end
	Icon.set(saltItem, {{"LSA/salt/" .. count, tint = data.saltColor}}) -- Use different variant as primary icon for each salt.
	Icon.variants(saltItem, "LSA/salt/%", 5)

	-- Create or modify gas.
	local gasName = data.gasName
	local gasFluid = FLUID[gasName]
	if gasFluid == nil then
		gasFluid = copy(FLUID.steam)
		gasFluid.name = gasName
		gasFluid.localised_name = nil
		gasFluid.localised_description = nil
		Fluid.setSimpleTemp(gasFluid, 0, false)
		extend{gasFluid}
		gasFluid = FLUID[gasName]
	end
	gasFluid.base_color = data.gasColor
	gasFluid.visualization_color = data.gasColor
	gasFluid.flow_color = {1, 1, 1}
	gasFluid.auto_barrel = true
	Icon.set(gasFluid, {{"LSA/fluids/gas-3", tint = data.gasColor}})
end

-- TODO check crafting machine tints.

-- Create gas-to-acid recipes.
for name, data in pairs(acidData) do
	Recipe.make{
		recipe = name.."-acid-from-gas",
		copy = "sulfuric-acid",
		ingredients = data.gasToAcidRecipe.ingredients,
		results = data.gasToAcidRecipe.results,
		time = 1,
		main_product = name.."-acid",
		category = "chemistry", -- TODO exo category
		icons = data.gasToAcidRecipe.icons,
		iconArrangement = data.gasToAcidRecipe.iconArrangement,
		enabled = true, -- TODO tech
		unhide = true,
		localised_name = {"recipe-name.acid-from-gas", {"acid-prefix-cap."..name}},
		crafting_machine_tint = {
			primary = data.acidLiquidColor,
			secondary = data.gasColor,
		},
		showResultDetails = false,
	}
end

-- Create recipes for acid-salt shifts.
for name, data in pairs(acidData) do
	for otherName, otherData in pairs(acidData) do
		if otherName ~= name then
			local recipeName = "acid-salt-shift-"..name.."-"..otherName
			local exoEndo = Gen.ifThenElse(data.strength > otherData.strength, "exo", "endo")
			Recipe.make{
				recipe = recipeName,
				copy = "sulfuric-acid",
				ingredients = {
					{otherName.."-acid", 10},
					{data.saltName, 1},
				},
				results = {
					{name.."-acid", 10},
					{otherData.saltName, 1},
					--{data.gasName, 5},
				},
				main_product = name.."-acid",
				category = "chemistry", -- TODO exo/endo category
				icons = {otherName.."-acid", data.saltName, otherData.saltName, name.."-acid"},
				iconArrangement = exoEndo,
				enabled = true, -- TODO tech
				time = 1, -- TODO
				unhide = true,
				hide_from_player_crafting = false,
				localised_name = {"recipe-name.acid-salt-shift", {"acid-prefix-cap."..otherName}, {"acid-prefix."..name}},
				crafting_machine_tint = {
					primary = data.acidLiquidColor,
					secondary = otherData.acidLiquidColor,
				},
				showResultDetails = false,
			}
		end
	end
end