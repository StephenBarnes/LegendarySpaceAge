--[[ This file adjusts numbers and recipes for assemblers.
Aims:
* Simplify the speeds to 0.5 -- 1 -- 2.
* Make the more advanced ones have higher drain when not active, and also worse electricity-per-product and pollution-per-product. But the module slots can make them worth using.
* Rewrite recipes to use factors.
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
		moduleSlots = 1, -- Increase from 0 to 1, since modules are now early-game.
		effects = {
			quality = -0.5, -- Seems to be "perdec" (0-10) rather than percent (0-100) or fraction (0-1).
		},
	},
	{
		name = "assembling-machine-2",
		speed = 1,
		drainKW = 20,
		activeKW = 200, -- Vanilla was 150.
		pollution = 10, -- Vanilla was 3.
		ingredients = {
			{"frame", 5},
			{"panel", 5},
			{"mechanism", 5},
			{"sensor", 2},
			{"quality-module", 5},
		},
		time = 10,
		effects = {
			quality = 0.5,
		},
	},
	{
		name = "assembling-machine-3",
		-- Vanilla was speed 1.25, 375kW, 2 pollution.
		speed = 2,
		drainKW = 500,
		activeKW = 1000,
		pollution = 20,
		ingredients = {
			{"frame", 5},
			{"panel", 5},
			{"electric-engine-unit", 5},
			{"sensor", 5},
			{"productivity-module", 5},
		},
		time = 20,
		effects = {
			productivity = 0.1, -- Seems to be fraction (0-1).
			quality = -1,
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
	if vals.moduleSlots then
		ent.module_slots = vals.moduleSlots
	end

	ent.effect_receiver = {
		uses_beacon_effects = true,
		uses_module_effects = true,
		uses_surface_effects = true,
	}
	if vals.effects then
		ent.effect_receiver.base_effect = vals.effects
	end
	ent.allowed_effects = {"speed", "productivity", "consumption", "pollution", "quality"}
	ent.allowed_module_categories = nil -- Allows all by default.
end

-- Chemical plant - shouldn't require steel bc we're moving it to automation 1. Also no pipe ingredients bc it comes before pipe tech. But it should cost more than assembler 1 since it's faster.
Recipe.edit{
	recipe = "chemical-plant",
	ingredients = {
		{"frame", 2},
		{"fluid-fitting", 10},
		{"sensor", 2},
		{"mechanism", 2},
	},
	time = 10,
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

-- Foundry: 40 tungsten carbide + 40 shielding + 40 structure + 4 mechanism
RECIPE["foundry"].ingredients = {
	{type="item", name="tungsten-carbide", amount=40},
	{type="item", name="shielding", amount=40},
	{type="item", name="structure", amount=40},
	{type="item", name="mechanism", amount=4},
}