--[[ This file adjusts numbers and recipes for assemblers.
Aims:
* Simplify the speeds to 0.5 -- 1 -- 2.
* Rewrite recipes to use factors.
* Change assembler properties to have good tradeoffs:
	* Electricity per product is roughly the same for all of them, though lower for tier 1 if not using beacons.
	* Pollution is the same for all of them, so pollution per product is lower for higher tiers.
	* Tier 3 has prod and quality bonuses. Quality bonus also means you have to design your production lines to handle quality items.
	* Since speeds double each tier, each tier needs half as much space and belts etc.
	* Tier 3 has high drain, so best suited for lines that are always running.
	* Tier 1 has no drain, so it could actually be best to use tier 1 sometimes even in the late game, eg when using a lot of beacons, or on rarely-used production lines.
]]

for _, vals in pairs{
	{
		name = "assembling-machine-1",
		speed = 0.5,
		drainKW = 0,
		activeKW = 100, -- Vanilla was 75kW.
		pollution = 5, -- Vanilla was 4.
		ingredients = {
			{"frame", 1},
			{"panel", 5},
			{"mechanism", 2},
			{"sensor", 1},
		},
		time = 5,
		effects = {
			quality = -0.5, -- Seems to be "perdec" (0-10) rather than percent (0-100) or fraction (0-1).
		},
	},
	{
		name = "assembling-machine-2",
		speed = 1,
		drainKW = 50,
		activeKW = 250, -- Vanilla was 150.
		pollution = 5, -- Vanilla was 3.
		ingredients = {
			{"frame", 5},
			{"panel", 5},
			{"mechanism", 5},
			{"sensor", 5},
		},
		time = 10,
		effects = {
			-- None. Could give it a +5% quality, but it would be annoying to do everywhere, seems better to put it in assembler 3 only. So assembler 3 is for when you can handle the non-normal-quality stuff and the high drain, and then it gives you the extra prod bonus.
		},
	},
	{
		name = "assembling-machine-3",
		-- Vanilla was speed 1.25, 375kW, 2 pollution.
		speed = 2,
		drainKW = 200,
		activeKW = 500,
		pollution = 5,
		ingredients = {
			{"frame", 5},
			{"panel", 5},
			{"electric-engine-unit", 20},
			{"sensor", 20},
		},
		time = 20,
		effects = {
			productivity = 0.1, -- It's a fraction 0-1.
			quality = 0.2, -- +2%
		},
	}
} do
	Recipe.edit{
		recipe = vals.name,
		time = vals.time,
		ingredients = vals.ingredients,
	}

	local ent = ASSEMBLER[vals.name]
	ent.crafting_speed = vals.speed
	ent.energy_source.drain = vals.drainKW .. "kW"
	ent.energy_usage = (vals.activeKW - vals.drainKW) .. "kW"
	ent.energy_source.emissions_per_minute = { pollution = vals.pollution }

	-- All assemblers can get all beacon and module effects. No module slots.
	ent.effect_receiver = {
		uses_beacon_effects = true,
		uses_module_effects = true,
		uses_surface_effects = true,
		base_effect = vals.effects,
	}
	ent.allowed_effects = {"speed", "productivity", "consumption", "pollution", "quality"}
	ent.allowed_module_categories = nil -- Allows all by default.
end

Recipe.edit{
	recipe = "filtration-plant",
	ingredients = {
		{"frame", 10},
		{"fluid-fitting", 20},
		{"mechanism", 5},
		{"panel", 20},
	},
	time = 10,
}

-- Chemical plant - shouldn't require steel bc we're moving it to automation 1. Also no pipe ingredients bc it comes before pipe tech. But it should cost more than assembler 1 since it's faster.
Recipe.edit{
	recipe = "chemical-plant",
	ingredients = {
		{"frame", 2},
		{"fluid-fitting", 10},
		{"sensor", 2},
		{"mechanism", 2},
	},
	time = 5,
	category = "crafting",
}

Recipe.edit{
	recipe = "oil-refinery",
	ingredients = {
		{"frame", 10},
		{"fluid-fitting", 20},
		{"structure", 10},
		{"panel", 20},
	},
	time = 20,
}

-- Foundry: Originally 50 tungsten carbide + 50 steel plate + 30 green circuit + 20 refined concrete + 20 lubricant.
Recipe.edit{
	recipe = "foundry",
	ingredients = {
		{"tungsten-carbide", 20},
		{"fluid-fitting", 10},
		{"shielding", 10},
		{"mechanism", 10},
	},
	time = 10,
	category = "crafting", -- Don't allow crafting foundries in foundry.
}
Recipe.edit{
	recipe = "arc-furnace",
	ingredients = {
		{"tungsten-carbide", 20},
		{"shielding", 20},
		{"fluid-fitting", 20},
		{"structure", 20},
	},
	time = 10,
	category = "crafting",
	clearSurfaceConditions = true,
}

--[[ Biochamber:
Originally 20 iron plate + 1 landfill + 5 green circuit + 5 nutrients + 1 pentapod egg.
Changing to use chem plant's ingredients, plus some nutrients and slime.
TODO ensure that you can obtain the nutrients without a biochamber, since the main route is going to be sugar-to-nutrients fermentation.
]]
Recipe.edit{
	recipe = "biochamber",
	ingredients = {
		{"fluid-fitting", 10},
		{"sensor", 2},
		{"mechanism", 2},
		{"nutrients", 10},
		--{"slime", 20}, -- No fluid, rather make it hand-craftable.
	},
	time = 5,
	category = "organic-or-assembling",
}

-- Cryo plant: now moved to early game.
Recipe.edit{
	recipe = "cryogenic-plant",
	ingredients = {
		{"frame", 10},
		{"fluid-fitting", 20},
		{"sensor", 20},
		{"shielding", 10},
	},
	time = 10,
	category = "crafting", -- Not in cryo plant.
}
local cryoPlant = ASSEMBLER["cryogenic-plant"]
cryoPlant.crafting_speed = 1
cryoPlant.energy_usage = "1MW"
cryoPlant.energy_source.drain = "0W"
cryoPlant.energy_source.emissions_per_minute = { pollution = 5 }
Item.perRocket("cryogenic-plant", 20)

