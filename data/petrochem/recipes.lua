--[[ Create fractionation recipes.
Fractionation recipes turn crude oil and natural gas into the 4 fractions: heavy oil, light oil, rich gas, dry gas.
	Oil fractionation: 10 crude oil + 2 steam -> 1 tar + 4 heavy oil + 5 light oil + 1 water + 2 sulfur + 2 carbon
	Gas fractionation: 10 natural gas + 2 steam -> 5 rich gas + 5 dry gas + 1 water + 1 sulfur
	]]
local oilFractionationRecipe = copy(RECIPE["advanced-oil-processing"])
oilFractionationRecipe.name = "oil-fractionation"
oilFractionationRecipe.ingredients = {
	{type = "fluid", name = "crude-oil", amount = 100},
	{type = "fluid", name = "steam", amount = 20},
}
oilFractionationRecipe.results = {
	{type = "fluid", name = "tar", amount = 10, show_details_in_recipe_tooltip = false},
	{type = "fluid", name = "heavy-oil", amount = 40, show_details_in_recipe_tooltip = false},
	{type = "fluid", name = "light-oil", amount = 50, show_details_in_recipe_tooltip = false},
	{type = "fluid", name = "water", amount = 1, ignored_by_productivity = 1, show_details_in_recipe_tooltip = false}, -- Game has water 10x denser than steam. So this gives half the steam back as water.
	{type = "item", name = "sulfur", amount = 2, show_details_in_recipe_tooltip = false},
	{type = "item", name = "carbon", amount = 2, show_details_in_recipe_tooltip = false},
}
Icon.set(oilFractionationRecipe, {"crude-oil", "heavy-oil", "light-oil"}, "decomposition")
oilFractionationRecipe.order = "a[oil-processing]-b1"
oilFractionationRecipe.allow_quality = true
oilFractionationRecipe.allow_productivity = true
extend{oilFractionationRecipe}

local gasFractionationRecipe = copy(RECIPE["advanced-oil-processing"])
gasFractionationRecipe.name = "gas-fractionation"
gasFractionationRecipe.ingredients = {
	{type = "fluid", name = "natural-gas", amount = 100},
	{type = "fluid", name = "steam", amount = 20},
}
gasFractionationRecipe.results = {
	{type = "fluid", name = "petroleum-gas", amount = 50, show_details_in_recipe_tooltip = false},
	{type = "fluid", name = "dry-gas", amount = 50, show_details_in_recipe_tooltip = false},
	{type = "fluid", name = "water", amount = 1, ignored_by_productivity = 1, show_details_in_recipe_tooltip = false},
	{type = "item", name = "sulfur", amount = 1, show_details_in_recipe_tooltip = false},
}
Icon.set(gasFractionationRecipe, {"natural-gas", "petroleum-gas", "dry-gas"}, "decomposition")
gasFractionationRecipe.order = "a[oil-processing]-b2"
gasFractionationRecipe.allow_quality = true
gasFractionationRecipe.allow_productivity = true
extend{gasFractionationRecipe}

--[[ Edit existing cracking recipes, and add the new one.
	100 heavy oil + 100 steam -> 100 light oil + 1 carbon + 1 sulfur
	100 light oil + 100 steam -> 100 rich gas + 1 sulfur
	100 rich gas + 100 steam -> 100 dry gas
]]
local heavyOilCrackingRecipe = RECIPE["heavy-oil-cracking"]
heavyOilCrackingRecipe.ingredients = {
	{type = "fluid", name = "heavy-oil", amount = 100},
	{type = "fluid", name = "steam", amount = 50},
}
heavyOilCrackingRecipe.results = {
	{type = "fluid", name = "light-oil", amount = 100, show_details_in_recipe_tooltip = false},
	{type = "item", name = "carbon", amount = 1, show_details_in_recipe_tooltip = false},
	{type = "item", name = "sulfur", amount = 1, show_details_in_recipe_tooltip = false},
}
heavyOilCrackingRecipe.category = "chemistry"
Icon.set(heavyOilCrackingRecipe, {"heavy-oil", "light-oil", "light-oil"}, "decomposition")

local lightOilCrackingRecipe = RECIPE["light-oil-cracking"]
lightOilCrackingRecipe.ingredients = {
	{type = "fluid", name = "light-oil", amount = 100},
	{type = "fluid", name = "steam", amount = 50},
}
lightOilCrackingRecipe.results = {
	{type = "fluid", name = "petroleum-gas", amount = 100, show_details_in_recipe_tooltip = false},
	{type = "item", name = "sulfur", amount = 1, show_details_in_recipe_tooltip = false},
}
lightOilCrackingRecipe.category = "chemistry"
Icon.set(lightOilCrackingRecipe, {"light-oil", "petroleum-gas", "petroleum-gas"}, "decomposition")
local richGasCrackingRecipe = copy(RECIPE["light-oil-cracking"])
richGasCrackingRecipe.name = "rich-gas-cracking"
richGasCrackingRecipe.ingredients = {
	{type = "fluid", name = "petroleum-gas", amount = 100},
	{type = "fluid", name = "steam", amount = 50},
}
richGasCrackingRecipe.results = {
	{type = "fluid", name = "dry-gas", amount = 100, show_details_in_recipe_tooltip = false},
}
richGasCrackingRecipe.category = "chemistry"
Icon.set(richGasCrackingRecipe, {"petroleum-gas", "dry-gas", "dry-gas"}, "decomposition")
extend{richGasCrackingRecipe}

--[[ Add recipe for tar distillation.
	Tar distillation: 10 tar -> 3 pitch + 2 heavy oil + 1 light oil + 2 carbon + 1 sulfur
		(No steam input because we want this to be usable on Fulgora for pitch, to make resin.)
]]
local tarDistillationRecipe = copy(RECIPE["advanced-oil-processing"])
tarDistillationRecipe.name = "tar-distillation"
tarDistillationRecipe.ingredients = {
	{type = "fluid", name = "tar", amount = 100},
}
tarDistillationRecipe.results = {
	{type = "item", name = "pitch", amount = 2, show_details_in_recipe_tooltip = false},
	--{type = "item", name = "carbon", amount = 2},
	{type = "item", name = "sulfur", amount = 1, show_details_in_recipe_tooltip = false},
	{type = "fluid", name = "heavy-oil", amount = 20, show_details_in_recipe_tooltip = false},
	{type = "fluid", name = "light-oil", amount = 10, show_details_in_recipe_tooltip = false},
}
tarDistillationRecipe.energy_required = 5
Icon.set(tarDistillationRecipe, {"tar", "heavy-oil", "light-oil", "pitch"}, "decomposition")
tarDistillationRecipe.order = "a[oil-processing]-b5"
tarDistillationRecipe.subgroup = "complex-fluid-recipes"
tarDistillationRecipe.allow_productivity = true
tarDistillationRecipe.maximum_productivity = 2
tarDistillationRecipe.allow_quality = true
extend{tarDistillationRecipe}

--[[ Add recipe for heavy oil coking.
	Heavy oil coking: 10 heavy oil -> 5 tar + 3 carbon
		If you intend to burn the heavy oil, you can get more heat by coking first and then burning the tar and carbon. (This is realistic, and rewards the player for the extra complexity.)
		This recipe is also useful when the player needs more tar or carbon - usually those are byproducts.
]]
local heavyOilCokingRecipe = copy(RECIPE["heavy-oil-cracking"])
heavyOilCokingRecipe.name = "heavy-oil-coking"
heavyOilCokingRecipe.ingredients = {
	{type = "fluid", name = "heavy-oil", amount = 100},
}
heavyOilCokingRecipe.results = {
	{type = "item", name = "carbon", amount = 2, show_details_in_recipe_tooltip = false},
	{type = "fluid", name = "tar", amount = 20, show_details_in_recipe_tooltip = false},
}
Icon.set(heavyOilCokingRecipe, {"heavy-oil", "carbon", "tar"}, "decomposition")
heavyOilCokingRecipe.order = "a[oil-processing]-b4"
heavyOilCokingRecipe.subgroup = "complex-fluid-recipes"
heavyOilCokingRecipe.energy_required = 5
heavyOilCokingRecipe.allow_productivity = true
heavyOilCokingRecipe.maximum_productivity = 1
extend{heavyOilCokingRecipe}

-- Add recipe for pitch processing: 10 pitch + 50 steam -> 10 heavy oil + 10 light oil + 10 tar + 1 carbon
local pitchProcessingRecipe = copy(heavyOilCokingRecipe)
pitchProcessingRecipe.name = "pitch-processing"
pitchProcessingRecipe.ingredients = {
	{type = "item", name = "pitch", amount = 10},
	{type = "fluid", name = "steam", amount = 50},
}
pitchProcessingRecipe.results = {
	{ type = "fluid", name = "tar",       amount = 10, show_details_in_recipe_tooltip = false },
	{ type = "fluid", name = "heavy-oil", amount = 20, show_details_in_recipe_tooltip = false },
	{ type = "fluid", name = "light-oil", amount = 10, show_details_in_recipe_tooltip = false },
}
Icon.set(pitchProcessingRecipe, {"pitch", "tar", "light-oil", "heavy-oil"}, "decomposition")
pitchProcessingRecipe.order = "a[oil-processing]-b6"
pitchProcessingRecipe.subgroup = "complex-fluid-recipes"
pitchProcessingRecipe.category = "oil-processing" -- Refinery.
pitchProcessingRecipe.auto_recycle = false
extend{pitchProcessingRecipe}

--[[ Add recipe for coal coking.
	Coal coking: 10 coal -> 6 carbon + 1 sulfur
		This offers a route from coal to carbon that's more direct than syngas liquefaction.
		For realism, this should slightly reduce total fuel energy.
			But I'm rather making it slightly energy-positive but only if you burn the sulfur, since that's more interesting.
				Options are now:
					burn the coal
					coke the coal, burn the carbon, dump the sulfur - needs more machines and dump route, creates less pollution, same energy minus assemblers
					coke the coal, burn the carbon, burn the sulfur - needs machines, creates more pollution, gives more energy
]]
local coalCokingRecipe = copy(RECIPE["heavy-oil-cracking"])
coalCokingRecipe.name = "coal-coking"
coalCokingRecipe.ingredients = {
	{type = "item", name = "coal", amount = 2},
}
coalCokingRecipe.results = {
	{type = "item", name = "carbon", amount = 2},
	{type = "item", name = "sulfur", amount = 1},
	{type = "item", name = "pitch", amount = 1},
	--{type = "fluid", name = "tar", amount = 20}, -- Removed bc the player has no way to handle fluid waste yet, except waste pump I guess.
}
Icon.set(coalCokingRecipe, {"coal", "pitch", "sulfur", "carbon"}, "decomposition")
coalCokingRecipe.order = "a[oil-processing]-b3"
coalCokingRecipe.subgroup = "complex-fluid-recipes"
coalCokingRecipe.category = "chemistry"
coalCokingRecipe.allow_productivity = true
coalCokingRecipe.allow_quality = true
coalCokingRecipe.energy_required = 1
coalCokingRecipe.enabled = false -- Unlocked by coal-coking tech, created in another file.
extend{coalCokingRecipe}

--[[ Add recipe for solid fuel.
	20 heavy oil + 10 tar -> 1 solid fuel + 10 light oil
		This represents pet coke style briquettes. We tune the energy values so that this gives more heat per heavy oil than other forms of processing.
	Currently 10MJ + 2MJ -> 12MJ + 3.5MJ, so on net this increases energy.
]]
local solidFuelRecipe = copy(RECIPE["solid-fuel-from-light-oil"])
solidFuelRecipe.name = "solid-fuel"
solidFuelRecipe.ingredients = {
	{type = "fluid", name = "heavy-oil", amount = 20},
	{type = "fluid", name = "tar", amount = 10},
}
solidFuelRecipe.results = {
	{type = "item", name = "solid-fuel", amount = 1},
	{type = "fluid", name = "light-oil", amount = 5},
}
solidFuelRecipe.main_product = "solid-fuel"
Icon.clear(solidFuelRecipe)
solidFuelRecipe.energy_required = 1
solidFuelRecipe.hide_from_player_crafting = false
extend{solidFuelRecipe}

--[[ Add syngas liquefaction.
	10 syngas + 1 iron plate -> 5 heavy oil + 5 light oil + 1 water
		Named "syngas liquefaction" partly for the benefit of players already familiar with "coal liquefaction" in the base game, since this effectively replaces coal liquefaction.
]]
local syngasLiquefactionRecipe = copy(RECIPE["coal-liquefaction"])
syngasLiquefactionRecipe.name = "syngas-liquefaction"
syngasLiquefactionRecipe.ingredients = {
	{type = "fluid", name = "syngas", amount = 100},
	{type = "item", name = "iron-plate", amount = 1},
}
syngasLiquefactionRecipe.results = {
	{ type = "fluid", name = "heavy-oil",     amount = 5, show_details_in_recipe_tooltip = false },
	{ type = "fluid", name = "light-oil",     amount = 20, show_details_in_recipe_tooltip = false },
	{ type = "fluid", name = "water",         amount = 1,  show_details_in_recipe_tooltip = false },
}
Icon.set(syngasLiquefactionRecipe, {"syngas", "heavy-oil", "light-oil"}, "decomposition")
syngasLiquefactionRecipe.allow_productivity = false
syngasLiquefactionRecipe.order = "a[coal-liquefaction]-b4"
syngasLiquefactionRecipe.subgroup = "complex-fluid-recipes"
extend{syngasLiquefactionRecipe}

--[[ Modify recipe for lubricant
	10 heavy oil + 1 sulfuric acid -> 8 lubricant + 1 tar
		Meant to resemble vacuum distillation - heavy oil is distilled, sulfuric acid is used for acid-washing impurities.
]]
local lubricantRecipe = RECIPE["lubricant"]
lubricantRecipe.ingredients = {
	{ type = "fluid", name = "heavy-oil",     amount = 100 },
	{ type = "fluid", name = "sulfuric-acid", amount = 10 },
}
lubricantRecipe.results = {
	{ type = "fluid", name = "lubricant", amount = 100 },
	{ type = "fluid", name = "tar",       amount = 10 },
}
lubricantRecipe.main_product = "lubricant"

--[[ Modify recipe for plastic-bar.
	20 syngas + 1 carbon + 5 sulfuric acid ---1s--> 1 plastic bar.
		Syngas provides hydrogen, carbon is the backbone, and sulfuric acid helps drive polymerization.
	Vanilla was 20 petroleum gas + 1 coal ---1s--> 2 plastic bars.
		Compared to that, it's more expensive. But also you don't need as much plastic.
]]
Recipe.edit{
	recipe = "plastic-bar",
	ingredients = {
		{"carbon", 1},
		{"syngas", 20, type="fluid"},
		{"sulfuric-acid", 5},
	},
	time = 1,
	resultCount = 1,
}

-- Modify recipe for explosives.
local explosivesRecipe = RECIPE["explosives"]
explosivesRecipe.ingredients = {
	{ type = "item",  name = "niter",         amount = 2 },
	{ type = "fluid", name = "ammonia",       amount = 20 },
	{ type = "fluid", name = "light-oil",     amount = 10 },
	{ type = "fluid", name = "sulfuric-acid", amount = 10 },
}
explosivesRecipe.results = {{type = "item", name = "explosives", amount = 2}}

------------------------------------------------------------------------

-- Add new fractionation recipes to techs.
Tech.addRecipeToTech("oil-fractionation", "oil-processing")
Tech.addRecipeToTech("gas-fractionation", "oil-processing")

-- Put all cracking recipes in the first oil tech.
Tech.addRecipeToTech("heavy-oil-cracking", "oil-processing")
Tech.addRecipeToTech("light-oil-cracking", "oil-processing")
Tech.addRecipeToTech("rich-gas-cracking", "oil-processing")
Tech.removeRecipeFromTech("heavy-oil-cracking", "advanced-oil-processing")
Tech.removeRecipeFromTech("light-oil-cracking", "advanced-oil-processing")

-- Solid fuel recipe goes in the first oil tech.
Tech.addRecipeToTech("solid-fuel", "oil-processing")

-- Add heavy oil coking, tar distillation, pitch processing to advanced oil processing.
Tech.addRecipeToTech("heavy-oil-coking", "advanced-oil-processing")
Tech.addRecipeToTech("tar-distillation", "advanced-oil-processing")
Tech.addRecipeToTech("pitch-processing", "advanced-oil-processing")

-- Wood resin recipe will be placed in wood circuit boards tech.
-- Pitch resin and rich-gas resin will be unlocked in a special "petroleum resin" tech, after blue science.

-- Hide old recipes, and remove from techs.
Recipe.hide("basic-oil-processing")
Tech.removeRecipeFromTech("basic-oil-processing", "oil-processing")
Recipe.hide("advanced-oil-processing")
Tech.removeRecipeFromTech("advanced-oil-processing", "advanced-oil-processing")
Recipe.hide("solid-fuel-from-heavy-oil")
Tech.removeRecipeFromTech("solid-fuel-from-heavy-oil", "advanced-oil-processing")
Recipe.hide("solid-fuel-from-light-oil")
Tech.removeRecipeFromTech("solid-fuel-from-light-oil", "advanced-oil-processing")
Recipe.hide("solid-fuel-from-petroleum-gas")
Tech.removeRecipeFromTech("solid-fuel-from-petroleum-gas", "oil-processing")
Recipe.hide("simple-coal-liquefaction")
Tech.removeRecipeFromTech("simple-coal-liquefaction", "calcite-processing")
Recipe.hide("coal-liquefaction")
Tech.removeRecipeFromTech("coal-liquefaction", "coal-liquefaction")
Recipe.hide("acid-neutralisation")
Tech.removeRecipeFromTech("acid-neutralisation", "calcite-processing")
Recipe.hide("coal-synthesis")
Tech.removeRecipeFromTech("coal-synthesis", "rocket-turret")

-- Add syngas liquefaction to tech.
Tech.addRecipeToTech("syngas-liquefaction", "coal-liquefaction")

-- Remove default recipes for carbon, sulfur.
Recipe.hide("sulfur")
Recipe.hide("carbon")
Tech.removeRecipeFromTech("sulfur", "sulfur-processing")
Tech.removeRecipeFromTech("carbon", "tungsten-carbide")

-- Change sulfuric acid recipe to be in raw-material.
Recipe.make{
	copy = "sulfuric-acid",
	recipe = "make-sulfuric-acid",
	subgroup = "raw-material",
}
Recipe.hide("sulfuric-acid")
Tech.removeRecipeFromTech("sulfuric-acid", "sulfur-processing")
Tech.addRecipeToTech("make-sulfuric-acid", "sulfur-processing")

-- Disable prod and quality for all the cracking recipes.
for _, recipeName in pairs{"heavy-oil-cracking", "light-oil-cracking", "rich-gas-cracking"} do
	RECIPE[recipeName].allow_productivity = false
end
RECIPE["heavy-oil-cracking"].allow_quality = true
RECIPE["light-oil-cracking"].allow_quality = true
RECIPE["rich-gas-cracking"].allow_quality = false -- No solid byproducts, so no quality.