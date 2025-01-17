local togglePumps = require("code.control.toggle-key")
script.on_event("LSA-toggle-entity", togglePumps.onToggleEntity)

local startingEquipment = require("code.control.starting-items")
script.on_init(startingEquipment.onInit)
script.on_configuration_changed(startingEquipment.onConfigurationChanged)