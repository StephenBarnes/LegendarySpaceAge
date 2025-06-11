--[[ This file creates recipes for neutralizing acids and bases with each other. Including wastewaters.
Recipes follow a regular pattern:
- neutralizing with alkali ash, lye, or alkali wastewater: produces the acid's salt + water + heat + carbon dioxide.
- neutralizing with quicklime, slaked lime, or lime wastewater: produces the acid's salt (reduced quantity) + gypsum + water + heat.
]]

local Const = require("const.chemistry-const")

-- Mapping from all acids and acidic wastewaters to the acid's data.
local allAcids = {}
for name, data in pairs(Const.acids) do
	data.lowercaseName = {"fluid-name.X-acid", {"acid-prefix."..name}}
	allAcids[name.."-acid"] = data
	local wastewaterName = name.."-wastewater"
	if allAcids[wastewaterName] == nil then
		local wastewaterData = copy(data)
		wastewaterData.type = "fluid"
		wastewaterData.lowercaseName = {"fluid-name.X-wastewater", {"acid-prefix."..name}}
		allAcids[wastewaterName] = wastewaterData
	end
end
-- Mapping from all bases and basic wastewaters to the base's data.
local allBases = {}
for name, data in pairs(Const.bases) do
	allBases[name] = data
	local wastewaterName = data.category.."-wastewater"
	if allBases[wastewaterName] == nil then
		local wastewaterData = copy(data)
		wastewaterData.type = "fluid"
		wastewaterData.lowercaseName = {"fluid-name.X-wastewater", {"base-prefix."..data.category}}
		wastewaterData.quantityToNeutralize = wastewaterData.quantityToNeutralize * 5
		allBases[wastewaterName] = wastewaterData
	end
end

local function getResults(baseCategory, acidData)
	local resultSpec = Const.neutralizationResultsByCategory[baseCategory]
	local results = {
		{acidData.saltName, resultSpec.acidSalt},
		{"water", 10},
	}
	if resultSpec.carbonDioxide then
		table.insert(results, {"carbon-dioxide", resultSpec.carbonDioxide})
	end
	if resultSpec.gypsum then
		table.insert(results, {"gypsum", resultSpec.gypsum})
	end
	return results
end

-- Create cross-neutralization recipes.
for acidName, acidData in pairs(allAcids) do
	for baseName, baseData in pairs(allBases) do
		local recipeName = "neutralize-"..acidName.."-"..baseName
		local localisedName = {"recipe-name.neutralize-X-Y", acidData.lowercaseName, baseData.lowercaseName}
		Recipe.make{
			recipe = recipeName,
			copy = "sulfuric-acid-from-gas",
			localised_name = localisedName,
			ingredients = {
				{acidName, 20},
				{baseName, baseData.quantityToNeutralize},
			},
			results = getResults(baseData.category, acidData),
			main_product = "water",
			icons = {acidName, baseName},
			iconArrangement = "crossNeutralization",
			crafting_machine_tint = {
				primary = acidData.acidLiquidColor,
				secondary = baseData.color,
			},
			showResultDetails = false,
		}
	end
end

-- TODO create other recipes, eg alkali wastewater with CO2, or with flue gas.