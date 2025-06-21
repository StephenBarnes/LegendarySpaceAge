local presets = RAW["map-gen-presets"]["default"]
---@type data.MapGenPreset
local custom = {order = "aaa", basic_settings = {autoplace_controls = {}, property_expression_names = {}}, advanced_settings = {difficulty_settings = {}, enemy_evolution = {}, asteroids = {}}}
presets["LegendarySpaceAge"] = custom

-- Harder science - actually rather using multiplier 1 here, then recosting in tech-progression files, since I want to make only more advanced techs more expensive.
custom.advanced_settings.difficulty_settings.technology_price_multiplier = 1

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
	["apollo_cliffs"] = {frequency = 1, size = 3}, -- Continuity 3, TODO check.
}

-- Could reduce asteroids -- mostly makes it harder since there's less materials.
-- TODO playtest and decide whether to put anything here.
--custom.advanced_settings.asteroids.spawning_rate = 0.75

-- Enemy evolution: no time-based evolution, reduced pollution-based (bc science mult).
-- TODO playtest and decide what to put here. If you decide to change it, note it disables achievements if any of them are easier than default.
--custom.advanced_settings.enemy_evolution.time_factor = 0
--custom.advanced_settings.enemy_evolution.pollution_factor = 0.0000002 -- There's an extra factor of 0.0000001 for some reason. Default is 0.0000009 displayed as "9".

-- Fulgora: increase amount of water, make islands further apart but not much bigger.
custom.basic_settings.autoplace_controls["fulgora_islands"] = {
	size = 1/6, -- Scale 600%.
	frequency = 1/6, -- Coverage 17%.
}

-- Increase size of starting area, to reduce chance of having to fight in very early game.
-- If we just reduce the setting here, then it warns you achievements are disabled. So instead I'm altering the noise expression directly.
-- Not changing it for Vulcanus.
custom.basic_settings.starting_area = 1
for _, noiseTypeAndName in pairs{
	{ "noise-expression", "enemy_base_probability" },
	{ "noise-function",   "enemy_autoplace_base" },
	{ "noise-expression", "tier_from_start" },
} do
	local noiseExprProto = RAW[noiseTypeAndName[1]][noiseTypeAndName[2]]
	if noiseExprProto == nil then
		log("ERROR: No noise expression found for " .. serpent.line(noiseTypeAndName))
		goto continue
	end
	local expr = noiseExprProto.expression
	if type(expr) ~= "string" then
		log("ERROR: Expected string for expression, got " .. type(expr) .. " for " .. serpent.line(noiseTypeAndName))
		goto continue
	end
	local substituted = string.gsub(expr, "starting_area_radius", "(starting_area_radius*2)")
	if #substituted == #expr then
		log("ERROR: Starting area radius not involved in expression " .. serpent.line(noiseTypeAndName))
		goto continue
	end
	noiseExprProto.expression = substituted
	::continue::
end

-- Add custom elevation. TODO currently this is the same as the default, but still adding here so I can check they used the main LSA mapgen preset.
custom.basic_settings.property_expression_names.elevation = "LSA-elevation"

local lsaElevation = copy(RAW["noise-expression"]["elevation"])
lsaElevation.name = "LSA-elevation"
extend{lsaElevation}