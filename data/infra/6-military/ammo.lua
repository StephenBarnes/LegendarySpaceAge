-- Shotgun shells: I want these to be very cheap in raw materials.
Recipe.edit{
	recipe = "shotgun-shell",
	ingredients = {
		{"iron-plate", 1},
		{"copper-plate", 1},
		{"gunpowder", 1},
	},
	resultCount = 1,
	time = 2,
}
-- Piercing shotgun shells: These are pretty late-game, so could make them complex.
Recipe.edit{
	recipe = "piercing-shotgun-shell",
	ingredients = {
		{"copper-plate", 5},
		{"steel-plate", 1},
		{"gunpowder", 1},
	},
	time = 5,
}

Recipe.edit{
	recipe = "firearm-magazine",
	ingredients = {
		{"iron-plate", 5},
		{"gunpowder", 1},
	},
	time = 2,
}
Recipe.edit{ -- I want these to be more complex to produce than yellow mags, but not significantly more expensive, in fact cheaper with foundries.
	recipe = "piercing-rounds-magazine",
	ingredients = {
		{"steel-plate", 1},
		{"copper-plate", 2},
		{"gunpowder", 1},
	},
	resultCount = 1,
	time = 2,
}

Recipe.edit{ -- Originally 2 steel plate + 2 plastic bar + 1 explosives.
	recipe = "cannon-shell",
	ingredients = {
		{"shielding", 1},
		{"explosives", 1},
	},
	time = 5,
}
Recipe.edit{
	recipe = "explosive-cannon-shell",
	ingredients = {
		{"shielding", 1},
		{"explosives", 2},
	},
	time = 5,
}

Recipe.edit{ -- Originally radar, calcite, tungsten plate, explosives.
	recipe = "artillery-shell",
	ingredients = {
		{"shielding", 5},
		{"explosives", 5},
		{"tungsten-plate", 2},
		{"sensor", 1},
	},
	time = 10,
}

Recipe.edit{
	recipe = "flamethrower-ammo",
	ingredients = {
		{"fluid-fitting", 1},
		{"light-oil", 20},
	},
	time = 5,
}

Recipe.edit{
	recipe = "rocket",
	-- Originally 2 iron plate + 1 explosives.
	-- Real RPGs usually use solid propellant motors with a mixture of fuel and oxidizer. Liquid hydrogen/oxygen isn't practical bc it would need cooling. Could just use gunpowder, or maybe solid fuel. Gunpowder was used in early rockets but doesn't work very well. Solid fuel doesn't have many uses yet, so I'll use that.
	ingredients = {
		{"solid-fuel", 1}, -- Representing solid mixture of fuel and oxidizer for thrust.
		{"fluid-fitting", 1}, -- Representing nozzle.
		{"panel", 1}, -- Representing body.
		{"explosives", 1}, -- Payload.
	},
	time = 2,
}
Recipe.edit{
	recipe = "explosive-rocket",
	-- Originally 2 explosives + 1 missile in 8s. But they're not very good IME, so should be cheaper. And fast since it's just adding a bit of extra payload.
	-- Also don't want missile as an ingredient, since prod is enabled everywhere, so that would let you get >1 explosive missile per missile.
	ingredients = {
		{"solid-fuel", 1},
		{"fluid-fitting", 1},
		{"panel", 1},
		{"explosives", 2},
	},
	time = 2,
}
-- TODO atomic bomb, once I do "Nauvis part 2" recipes.

Recipe.edit{
	recipe = "capture-robot-rocket",
	ingredients = { -- Originally 2 steel plate + 1 flying robot frame + 2 blue circuit + 20 bioflux.
		{"flying-robot-frame", 1},
		{"white-circuit", 2},
		{"bioflux", 20},
		-- TODO later maybe add some ingredients specific to Nauvis-part-2?
	},
	time = 10,
}

Recipe.edit{
	recipe = "tesla-ammo",
	-- I want to make Tesla ammo more widely producible without setting up specific ship commands to export stuff Fulgora->Gleba. Because the ammo is only used by players, so people will probably just not bother to set up specific export routes. So make them producible locally everywhere fairly easily.
	ingredients = { -- Originally 1 plastic bar + 1 supercapacitor + 10 electrolyte.
		{"charged-battery", 1},
		{"processing-unit-superclocked", 1},
	},
	time = 10,
}

-- TODO railgun ammo, once I figure out endgame.

-- Make a separate subgroup for more ammo, since it'll be over 2 rows anyway.
local ammo2Subgroup = copy(RAW["item-subgroup"]["ammo"])
ammo2Subgroup.name = "ammo-2"
ammo2Subgroup.order = "b2"
extend{ammo2Subgroup}

-- Order ammo into 2 rows.
Gen.orderKinds("ammo", {RAW.ammo, RECIPE}, {
	"shotgun-shell",
	"piercing-shotgun-shell",
	"firearm-magazine",
	"piercing-rounds-magazine",
	"uranium-rounds-magazine",
	"cannon-shell",
	"explosive-cannon-shell",
	"uranium-cannon-shell",
	"explosive-uranium-cannon-shell",
	"artillery-shell",
})
Gen.orderKinds("ammo-2", {RAW.ammo, RECIPE}, {
	"flamethrower-ammo",
	"wriggler-missile",
	"rocket",
	"explosive-rocket",
	"atomic-bomb",
	"capture-robot-rocket",
	"tesla-ammo",
	"railgun-ammo",
})