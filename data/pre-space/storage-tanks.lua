
-- For large storage tank: remove the tech, remove concrete from recipe.
TECH["large-storage-tank"].hidden = true
table.insert(TECH["fluid-handling"].effects, 3, {
	type = "unlock-recipe",
	recipe = "large-storage-tank"
})
RAW["storage-tank"]["large-storage-tank"].heating_energy = Gen.multWithUnits(RAW["storage-tank"]["storage-tank"].heating_energy, 3)

-- For inline storage tanks: remove the 4-way one.
RAW["storage-tank"]["tiny-4way-storage-tank"] = nil
RECIPE["tiny-4way-storage-tank"] = nil
ITEM["tiny-4way-storage-tank"] = nil
Tech.removeRecipeFromTech("tiny-4way-storage-tank", "fluid-handling")
ITEM["tiny-inline-storage-tank"].weight = ITEM["pump"].weight
-- Move to pipe row, not storage row.
--ITEM["tiny-inline-storage-tank"].subgroup = "energy-pipe-distribution"
ITEM["tiny-inline-storage-tank"].order = "b[fluid]-a[0]"
ITEM["tiny-inline-storage-tank"].stack_size = 100
Item.perRocket(ITEM["tiny-inline-storage-tank"], 100)

-- Adjust ingredients.
Recipe.edit{
	recipe = "large-storage-tank",
	ingredients = { -- Has 4x capacity of normal storage tank, so make cost less than 4x, so there's reason to use it.
		{"frame", 10},
		{"fluid-fitting", 10},
		{"panel", 20},
	},
	time = 10,
}
Item.perRocket("large-storage-tank", 20)

Recipe.edit{
	recipe = "storage-tank",
	ingredients = {
		{"frame", 5},
		{"fluid-fitting", 5},
		{"panel", 10},
	},
	time = 5,
}
Recipe.edit{
	recipe = "tiny-inline-storage-tank",
	ingredients = {
		{"fluid-fitting", 1},
		{"panel", 2},
	},
	time = 2,
}
Item.perRocket("tiny-inline-storage-tank", 100)

-- Edit the storage capacities, so a tank of steam isn't so absurdly power-dense.
RAW["storage-tank"]["tiny-inline-storage-tank"].fluid_box.volume = 1000
RAW["storage-tank"]["storage-tank"].fluid_box.volume = 10000 -- Originally 25k.
RAW["storage-tank"]["large-storage-tank"].fluid_box.volume = 50000 -- Originally 100k.

-- Clear descriptions of storage tanks.
RAW["storage-tank"]["large-storage-tank"].localised_description = {"entity-description.no-description"}
RAW["storage-tank"]["tiny-inline-storage-tank"].localised_description = {"entity-description.no-description"}

-- TODO move this to infra/ folder.