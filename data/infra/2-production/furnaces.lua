-- This file adjusts numbers and recipes for furnaces.
-- Adjusting stone furnace speed to 0.5, other furnaces 1. (Vanilla has stone 1, others 2.)

for _, vals in pairs{
	{
		name = "stone-furnace",
		ingredients = {{type="item", name="structure", amount=1}},
		craft_time = 1,
		energy_usage = "200kW", -- Make stone furnaces generally more fuel-hungry.
		speed = 0.5,
	},
	{
		-- Steel furnaces have similar fuel usage to stone furnaces, but double speed and pollution, and much greater initial infra cost.
		name = "steel-furnace",
		ingredients = {
			{type="item", name="frame", amount=5},
			{type="item", name="structure", amount=5},
			{type="item", name="shielding", amount=5},
		},
		craft_time = 5,
		energy_usage = "250kW",
		speed = 1,
	},
	{
		name = "gas-furnace",
		ingredients = {
			{type="item", name="frame", amount=5},
			{type="item", name="structure", amount=5},
			{type="item", name="shielding", amount=5},
			{type="item", name="fluid-fitting", amount=5},
		},
		craft_time = 5,
		energy_usage = "300kW", -- Slightly more energy than steel furnaces, to compensate for not having to put fuel in barrels/canisters.
		speed = 1,
	},
	{
		-- Electric furnaces: same speed as steel furnaces, lower pollution (though electricity gen generates pollution). But make them have high drain so they're bad when not needed. Also give them higher energy consumption since they're more convenient bc no fuel needed. And note they have module slots so energy increase isn't all that bad.
		name = "electric-furnace",
		ingredients = {
			{type="item", name="frame", amount=5},
			{type="item", name="structure", amount=10},
			{type="item", name="shielding", amount=10},
			{type="item", name="wiring", amount=10},
		},
		craft_time = 10,
		energy_usage = "400kW",
		drain = "100kW",
		speed = 1,
	},
} do
	local recipe = RECIPE[vals.name]
	recipe.ingredients = vals.ingredients
	recipe.energy_required = vals.craft_time

	local ent = FURNACE[vals.name]
	ent.energy_usage = vals.energy_usage
	if vals.drain then
		ent.energy_source.drain = vals.drain
	end

	ent.crafting_speed = vals.speed
end

-- Char furnace is technically an assembling machine.
RECIPE["char-furnace"].ingredients = {{type="item", name="structure", amount=1}}
RECIPE["char-furnace"].energy_required = 1