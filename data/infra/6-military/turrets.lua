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