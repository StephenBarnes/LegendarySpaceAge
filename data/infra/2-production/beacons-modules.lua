-- TODO most of this file should be deleted since I'm removing all modules.

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
		{"processing-unit", 20},
		{"sensor", 10},
	},
	time = 20,
}

--[[ Table with new values for modules.

In base game, RECIPES were:
	* 5 green + 5 red -> tier-1
	* 5 red + 5 blue + 4 tier-1 -> tier-2
	* 5 red + 5 blue + 4 tier-2 + special item -> tier-3.
	Special items:
		speed: 1 tungsten carbide
		efficiency: 5 spoilage
		productivity: 1 biter egg
		quality: 1 superconductor
Maybe adjust this so that they start having special items in tier-2 already?

Idea: make all tier-3 modules require electrolyte and superconductor. So you'll probably want to make the tier 2's on other planets (with special items), then export them to Fulgora to make tier 3's.

In base game, EFFECTS were:
	* TODO

]]
-- TODO rewrite module recipes, bonuses, etc. Probably including resin.
-- TODO edit modules to instead be like +25% or +20%, not e.g. +30%.
-- TODO give some of them effects on pollution. Eg quality module could also decrease pollution.
local moduleData = {
	speed = {
		[1] = {
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
-- Same recipe for all tier-1 modules.
for moduleType, tiers in pairs(moduleData) do
	tiers[1].ingredients = {
		{"electronic-circuit", 5},
		{"sensor", 1},
		{"wiring", 1},
	}
	tiers[1].time = 10
end
-- Apply these new values.
for moduleType, tiers in pairs(moduleData) do
	for tier, vals in pairs(tiers) do
		local moduleName = moduleType.."-module"
		if tier ~= 1 then moduleName = moduleName.."-"..tier end
		if vals.ingredients then
			Recipe.edit{
				recipe = moduleName,
				ingredients = vals.ingredients,
				time = vals.time,
			}
		end
	end
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