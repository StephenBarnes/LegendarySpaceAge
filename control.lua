local startingEquipment = require("control.starting-items")
local natGasWells = require("control.natural-gas-wells")
local notifyIncorrectMapgenPreset = require("control.notify-incorrect-mapgen-preset")
local apprenticeFoundry = require("control.apprentice-arc-furnace")
local setRecipeOnBuild = require("control.set-recipe-on-build")
local pickerDolliesBlacklist = require("control.picker-dollies-blacklist")
local lowGravityRunning = require("control.low-gravity-running")
local techRateTriggers = require("control.tech-rate-triggers")
local entitySubstitutions = require("control.entity-substitutions")
local childEntities = require("control.child-entities")

script.on_nth_tick(60 * 10, function()
	techRateTriggers.onNthTick()
end)
script.on_nth_tick(30, function()
	lowGravityRunning.onNthTick()
end)

local function handlePickerDolliesEvent(e)
	childEntities.onPickerDollyMoved(e)
end

local function registerForPickerDollies()
	if remote.interfaces["PickerDollies"] and remote.interfaces["PickerDollies"]["dolly_moved_entity_id"] then
		script.on_event(remote.call("PickerDollies", "dolly_moved_entity_id"), handlePickerDolliesEvent)
	end
end

script.on_init(function()
	registerForPickerDollies()
	startingEquipment.onInit()
	apprenticeFoundry.on_init()
	pickerDolliesBlacklist.onInitOrLoad()
end)

script.on_load(function()
	registerForPickerDollies()
	pickerDolliesBlacklist.onInitOrLoad()
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
		local newEnt = entitySubstitutions.onBuilt(e)
		if newEnt ~= nil then
			e.entity = newEnt
		end
		childEntities.onBuilt(e)
		setRecipeOnBuild.onBuilt(e)
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
	childEntities.onObjectDestroyed(e)
	apprenticeFoundry.on_object_destroyed(e)
end)

script.on_event(defines.events.on_player_rotated_entity, function(e)
	childEntities.onRotated(e)
end)

script.on_event(defines.events.on_player_flipped_entity, function(e)
	childEntities.onFlipped(e)
end)

script.on_event(defines.events.on_player_changed_surface, function(e)
	lowGravityRunning.onPlayerChangedSurface(e)
end)