--[[ This file creates frozen items, maybe?
Currently just nutrients, as a test. TODO more.
]]

local frozenNutrients = copy(ITEM.nutrients)
frozenNutrients.name = "frozen-nutrients"
frozenNutrients.icon = nil
Icon.set(frozenNutrients, {
	{"ice", tint = {.4,.4,.4,.4}},
	{"nutrients", scale = .75},
	{"ice", tint = {.6,.6,.6,.6}},
}, "overlay")
frozenNutrients.spoil_ticks = 60 * MINUTES
frozenNutrients.fuel_value = nil
frozenNutrients.fuel_category = nil
extend{frozenNutrients}