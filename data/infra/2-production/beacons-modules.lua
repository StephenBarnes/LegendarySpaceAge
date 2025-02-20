-- Edit beacon recipes. Note beacons are also edited in data/beacons.lua, which creates the basic beacon etc.
Recipe.edit{
	recipe = "basic-beacon",
	ingredients = {
		{"electronic-components", 10},
		{"electronic-circuit", 10},
		{"frame", 5},
		{"sensor", 5},
	},
	time = 10,
}
Recipe.edit{
	recipe = "beacon",
	ingredients = {
		{"frame", 5},
		{"processing-unit", 10},
		{"superconductor", 5},
		{"electrolyte", 10},
	},
	time = 20,
}

local moduleData = {
	speed = {
		[1] = {
			ingredients = {
			},
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


-- Arrange beacons and modules in two rows.
local module2Subgroup = copy(RAW["item-subgroup"]["module"])
module2Subgroup.name = "module-2"
module2Subgroup.order = "g2"
extend{module2Subgroup}

-- Order modules into 2 rows.
Gen.orderKinds("module", {RAW.module, RECIPE}, {
	"speed-module",
	"speed-module-2",
	"speed-module-3",
	"efficiency-module",
	"efficiency-module-2",
	"efficiency-module-3",
})
Gen.orderKinds("module", {RAW.beacon, RECIPE, ITEM}, {"basic-beacon"}, "9-")
Gen.orderKinds("module-2", {RAW.module, RECIPE}, {
	"productivity-module",
	"productivity-module-2",
	"productivity-module-3",
	"quality-module",
	"quality-module-2",
	"quality-module-3",
})
Gen.orderKinds("module-2", {RAW.beacon, RECIPE, ITEM}, {"beacon"}, "9-")