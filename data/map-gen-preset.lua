local presets = RAW["map-gen-presets"]["default"]
---@type data.MapGenPreset
local custom = {order = "aaa", basic_settings = {autoplace_controls = {}, property_expression_names = {}}, advanced_settings = {difficulty_settings = {}, enemy_evolution = {}, asteroids = {}}}
presets["LegendarySpaceAge"] = custom

-- Harder science
custom.advanced_settings.difficulty_settings.technology_price_multiplier = 10

-- Rail world defaults, copied from base game code.
custom.basic_settings.autoplace_controls = {
	coal = {frequency = 1/3, size = 3},
	["copper-ore"] = {frequency = 1/3, size = 3},
	["crude-oil"] = {frequency = .75, size = 4}, -- Giving it some more frequency and size, since petrochems are more important in LSA, and half of them will be turned into gas wells.
	["uranium-ore"] = {frequency = 1/3, size = 3},
	["iron-ore"] = {frequency = 1/3, size = 3},
	stone = {frequency = 1/3, size = 3},
	["enemy-base"] = {size = 1},
	water = {frequency = 0.5, size = 1.5},
}

-- Less asteroids -- mostly makes it harder since there's less materials.
custom.advanced_settings.asteroids.spawning_rate = 0.75

-- Enemy evolution: no time-based evolution, reduced pollution-based (bc science mult).
custom.advanced_settings.enemy_evolution.time_factor = 0
custom.advanced_settings.enemy_evolution.pollution_factor = 0.0000002 -- There's an extra factor of 0.0000001 for some reason. Default is 0.0000009 displayed as "9".

-- Fulgora: increase amount of water, make islands further apart but not much bigger.
custom.basic_settings.autoplace_controls["fulgora_islands"] = {
	size = 1/6, -- Scale 600%.
	frequency = 1/6, -- Coverage 17%.
}

-- Increase size of starting area, to reduce chance of having to fight in very early game.
custom.basic_settings.starting_area = 2

-- Add custom elevation. TODO currently this is the same as the default, but still adding here so I can check they used the main LSA mapgen preset.
custom.basic_settings.property_expression_names.elevation = "LSA-elevation"

local lsaElevation = copy(RAW["noise-expression"]["elevation"])
lsaElevation.name = "LSA-elevation"
data:extend{lsaElevation}