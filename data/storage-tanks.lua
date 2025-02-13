
-- For large storage tank: remove the tech, remove concrete from recipe.
TECH["large-storage-tank"].hidden = true
table.insert(TECH["fluid-handling"].effects, 3, {
	type = "unlock-recipe",
	recipe = "large-storage-tank"
})
RAW["storage-tank"]["large-storage-tank"].heating_energy = Gen.multWithUnits(RAW["storage-tank"]["storage-tank"].heating_energy, 3)

-- For inline storage tanks: remove the 4-way one, and remove the tech.
RAW["storage-tank"]["tiny-4way-storage-tank"] = nil
RECIPE["tiny-4way-storage-tank"] = nil
ITEM["tiny-4way-storage-tank"] = nil
Tech.removeRecipeFromTech("tiny-4way-storage-tank", "fluid-handling")
ITEM["tiny-inline-storage-tank"].weight = ITEM["pump"].weight
-- Move to pipe row, not storage row.
--ITEM["tiny-inline-storage-tank"].subgroup = "energy-pipe-distribution"
ITEM["tiny-inline-storage-tank"].order = "b[fluid]-a[0]"
ITEM["tiny-inline-storage-tank"].stack_size = 100
ITEM["tiny-inline-storage-tank"].weight = ROCKET / 100

-- Adjust ingredients.
RECIPE["large-storage-tank"].ingredients = { -- Has 4x capacity of normal storage tank, so make cost less than 4x, so there's reason to use it.
	{type = "item", name = "frame", amount = 10},
	{type = "item", name = "fluid-fitting", amount = 10},
	{type = "item", name = "panel", amount = 20},
}
RECIPE["large-storage-tank"].energy_required = 10
RECIPE["storage-tank"].ingredients = {
	{type = "item", name = "frame", amount = 5},
	{type = "item", name = "fluid-fitting", amount = 5},
	{type = "item", name = "panel", amount = 10},
}
RECIPE["storage-tank"].energy_required = 5
RECIPE["tiny-inline-storage-tank"].ingredients = {
	{type = "item", name = "fluid-fitting", amount = 1},
	{type = "item", name = "panel", amount = 2},
}
RECIPE["tiny-inline-storage-tank"].energy_required = 2