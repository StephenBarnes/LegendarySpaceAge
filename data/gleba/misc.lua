-- Change Gleba rocket fuel recipe to require carbon, produced from spoilage.
-- Originally 2 bioflux + 30 jelly + water.
table.insert(RECIPE["rocket-fuel-from-jelly"].ingredients,
	{ type = "item", name = "carbon", amount = 2 })

-- Artificial soil tech makes more sense after biochamber.
Tech.setPrereqs("artificial-soil", {"biochamber"})

-- Artificial soil recipes should be biochamber-only.
for _, recipeName in pairs{"artificial-yumako-soil", "artificial-jellynut-soil", "overgrowth-yumako-soil", "overgrowth-jellynut-soil"} do
	RECIPE[recipeName].category = "organic"
end

-- Double rocket capacity for bioflux
-- Decided against this bc it's already high, don't want to remove the incentive to set up toxophages etc.
--Item.multiplyWeight("bioflux", 0.5, "capsule")

-- Make spoilage spoil to nothing. From testing, you can simply not define spoil result or trigger, and it'll disappear.
ITEM.spoilage.spoil_ticks = 20 * MINUTES

-- Remove stone spawns from Gleba.
RAW.planet.gleba.map_gen_settings.autoplace_settings.entity.settings.stone = nil
RAW["autoplace-control"]["gleba_stone"].hidden = true

--[[ Increase distance to first enemies on Gleba.
-- RAW["noise-expression"]["gleba_enemy_base_frequency"].expression = "(0.000006 * (clamp(distance-5000, 0, 2400) / 325)) * control:gleba_enemy_base:frequency"
That doesn't really work. Maybe rather look at gleba_starting_enemies_safe, gleba_starting_enemies, gleba_starting_area_multiplier.
	Gleba_starting_area_multiplier is by default 0.7.
-- RAW["noise-expression"]["gleba_starting_area_multiplier"].expression = "2"
That doesn't work, makes starting highlands region massive.
Var "gleba_starting_enemies_safe" creates small spawners.
Then "gleba_spawner" creates the bigger spawners. Default: expression = "max(0.01 * gleba_starting_enemies, max(min(0.02, enemy_autoplace_base(0, 8)), min(0.001, gleba_fertile_spots_coastal * 5000 - gleba_biome_mask_green * 25000)) * (distance > 500 * gleba_starting_area_multiplier)) * gleba_above_deep_water_mask"
So, changing this to increase distance to them, by increasing the distance>500 part.
	(Eg if this is 500, then big enemies start spawning at distance 500 * 0.7 = 350. (0.7 is the starting area multiplier.)
	The default of 500 is too close. Setting it to 5000 is too far. Setting it to 1000 is a bit too far. Using 900.
]]
RAW["noise-expression"]["gleba_spawner"].expression = "max(0.01 * gleba_starting_enemies, max(min(0.02, enemy_autoplace_base(0, 8)), min(0.001, gleba_fertile_spots_coastal * 5000 - gleba_biome_mask_green * 25000)) * (distance > 900 * gleba_starting_area_multiplier)) * gleba_above_deep_water_mask"

-- Hide recipe for spoilage-to-carbon.
Recipe.hide("burnt-spoilage")
Tech.removeRecipeFromTech("burnt-spoilage", "biochamber")

-- Hide items and recipes for iron/copper bacteria.
Item.hide("iron-bacteria")
Item.hide("copper-bacteria")
Recipe.hide("iron-bacteria-cultivation")
Recipe.hide("copper-bacteria-cultivation")
Tech.removeRecipeFromTech("iron-bacteria", "jellynut")
Tech.removeRecipeFromTech("copper-bacteria", "yumako")
Recipe.hide("iron-bacteria")
Recipe.hide("copper-bacteria")

-- Change stromatolite products - no bacteria, more ore and stone.
RAW["simple-entity"]["iron-stromatolite"].minable.results = {
	{type = "item", name = "stone", amount_min = 5, amount_max = 15}, -- Changed 3-7 to 5-15.
	{type = "item", name = "iron-ore", amount_min = 15, amount_max = 25}, -- Changed 13-17 to 15-25.
}
RAW["simple-entity"]["copper-stromatolite"].minable.results = {
	{type = "item", name = "stone", amount_min = 5, amount_max = 15}, -- Changed 3-7 to 5-15.
	{type = "item", name = "copper-ore", amount_min = 15, amount_max = 25}, -- Changed 13-17 to 15-25.
}

-- Move the tech for bioflux-processing to after Gleba science. And remove recipes for biosulfur and rocket fuel - only allow lubricant and plastic.
Recipe.hide("biosulfur")
Tech.removeRecipeFromTech("biosulfur", "bioflux-processing")
Recipe.hide("rocket-fuel-from-jelly")
Tech.removeRecipeFromTech("rocket-fuel-from-jelly", "bioflux-processing")
Tech.removePrereq("agricultural-science-pack", "bioflux-processing")
Tech.setPrereqs("bioflux-processing", {"agricultural-science-pack", "slipstack-propagation"})
TECH["bioflux-processing"].research_trigger = nil
TECH["bioflux-processing"].unit = {
	count = 300,
	time = 60,
	ingredients = {
		{"automation-science-pack", 1},
		{"logistic-science-pack", 1},
		{"chemical-science-pack", 1},
		{"space-science-pack", 1},
		{"agricultural-science-pack", 1},
	},
}

-- Disable decomposition of plastic through bioplastic recipe. Otherwise chem science gets decomposed weird.
RECIPE["bioplastic"].allow_decomposition = false