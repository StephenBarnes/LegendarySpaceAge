--[[ This file has consts for chemistry stuff.
Currently only acids. Might add bases too later.
]]

local Export = {}

Export.acids = {
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
			icons = {"chlorine-gas", "hydrogen-gas", "chloric-acid"},
			iconArrangement = "exo",
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
			icons = {"sulfur-dioxide", "sulfuric-acid"},
			iconArrangement = "exo",
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
			icons = {"nox-gas", "nitric-acid"},
			iconArrangement = "exo",
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
			icons = {"fluorine-gas", "fluoric-acid", "oxygen-gas"},
			iconArrangement = "exoDoubleProduct",
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
			icons = {"phosphine-gas", "oxygen-gas", "phosphoric-acid"},
			iconArrangement = "exo",
		},
	},
}

Export.baseWastewaters = {
	lime = {
		color = {0.322, 0.298, 0.773},
		darkerColor = {0.208, 0.188, 0.557},
	},
	alkali = {
		color = {0.588, 0.271, 0.800},
		darkerColor = {0.420, 0.169, 0.584},
	},
}

---@type table<string, {type: "item" | "fluid", quantityToNeutralize: number, category: string, color: Color, lowercaseName: LocalisedString}>
Export.bases = {
	["alkali-ash"] = {
		type = "item",
		quantityToNeutralize = 1,
		category = "alkali",
		color = {0.420, 0.169, 0.584},
		lowercaseName = {"item-name.alkali-ash-lowercase"},
	},
	["slaked-lime"] = {
		type = "item",
		quantityToNeutralize = 2,
		category = "lime",
		color = {0.322, 0.298, 0.773},
		lowercaseName = {"item-name.slaked-lime-lowercase"},
	},
	["quicklime"] = {
		type = "item",
		quantityToNeutralize = 1,
		category = "lime",
		color = {0.208, 0.188, 0.557},
		lowercaseName = {"item-name.quicklime-lowercase"},
	},
	["lye"] = {
		type = "fluid",
		quantityToNeutralize = 5,
		category = "alkali",
		color = {0.518, 0.196, 0.459},
		lowercaseName = {"fluid-name.lye-lowercase"},
	},
}

---@type table<string, {acidSalt: number, gypsum: number, carbonDioxide: number}>
Export.neutralizationResultsByCategory = {
	lime = {
		acidSalt = 1,
		gypsum = 1,
	},
	alkali = {
		acidSalt = 2,
		carbonDioxide = 10,
	},
}

return Export