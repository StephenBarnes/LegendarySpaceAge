-- Missile turret.
RECIPE["rocket-turret"].ingredients = {
	{type = "item", name = "shielding", amount = 4},
	{type = "item", name = "sensor", amount = 4},
	{type = "item", name = "rocket-launcher", amount = 4},
}

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

--[[
-- Add not-rotatable flag to turrets with limited range, to suppress the default popup when you try to rotate them.
for _, k in pairs{"ammo-turret", "electric-turret"} do -- Not fluid-turret since it has connections.
	for _, turret in pairs(RAW[k]) do
		if turret.attack_parameters.turn_range ~= nil and turret.attack_parameters.turn_range ~= 1 then
			table.insert(turret.flags, "not-rotatable")
		end
	end
end
]]

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