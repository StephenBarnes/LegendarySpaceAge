--[[ This file removes module slots from everything except beacons. Runs in data-final-fixes ("dff") stage.
We need to remove module slots from everything except beacons because we're making modules spoilable, so they need to be automatically inserted and removed. But inserters won't interact with the module inventory of any machine except beacons, according to my testing. So as a fix, I'm just removing module slots from those entirely, and then I'll balance module and beacon strengths so they're still worth using.
]]

for _, kind in pairs{
	"assembling-machine",
	"furnace",
	"rocket-silo",
	"lab",
	"mining-drill",
} do
	local protos = RAW[kind] ---@type table<string, data.AssemblingMachinePrototype> | table<string, data.FurnacePrototype> | table<string, data.RocketSiloPrototype> | table<string, data.LabPrototype> | table<string, data.MiningDrillPrototype>
	for _, proto in pairs(protos) do
		proto.module_slots = 0
	end
end