local togglePumps = require("code.control.toggle-key")
script.on_event("LSA-toggle-entity", togglePumps.onToggleEntity)

local startingEquipment = require("code.control.starting-items")
script.on_init(startingEquipment.onInit)
script.on_configuration_changed(startingEquipment.onConfigurationChanged)

local natGasWells = require("code.control.natural-gas-wells")
script.on_event(defines.events.on_chunk_generated, natGasWells.onChunkGenerated)

local notifyIncorrectMapgenPreset = require("code.control.notify-incorrect-mapgen-preset")
script.on_event(defines.events.on_player_created, notifyIncorrectMapgenPreset.onPlayerCreated)