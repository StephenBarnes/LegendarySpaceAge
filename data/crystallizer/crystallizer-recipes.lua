--[[ This file will create recipes for the crystallizer.
]]

local WatersConst = require("const.waters-const")
local ChemConst = require("const.chemistry-const")

Recipe.make{
	recipe = "crystallize-salt",
	copy = "sulfur",
	unhide = true,
	ingredients = {
		{"rich-brine", 20},
	},
	results = {
		{"chloride-salt", 5},
		{"bitterns", 10},
		{"steam", 10, temperature = 100},
	},
	icons = {"chloride-salt", "rich-brine"},
	main_product = "chloride-salt",
	time = 10,
	-- TODO check the energy balance on this - don't want to produce too much steam.
	enabled = true, -- TODO tech
	category = "crystallizer",
	crafting_machine_tint = { -- Tints: bulb should be color of rich brine, belt should be color of salt, tertiary is bulb glow.
		primary = WatersConst["rich-brine"].baseColor,
		secondary = ChemConst.acids.chloric.saltColor,
		--tertiary = WatersConst["rich-brine"].flowColor,
		--tertiary = {.5, .18, .11, .5},
		--tertiary = Gen.addAlpha(WatersConst["rich-brine"].baseColor, 0.8),
		--tertiary = util.mix_color(WatersConst["rich-brine"].baseColor, WatersConst["rich-brine"].flowColor),
		tertiary = {.503, .721, .713},
	},
	-- TODO block prod modules, maybe also efficiency and speed modules?
}