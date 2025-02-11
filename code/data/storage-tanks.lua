local General = require("code.util.general")
local Tech = require("code.util.tech")

-- For large storage tank: remove the tech, remove concrete from recipe.
data.raw.technology["large-storage-tank"].hidden = true
table.insert(data.raw.technology["fluid-handling"].effects, 3, {
	type = "unlock-recipe",
	recipe = "large-storage-tank"
})
data.raw["storage-tank"]["large-storage-tank"].heating_energy = General.multWithUnits(data.raw["storage-tank"]["storage-tank"].heating_energy, 3)

-- For inline storage tanks: remove the 4-way one, and remove the tech.
data.raw["storage-tank"]["tiny-4way-storage-tank"] = nil
data.raw.recipe["tiny-4way-storage-tank"] = nil
data.raw.item["tiny-4way-storage-tank"] = nil
Tech.removeRecipeFromTech("tiny-4way-storage-tank", "fluid-handling")
data.raw.item["tiny-inline-storage-tank"].weight = data.raw.item["pump"].weight
-- Move to pipe row, not storage row.
--data.raw.item["tiny-inline-storage-tank"].subgroup = "energy-pipe-distribution"
data.raw.item["tiny-inline-storage-tank"].order = "b[fluid]-a[0]"
data.raw.item["tiny-inline-storage-tank"].stack_size = 100
data.raw.item["tiny-inline-storage-tank"].weight = 1000000 / 100

-- Adjust ingredients.
data.raw.recipe["large-storage-tank"].ingredients = { -- Has 4x capacity of normal storage tank, so make cost less than 4x, so there's reason to use it.
	{type = "item", name = "frame", amount = 10},
	{type = "item", name = "fluid-fitting", amount = 10},
	{type = "item", name = "panel", amount = 20},
}
data.raw.recipe["large-storage-tank"].energy_required = 10
data.raw.recipe["storage-tank"].ingredients = {
	{type = "item", name = "frame", amount = 5},
	{type = "item", name = "fluid-fitting", amount = 5},
	{type = "item", name = "panel", amount = 10},
}
data.raw.recipe["storage-tank"].energy_required = 5
data.raw.recipe["tiny-inline-storage-tank"].ingredients = {
	{type = "item", name = "fluid-fitting", amount = 1},
	{type = "item", name = "panel", amount = 2},
}
data.raw.recipe["tiny-inline-storage-tank"].energy_required = 2