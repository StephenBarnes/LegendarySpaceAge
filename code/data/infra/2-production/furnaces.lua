-- This file adjusts numbers and recipes for furnaces.

for _, vals in pairs{
	{
		name = "char-furnace",
		t = "assembling-machine",
		ingredients = {{type="item", name="structure", amount=1}},
		craft_time = 1,
	},
	{
		name = "stone-furnace",
		ingredients = {{type="item", name="structure", amount=1}},
		craft_time = 1,
		energy_usage = "200kW", -- Make stone furnaces generally more fuel-hungry.
	},
	{
		-- Steel furnaces have similar fuel usage to stone furnaces, but double speed and pollution, and much greater initial infra cost.
		name = "steel-furnace",
		ingredients = {
			{type="item", name="frame", amount=2},
			{type="item", name="structure", amount=4},
			{type="item", name="shielding", amount=4},
		},
		craft_time = 5,
		energy_usage = "250kW",
	},
	{
		name = "gas-furnace",
		ingredients = {
			{type="item", name="frame", amount=2},
			{type="item", name="structure", amount=4},
			{type="item", name="shielding", amount=4},
			{type="item", name="fluid-fitting", amount=4},
		},
		craft_time = 5,
		energy_usage = "300kW", -- Slightly more energy than steel furnaces, to compensate for not having to put fuel in barrels/canisters.
	},
	{
		-- Electric furnaces: same speed as steel furnaces, lower pollution (though electricity gen generates pollution). But make them have high drain so they're bad when not needed. Also give them higher energy consumption since they're more convenient bc no fuel needed. And note they have module slots so energy increase isn't all that bad.
		name = "electric-furnace",
		ingredients = {
			{type="item", name="frame", amount=2},
			{type="item", name="structure", amount=10},
			{type="item", name="shielding", amount=10},
			{type="item", name="wiring", amount=10},
		},
		craft_time = 10,
		energy_usage = "400kW",
		drain = "100kW",
	},
} do
	local recipe = data.raw.recipe[vals.name]
	recipe.ingredients = vals.ingredients
	recipe.energy_required = vals.craft_time

	local ent = data.raw[vals.t or "furnace"][vals.name]
	if vals.energy_usage then
		ent.energy_usage = vals.energy_usage
		if vals.drain then
			ent.energy_source.drain = vals.drain
		end
	end
end