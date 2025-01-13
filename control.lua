local startingEquipment = require("code.control.starting-items")
script.on_init(startingEquipment.onInit)
script.on_configuration_changed(startingEquipment.onConfigurationChanged)