--[[ This file does data-stage changes to prevent lava from going in pipes.

Code taken from my other mod NoLavaInPipes. Moved here bc it's getting annoying to work around it in this mod.

Fluid is held in "fluid boxes". Fluid boxes have pipe_connections, which can have connection_category bitmask.
In space-age, they make a connection_category "fusion-plasma" to stop you putting plasma in pipes.
So we use this same mechanism with lava. Lava is only allowed in the pipe connections of lava pumps and foundries, not pipes.
There is a connection category called "default" which allows general fluids. So we need foundries to also allow that.
If a pipe_connection has multiple categories, it allows all of them.
So, foundries need to have connection_category {"default", "lava"}. And then we need to make a new "lava pump" entity that only allows "lava".

In control stage, we replace offshore pumps built on Vulcanus with lava pumps.
]]

-- Create new lava pump entity.
-- Offshore pumps placed on Nauvis will be automatically converted into lava pumps.
local lavaPumpEntity = copy(data.raw["offshore-pump"]["offshore-pump"])
assert(lavaPumpEntity.energy_source.type == "electric") -- Check that the offshore pump has already been given electric energy need, before we copy it.
lavaPumpEntity.name = "lava-pump"
lavaPumpEntity.fluid_box.pipe_connections[1].connection_category = "lava"
lavaPumpEntity.placeable_by = {item = "offshore-pump", count = 1}
lavaPumpEntity.icons = {
	{
		icon = "__base__/graphics/icons/offshore-pump.png",
	},
	{
		icon = "__space-age__/graphics/icons/fluid/lava.png",
		scale = 0.3,
		shift = {7, -5},
	},
}
lavaPumpEntity.hidden_in_factoriopedia = true
lavaPumpEntity.factoriopedia_alternative = "offshore-pump"
lavaPumpEntity.deconstruction_alternative = "offshore-pump"
extend{lavaPumpEntity}

-- Adjust some buildings to allow lava connections.
for _, machine in pairs{ASSEMBLER["chemical-plant"], ASSEMBLER["arc-furnace"]} do
	for _, fluidBox in pairs(machine.fluid_boxes or {}) do
		if fluidBox.production_type == "input" then
			for _, pipeConnection in pairs(fluidBox.pipe_connections or {}) do
				if pipeConnection.connection_category == nil then
					pipeConnection.connection_category = {"default", "lava"}
				elseif type(pipeConnection.connection_category) == "string" then
					local category = pipeConnection.connection_category ---@cast category string
					pipeConnection.connection_category = {category, "lava"}
				else
					assert(type(pipeConnection.connection_category) == "table")
					local categories = pipeConnection.connection_category ---@cast categories table<string>
					table.insert(categories, "lava")
				end
			end
		end
	end
end