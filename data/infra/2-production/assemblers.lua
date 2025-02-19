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
		activeKW = 100,
		pollution = 4,
		ingredients = {
			{type="item", name="frame", amount=1},
			{type="item", name="panel", amount=5},
			{type="item", name="mechanism", amount=2},
			{type="item", name="sensor", amount=1},
		},
		moduleSlots = 1, -- Increase from 0 to 1, since modules are now early-game.
	},
	{
		name = "assembling-machine-2",
		speed = 1,
		drainKW = 25,
		activeKW = 250,
		pollution = 10,
		ingredients = {
			{type="item", name="frame", amount=1},
			{type="item", name="panel", amount=5},
			{type="item", name="mechanism", amount=5},
			{type="item", name="sensor", amount=5},
		},
	},
	{
		name = "assembling-machine-3",
		speed = 2,
		drainKW = 250,
		activeKW = 1000,
		pollution = 25,
		ingredients = {
			{type="item", name="frame", amount=1},
			{type="item", name="panel", amount=5},
			{type="item", name="electric-engine-unit", amount=5},
			{type="item", name="sensor", amount=5},
		},
	}
} do
	local recipe = RECIPE[vals.name]
	recipe.ingredients = vals.ingredients
	recipe.energy_required = 5

	local ent = ASSEMBLER[vals.name]
	ent.crafting_speed = vals.speed
	ent.energy_source.drain = vals.drainKW .. "kW"
	ent.energy_usage = (vals.activeKW - vals.drainKW) .. "kW"
	ent.energy_source.emissions_per_minute = { pollution = vals.pollution }
	if vals.moduleSlots then
		ent.module_slots = vals.moduleSlots
	end
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