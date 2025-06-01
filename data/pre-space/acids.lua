--[[ This file makes acid fluids and corresponding salts and gases, as well as recipes for gas->acid and acid-salt shifts.
]]

local acidData = {
	chloric = {
		strength = 5,
		saltName = "chloride-salt",
		gasName = "chlorine-gas",
		acidLightColor = {.969, .427, .384},
		acidLiquidColor = {.878, .349, .314},
		saltColor = {.690, .184, .157},
		gasColor = {.722, .333, .306},
		gasToAcidRecipe = {
			ingredients = {{"chlorine-gas", 10}, {"hydrogen-gas", 5}, {"water", 5}},
			results = {{"chloric-acid", 20}},
			icons = {"exo", "chlorine-gas", "hydrogen-gas", "chloric-acid"},
			iconArrangement = "exoEndo",
		},
	},
	sulfuric = {
		strength = 4,
		saltName = "salt-cake",
		gasName = "sulfur-dioxide",
		acidLightColor = {.996, .859, .310},
		acidLiquidColor = {.996, .859, .310},
		saltColor = {.722, .596, .129},
		gasColor = {.753, .663, .282},
		gasToAcidRecipe = {
			ingredients = {{"sulfur-dioxide", 10}, {"water", 10}},
			results = {{"sulfuric-acid", 20}},
			icons = {"exo", "sulfur-dioxide", "sulfuric-acid"},
			iconArrangement = "exoEndo",
		},
	},
	nitric = {
		strength = 3,
		saltName = "niter",
		gasName = "nox-gas",
		acidLightColor = {.729, .898, .447},
		acidLiquidColor = {.651, .808, .369},
		saltColor = {.475, .620, .204},
		gasColor = {.537, .651, .341},
		gasToAcidRecipe = {
			ingredients = {{"nox-gas", 10}, {"water", 10}},
			results = {{"nitric-acid", 20}},
			icons = {"exo", "nox-gas", "nitric-acid"},
			iconArrangement = "exoEndo",
		},
	},
	fluoric = {
		strength = 2,
		saltName = "fluoride-salt",
		gasName = "fluorine-gas",
		acidLightColor = {.58, .875, .745},
		acidLiquidColor = {.278, .784, .655},
		saltColor = {.133, .596, .475},
		gasColor = {.263, .627, .537},
		gasToAcidRecipe = {
			ingredients = {{"fluorine-gas", 10}, {"water", 10}},
			results = {{"fluoric-acid", 10}, {"oxygen-gas", 10}},
			icons = {"exo", "fluorine-gas", "fluoric-acid", "oxygen-gas"},
			iconArrangement = "exoEndoDoubleProduct",
		},
	},
	phosphoric = {
		strength = 1,
		saltName = "phosphate-salt",
		gasName = "phosphine-gas",
		acidLightColor = {.376, .663, 1},
		acidLiquidColor = {.310, .596, .918},
		saltColor = {.149, .424, .722},
		gasColor = {.024, .294, .831},
		gasToAcidRecipe = {
			ingredients = {{"phosphine-gas", 10}, {"oxygen-gas", 5}, {"water", 5}},
			results = {{"phosphoric-acid", 20}},
			icons = {"exo", "phosphine-gas", "oxygen-gas", "phosphoric-acid"},
			iconArrangement = "exoEndo",
		},
	},
}

local count = 0
for name, data in pairs(acidData) do
	count = count + 1

	-- Create or modify acid fluid.
	local acidName = name.."-acid"
	local acidFluid = FLUID[acidName]
	if acidFluid == nil then
		acidFluid = copy(FLUID["sulfuric-acid"])
		acidFluid.name = acidName
		acidFluid.localised_name = nil
		acidFluid.localised_description = nil
		extend{acidFluid}
		acidFluid = FLUID[acidName]
	end
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
		hidden = false,
		hidden_in_factoriopedia = false,
		hide_from_player_crafting = false,
		localised_name = {"recipe-name.acid-from-gas", {"acid-prefix-cap."..name}},
		crafting_machine_tint = {
			primary = data.acidLiquidColor,
			secondary = data.gasColor,
		},
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
				icons = {exoEndo, otherName.."-acid", data.saltName, otherData.saltName, name.."-acid"},
				iconArrangement = "exoEndo",
				enabled = true, -- TODO tech
				time = 1, -- TODO
				hidden = false,
				hidden_in_factoriopedia = false,
				hide_from_player_crafting = false,
				localised_name = {"recipe-name.acid-salt-shift", {"acid-prefix-cap."..otherName}, {"acid-prefix."..name}},
				crafting_machine_tint = {
					primary = data.acidLiquidColor,
					secondary = otherData.acidLiquidColor,
				},
			}
		end
	end
end