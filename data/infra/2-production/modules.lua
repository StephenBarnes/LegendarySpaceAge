-- TODO edit beacons.

local moduleData = {
	speed = {
		[1] = {
			ingredients = {},
		},
		[2] = {
		},
		[3] = {
		},
	},
	efficiency = {
		[1] = {
		},
		[2] = {
		},
		[3] = {
		},
	},
	productivity = {
		[1] = {
		},
		[2] = {
		},
		[3] = {
		},
	},
	quality = {
		[1] = {
		},
		[2] = {
		},
		[3] = {
		},
	},
}
-- TODO rewrite module recipes, bonuses, etc. Probably including resin.
-- TODO edit modules to instead be like +25% or +20%, not e.g. +30%.
for _, moduleType in pairs{"speed", "efficiency", "productivity"} do
	Recipe.addIngredients(moduleType.."-module", {{type = "item", name = "resin", amount = 1}})
end
