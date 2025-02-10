local startingEquipment = require("code.control.starting-items")
script.on_init(startingEquipment.onInit)
script.on_configuration_changed(startingEquipment.onConfigurationChanged)

local natGasWells = require("code.control.natural-gas-wells")
script.on_event(defines.events.on_chunk_generated, natGasWells.onChunkGenerated)

local notifyIncorrectMapgenPreset = require("code.control.notify-incorrect-mapgen-preset")
script.on_event(defines.events.on_player_created, notifyIncorrectMapgenPreset.onPlayerCreated)

local techRateTriggers = require("code.control.tech-rate-triggers")
script.on_nth_tick(60 * 10, techRateTriggers.onNthTick)

local deepDrillRecipe = require("code.control.deep-drill-recipe")
script.on_event(defines.events.on_built_entity, deepDrillRecipe.onBuiltEntity, {{filter = "name", name = "deep-drill"}})
script.on_event(defines.events.on_robot_built_entity, deepDrillRecipe.onRobotBuiltEntity, {{filter = "name", name = "deep-drill"}})