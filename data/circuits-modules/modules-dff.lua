-- This file makes changes to modules needed in data-final-fixes ("dff") stage.

-- Remove module slots from everything except beacons.
-- We need to remove module slots from everything except beacons because we're making modules spoilable, so they need to be automatically inserted and removed. But inserters won't interact with the module inventory of any machine except beacons, according to my testing. So as a fix, I'm just removing module slots from those entirely, and then I'll balance module and beacon strengths so they're still worth using.
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

-- Hide recycling recipes for modules.
for _, category in pairs{"speed", "efficiency", "productivity", "quality"} do
	for tier = 1, 3 do
		local moduleName = category.."-module"
		if tier ~= 1 then moduleName = moduleName.."-"..tier end
		RECIPE[moduleName.."-recycling"].hidden = true
	end
end

-- Enable productivity for all recipes that don't explicitly disable it.
for _, recipe in pairs(RECIPE) do
	if not recipe.parameter and (recipe.hidden == false or recipe.hidden == nil) then
		if (recipe.allow_productivity == nil) then
			recipe.allow_productivity = true
			assert(recipe.maximum_productivity == nil or recipe.maximum_productivity == 3)
		end
	end
end

-- TODO temporary: print out all recipes that don't have productivity enabled.
-- TODO move this to autodebugger.
for _, recipe in pairs(RECIPE) do
	if not recipe.parameter and (recipe.hidden == false or recipe.hidden == nil) then
		if (recipe.allow_productivity == false) then
			log("Disabled productivity: "..recipe.name)
		end
		if (recipe.maximum_productivity ~= 3) and (recipe.maximum_productivity ~= nil) then
			log("Non-default maximum productivity: "..recipe.name.." "..(recipe.maximum_productivity or "nil"))
		end
	end
end

-- TODO also disable quality for some recipes, and check that. Eg battery charging.
-- TODO check that all machines allow beacons, and productivity. Eg furnaces.