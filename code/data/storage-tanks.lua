local General = require("code.util.general")
local Tech = require("code.util.tech")

-- For large storage tank: remove the tech, remove concrete from recipe.
data.raw.technology["large-storage-tank"].hidden = true
table.insert(data.raw.technology["fluid-handling"].effects, 2, {
	type = "unlock-recipe",
	recipe = "large-storage-tank"
})
data.raw["storage-tank"]["large-storage-tank"].heating_energy = General.multWithUnits(data.raw["storage-tank"]["storage-tank"].heating_energy, 3)

-- For inline storage tanks: remove the 4-way one, and remove the tech.
data.raw["storage-tank"]["tiny-4way-storage-tank"] = nil
data.raw.recipe["tiny-4way-storage-tank"] = nil
data.raw.item["tiny-4way-storage-tank"] = nil
data.raw.technology["tiny-storage-tanks"] = nil
Tech.addRecipeToTech("tiny-inline-storage-tank", "fluid-handling", 1)
data.raw.item["tiny-inline-storage-tank"].weight = data.raw.item["pump"].weight
-- Move to pipe row, not storage row.
--data.raw.item["tiny-inline-storage-tank"].subgroup = "energy-pipe-distribution"
data.raw.item["tiny-inline-storage-tank"].order = "b[fluid]-a[0]"

-- TODO actually let's add the 4way storage tank back in, but use the toggle hotkey for it.

-- Adjust ingredients.
data.raw.recipe["large-storage-tank"].ingredients = { -- Has 4x capacity of normal storage tank, so make cost less than 4x, so there's reason to use it.
	{ type = "item", name = "iron-plate", amount = 50 },
	{ type = "item", name = "steel-plate", amount = 10 },
	{ type = "item", name = "glass", amount = 5 },
}
data.raw.recipe["storage-tank"].ingredients = {
	{ type = "item", name = "iron-plate", amount = 20 },
	{ type = "item", name = "steel-plate", amount = 5 },
	{ type = "item", name = "glass", amount = 2 },
}
data.raw.recipe["tiny-inline-storage-tank"].ingredients = {
	{ type = "item", name = "iron-plate", amount = 4 },
	{ type = "item", name = "steel-plate", amount = 1 },
	{ type = "item", name = "glass", amount = 1 },
}