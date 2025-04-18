local startingEquipment = require("control.starting-items")
local natGasWells = require("control.natural-gas-wells")
local notifyIncorrectMapgenPreset = require("control.notify-incorrect-mapgen-preset")
local apprenticeFoundry = require("control.apprentice-arc-furnace")
local setRecipeOnBuild = require("control.set-recipe-on-build")
local exclusionZones = require("control.exclusion-zones")
local qualityPowerScaling = require("control.quality-power-scaling")
local noLavaInPipes = require("control.no-lava-in-pipes")
local condensingTurbineEfficiency = require("control.condensing-turbine-efficiency")
local lowGravityRunning = require("control.low-gravity-running")
local techRateTriggers = require("control.tech-rate-triggers")
local setRocketSiloParts = require("control.set-rocket-silo-parts")

script.on_nth_tick(60 * 10, function()
	techRateTriggers.onNthTick()
end)
script.on_nth_tick(30, function()
	lowGravityRunning.onNthTick()
end)

local function handlePickerDolliesEvent(e)
	condensingTurbineEfficiency.onPickerDollyMoved(e)
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
	exclusionZones.onInitOrLoad()
end)

script.on_load(function()
	registerForPickerDollies()
	exclusionZones.onInitOrLoad()
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
		setRecipeOnBuild.onBuilt(e)
		setRocketSiloParts.onBuilt(e)
		exclusionZones.onBuilt(e)
		apprenticeFoundry.on_created_entity(e)
		qualityPowerScaling.onBuilt(e)
		noLavaInPipes.onBuilt(e)
		condensingTurbineEfficiency.onBuilt(e)
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
	exclusionZones.onObjectDestroyed(e)
	condensingTurbineEfficiency.onObjectDestroyed(e)
end)

script.on_event(defines.events.on_player_rotated_entity, function(e)
	condensingTurbineEfficiency.onRotated(e)
end)

script.on_event(defines.events.on_player_flipped_entity, function(e)
	condensingTurbineEfficiency.onFlipped(e)
end)

script.on_event(defines.events.on_player_changed_surface, function(e)
	lowGravityRunning.onPlayerChangedSurface(e)
end)

-- Temporary code to output recipes, for rewriting.
--[[
log("SABBB2 military recipes:")
for _, recipe in pairs(prototypes.recipe) do
	local subgroup = recipe.subgroup
	local group = subgroup.group
	--log(group.name)
	if group.name == "combat" then
		log(recipe.name)
		log(serpent.line(recipe.ingredients))
		log(serpent.line(recipe.products))
	end
end
]]