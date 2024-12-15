local startingEquipment = require("code.control.starting-equipment")
script.on_event(defines.events.on_player_created, startingEquipment.onPlayerCreated)