local presets = data.raw["map-gen-presets"]["default"]
---@type data.MapGenPreset
local custom = {order = "aaa", basic_settings = {autoplace_controls = {}}, advanced_settings = {difficulty_settings = {}, enemy_evolution = {}, asteroids = {}}}
presets["LegendarySpaceAge"] = custom

-- Harder science
custom.advanced_settings.difficulty_settings.technology_price_multiplier = 10

-- Less asteroids -- mostly makes it harder since there's less materials.
custom.advanced_settings.asteroids.spawning_rate = 0.75

-- Enemy evolution: no time-based evolution, reduced pollution-based (bc science mult).
custom.advanced_settings.enemy_evolution.time_factor = 0
custom.advanced_settings.enemy_evolution.pollution_factor = 0.0000002 -- There's an extra factor of 0.0000001 for some reason. Default is 0.0000009 displayed as "9".

-- Reduce stone on Gleba - to encourage either slipstack cultivation or rail mining outposts, both of which are more interesting than just having a starting patch that's enough to win the game.
custom.basic_settings.autoplace_controls["gleba_stone"] = {richness = 1/3}

-- Fulgora: increase amount of water, make islands further apart but not much bigger.
custom.basic_settings.autoplace_controls["fulgora_islands"] = {
	size = 1/6, -- Scale 600%.
	frequency = 1/6, -- Coverage 17%.
}

-- TODO add rail world preset settings.