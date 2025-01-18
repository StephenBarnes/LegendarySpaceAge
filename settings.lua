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

addSetting("remove-mapgen-presets", true, "bool", "startup")

data:extend(updates)