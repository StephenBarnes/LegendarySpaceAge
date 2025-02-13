-- Recipes.
RECIPE["gun-turret"].ingredients = {
	{type = "item", name = "mechanism", amount = 2},
	{type = "item", name = "frame", amount = 1},
	{type = "item", name = "sensor", amount = 1},
}
RECIPE["gun-turret"].energy_required = 5

RECIPE["laser-turret"].ingredients = {
	{type = "item", name = "frame", amount = 1},
	{type = "item", name = "mechanism", amount = 1},
	{type = "item", name = "sensor", amount = 5},
	{type = "item", name = "advanced-circuit", amount = 5},
	{type = "item", name = "battery", amount = 10},
}
RECIPE["laser-turret"].energy_required = 10

RECIPE["flamethrower-turret"].ingredients = {
	{type = "item", name = "frame", amount = 1},
	{type = "item", name = "mechanism", amount = 1},
	{type = "item", name = "sensor", amount = 1},
	{type = "item", name = "fluid-fitting", amount = 5},
	{type = "item", name = "shielding", amount = 2},
}
RECIPE["flamethrower-turret"].energy_required = 10

RECIPE["artillery-turret"].ingredients = {
	{type = "item", name = "structure", amount = 50},
	{type = "item", name = "electric-engine-unit", amount = 10},
	{type = "item", name = "shielding", amount = 50},
}
RECIPE["artillery-turret"].energy_required = 25

RECIPE["rocket-turret"].ingredients = {
	{type = "item", name = "frame", amount = 2},
	{type = "item", name = "rocket-launcher", amount = 2},
	{type = "item", name = "sensor", amount = 5},
	{type = "item", name = "electric-engine-unit", amount = 1},
}
RECIPE["rocket-turret"].energy_required = 10

RECIPE["tesla-turret"].ingredients = {
	{type = "item", name = "processing-unit", amount = 20},
	{type = "item", name = "supercapacitor", amount = 50},
	{type = "fluid", name = "electrolyte", amount = 500},
	{type = "item", name = "electric-engine-unit", amount = 5},
}
RECIPE["tesla-turret"].energy_required = 25

-- TODO railgun turret - first need to implement Aquilo stuff.

-- Limit the arc of all turrets - because it makes defense design more interesting.
-- This val is 0-0.5 (empty to half-circle) or 1 (full circle, default). Can't be between 0.5 and 1. Flamethrower turret is 1/3 by default, so 120 degrees.
for _, turretVals in pairs{
	{"ammo-turret", "rocket-turret"},
	{"ammo-turret", "gun-turret"},
	{"electric-turret", "laser-turret"},
	-- Not Tesla turrets, rather letting those still cover 360 degrees.
} do
	local turretType = turretVals[1]
	local turretName = turretVals[2]
	local turret = RAW[turretType][turretName] ---@type data.TurretPrototype
	turret.attack_parameters.turn_range = (1/3)
end

-- Allow more fluids in flamethrower turret.
RAW["fluid-turret"]["flamethrower-turret"].attack_parameters.fluids = {
	{type = "crude-oil"},
	{type = "tar"},
	{type = "heavy-oil", damage_modifier = 1.1},
	{type = "light-oil", damage_modifier = 1.2},
	{type = "diesel", damage_modifier = 1.3},
	{type = "lava"},
}

-- Allow flamethrower turret to connect to lava pumps.
for _, pipeConnection in pairs(RAW["fluid-turret"]["flamethrower-turret"].fluid_box.pipe_connections) do
	pipeConnection.connection_category = {"default", "lava"}
end

-- Make flamethrower turret consume more fluid.
RAW["fluid-turret"]["flamethrower-turret"].attack_parameters.fluid_consumption = 1 -- Increased from 0.2 to 1.

--[[ Make gun turrets and missile turrets consume electricity.
Only works for ammo-turret currently, not fluid or artillery.
How these work: Energy flows in at the input_flow_limit until buffer is filled, then gets drained at the drain power, so input flow is the same as that drain power.
	But the input flow limit and buffer aren't shown to the user.
	So, should set buffer to be small, and set input flow limit only slightly above drain, or else it'll have extra load on the power grid that players don't expect.
	Also, we must have some energy_per_shot, or else the buffer won't drain when firing, so it'll last forever even if disconnected from power.
	Seems game automatically gives "max consumption" in tooltip as drain plus firing rate * energy per shot.
	So: Make the buffer just over the energy per shot, and make input flow limit higher than it'll ever need to be.
		Except, we don't want power spikes with PowerOverload. So don't set input limit too high.
For comparison: in vanilla, laser turret has buffer 801kJ, drain 24kW, input flow limit 9600kW.
]]
RAW["ammo-turret"]["gun-turret"].energy_source = {
	type = "electric",
	usage_priority = "primary-input", -- Top priority, same as laser turrets.
	input_flow_limit = "40kW",
	drain = "5kW",
	buffer_capacity = "20kJ",
}
RAW["ammo-turret"]["gun-turret"].energy_per_shot = "1kJ"
RAW["ammo-turret"]["rocket-turret"].energy_source = {
	type = "electric",
	usage_priority = "primary-input",
	input_flow_limit = "100kW",
	drain = "25kW",
	buffer_capacity = "400kJ",
}
RAW["ammo-turret"]["rocket-turret"].energy_per_shot = "20kJ"
-- While we're at it, reduce max consumption of laser and Tesla turrets so they don't spike too bad.
RAW["electric-turret"]["laser-turret"].energy_source = {
	type = "electric",
	usage_priority = "primary-input",
	drain = "25kW", -- Vanilla is 24kW.
	buffer_capacity = "1001kJ", -- Vanilla is 801kJ, which is energy per shot plus 1kJ.
	input_flow_limit = "5050kW", -- Vanilla is 9600kW. Max firing rate 5, 1MJ per shot, so 5MW max consumption from firing.
}
RAW["electric-turret"]["laser-turret"].attack_parameters.ammo_type.energy_consumption = "1MJ" -- Increased froom 800kJ.
RAW["electric-turret"]["tesla-turret"].energy_source = {
	type = "electric",
	usage_priority = "primary-input",
	drain = "1MW", -- Vanilla is 1MW.
	buffer_capacity = "15MJ", -- Vanilla is 15MJ.
	input_flow_limit = "6MW", -- Max firing rate 0.5, 10MJ per shot, so 5MW max consumption.
}
RAW["electric-turret"]["tesla-turret"].attack_parameters.ammo_type.energy_consumption = "10MJ" -- Vanilla is 12MJ.