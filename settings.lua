require("util.globals")

-- Globals for settings stage.
RAW = data.raw

local updates = {}
local nextOrder = 0

function getNextOrderString()
    nextOrder = nextOrder + 1
    return string.format("%03d", nextOrder)
end

function addSetting(name, default_value, type, stage)
	table.insert(updates, {
		type = type.."-setting",
		name = "LSA-"..name,
		setting_type = stage,
		default_value = default_value,
		order = getNextOrderString(),
	})
end

addSetting("force-settings", true, "bool", "startup")
addSetting("remove-mapgen-presets", true, "bool", "startup")
addSetting("enable-detailed-apollo-terrain-sliders", false, "bool", "startup")

extend(updates)