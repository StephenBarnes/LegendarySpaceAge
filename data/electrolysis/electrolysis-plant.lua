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
		frame_count = 1, -- TODO
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
	makeWorkingVis("mask", {apply_recipe_tint = "primary", always_draw = true}),
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
	--always_draw_idle_animation = true,
}
ent.water_reflection = copy(data.raw["storage-tank"]["storage-tank"].water_reflection)
ent.minable.result = "electrolysis-plant"
ent.icons = nil
Icon.set(ent, "LSA/electrolysis-plant/icon")
--ent.crafting_categories = {"electrolysis"} -- TODO make category and recipes.
ent.placeable_by = {item = "electrolysis-plant", count = 1}
-- TODO circuit connector
-- TODO sounds
-- TODO energy usage
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
	{
		production_type = "output",
		volume = 200,
		pipe_covers = pipecoverspictures(),
		pipe_connections = {
			{flow_direction = "input-output", position = {1, -1}, direction = NORTH},
			{flow_direction = "input-output", position = {1, 1}, direction = SOUTH},
		}
	},
}
extend{ent}

-- Create item.
local item = copy(ITEM["chemical-plant"])
item.name = "electrolysis-plant"
item.place_result = "electrolysis-plant"
Icon.set(item, "LSA/electrolysis-plant/icon")
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