-- Tweaking the Electric Boiler mod.

local Tech = require("code.util.tech")

-- Remove tech, rather move recipe to fluid handling.
Tech.hideTech("electric-boiler")
--Tech.addRecipeToTech("electric-boiler", "steam-power", 3) -- Rather done later in tech-progression.

data.raw.recipe["electric-boiler"].ingredients = {
	{type = "item", name = "iron-plate", amount = 8},
	{type = "item", name = "stone-brick", amount = 6},
	{type = "item", name = "electronic-circuit", amount = 4},
}
data.raw.recipe["electric-boiler"].energy_required = 5