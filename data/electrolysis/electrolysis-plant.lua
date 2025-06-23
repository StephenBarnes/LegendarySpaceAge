--[[ This file creates the electrolysis plant building.
Graphics from Artisanal Reskins: Bob's Mods by Kirazy, snouz, Vigil, YuokiTani - mods.factorio.com/mod/reskins-bobs
]]


---@type table<string, number>
local offsets = {north = 0, east = 1, south = 2, west = 3}

---@param filename string
---@param dir string
---@return data.Animation4Way
local function makeAnimationDir(filename, dir)
	return {
		filename = "__LegendarySpaceAge__/graphics/electrolysis-plant/entity/" .. filename .. ".png",
		width = 272,
		height = 260,
		frame_count = 1,
		shift = util.by_pixel(17, 0),
		scale = 0.5,
		x = offsets[dir] * 272,
		y = 0,
		draw_as_shadow = filename == "shadow",
	}
end

---@param filename string
---@param starting table?
---@return data.WorkingVisualisation
local function makeWorkingVis(filename, starting)
	local vis = starting or {}
	for dir, _ in pairs(offsets) do
		vis[dir .. "_animation"] = makeAnimationDir(filename, dir)
	end
	return vis
end

---@param dir string
---@return data.Animation4Way
local function makeAnimationsDir(dir)
	return {
		makeAnimationDir("base", dir),
		makeAnimationDir("mask", dir),
		makeAnimationDir("highlights", dir),
		makeAnimationDir("shadow", dir),
	}
end

local workingVisualisations = {
	makeWorkingVis("base"),
	makeWorkingVis("mask", {apply_recipe_tint = "primary", always_draw = true}), -- Always-draw so that the mask is visible when recipe is set, even when machine isn't active.
	makeWorkingVis("highlights"),
	makeWorkingVis("shadow"),
}

local animation = {}
for dir, _ in pairs(offsets) do
	animation[dir] = {layers = makeAnimationsDir(dir)}
end

local ent = copy(ASSEMBLER["chemical-plant"])
ent.name = "electrolysis-plant"
ent.graphics_set = {
	working_visualisations = workingVisualisations,
	animation = animation,
}
ent.water_reflection = copy(data.raw["storage-tank"]["storage-tank"].water_reflection)
ent.minable.result = "electrolysis-plant"
ent.icons = nil
Icon.set(ent, "LSA/electrolysis-plant/icon")
--ent.crafting_categories = {"electrolysis"} -- TODO make category and recipes.
ent.placeable_by = {item = "electrolysis-plant", count = 1}
local circuitConnector = { variation = 27, main_offset = util.by_pixel( 20.75, -5.25), shadow_offset = util.by_pixel( 20.75, -5.25), show_shadow = true }
ent.circuit_connector = circuit_connector_definitions.create_vector(universal_connector_template, {
	circuitConnector, circuitConnector, circuitConnector, circuitConnector
})
ent.energy_source = {
	type = "electric",
	usage_priority = "secondary-input",
	emissions_per_minute = {},
	drain = "0W",
}
ent.energy_usage = "500kW"
ent.module_slots = 0
ent.fluid_boxes = {
	{
		production_type = "input",
		volume = 200,
		pipe_covers = pipecoverspictures(),
		pipe_connections = {
			{flow_direction = "input-output", position = {-1, -1}, direction = NORTH},
			{flow_direction = "input-output", position = {-1, 1}, direction = SOUTH},
		}
	},
	-- Make 2 separate outputs, with input-output connections, so if there's 1 fluid product you can chain them, and if there's 2 then each pipe gives separate product.
	-- Unfortunately I don't think you can set it so that if there's 2 outputs, it's output-only. It's still input-output, which doesn't really make sense.
	{
		production_type = "output",
		volume = 200,
		pipe_covers = pipecoverspictures(),
		pipe_connections = {
			{flow_direction = "input-output", position = {1, -1}, direction = NORTH},
		}
	},
	{
		production_type = "output",
		volume = 200,
		pipe_covers = pipecoverspictures(),
		pipe_connections = {
			{flow_direction = "input-output", position = {1, 1}, direction = SOUTH},
		}
	},
}
local lightningSound = sound_variations("__space-age__/sound/entity/lightning-attractor/lightning-attractor-charge", 5, 0.3)
ent.working_sound = {
	main_sounds = {
		{
			sound = sound_variations("__base__/sound/chemical-plant", 3, 0.4),
			fade_in_ticks = 4,
			fade_out_ticks = 20,
		},
		{
			sound = lightningSound,
			--audible_distance_modifier = 0.5,
			probability = 1 / (10 * 60), -- 1 per 10 seconds on average.
		},
	},
	max_sounds_per_type = 3,
	activate_sound = lightningSound,
}
extend{ent}

-- Create item.
local item = copy(ITEM["chemical-plant"])
item.name = "electrolysis-plant"
item.place_result = "electrolysis-plant"
Icon.set(item, "LSA/electrolysis-plant/icon")
Item.copySoundsTo("electromagnetic-plant", item)
extend{item}

-- Create recipe.
Recipe.make{
	copy = "chemical-plant",
	recipe = "electrolysis-plant",
	icon = "LSA/electrolysis-plant/icon",
	category = "crafting",
	ingredients = {
		{"frame", 5},
		{"fluid-fitting", 20},
		{"sensor", 10},
		{"electronic-components", 20},
		-- TODO decide on ingredients.
	},
	resultCount = 1,
	time = 10,
	enabled = true, -- TODO tech
}