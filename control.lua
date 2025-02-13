local startingEquipment = require("control.starting-items")
local natGasWells = require("control.natural-gas-wells")
local notifyIncorrectMapgenPreset = require("control.notify-incorrect-mapgen-preset")
local deepDrillRecipe = require("control.deep-drill-recipe")
local apprenticeFoundry = require("control.apprentice-foundry")
require("control.rotate-flip")

local techRateTriggers = require("control.tech-rate-triggers")
script.on_nth_tick(60 * 10, techRateTriggers.onNthTick)

script.on_init(function()
	startingEquipment.onInit()
	apprenticeFoundry.on_init()
end)

script.on_configuration_changed(function(data)
	startingEquipment.onConfigurationChanged()
	apprenticeFoundry.on_configuration_changed()
end)

for _, event in ipairs({
	defines.events.on_built_entity,
	defines.events.on_robot_built_entity,
	defines.events.on_space_platform_built_entity,
	defines.events.script_raised_built,
	defines.events.script_raised_revive,
	defines.events.on_entity_cloned,
}) do
	script.on_event(event, function(e)
		deepDrillRecipe.onBuilt(e)
		apprenticeFoundry.on_created_entity(e)
	end)
end

script.on_event(defines.events.on_chunk_generated, function(e)
	natGasWells.onChunkGenerated(e)
end)

script.on_event(defines.events.on_player_created, function(e)
	notifyIncorrectMapgenPreset.onPlayerCreated(e)
end)

script.on_event(defines.events.on_object_destroyed, function(e)
	apprenticeFoundry.on_object_destroyed(e)
end)