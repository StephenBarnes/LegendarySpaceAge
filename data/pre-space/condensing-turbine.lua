--[[ This file adds the condensing turbine, which is like a regular turbine but gives back the steam as water.
The turbine has 40% efficiency, vs regular turbine at 80% efficiency.
Using the fusion-generator prototype, since that allows you to have one fluid input and a different fluid output, originally designed to allow hot plasma input and fluoroketone output.
Credit to meifray for the idea, in this mod: mods.factorio.com/mod/condenser_turbine_proof_of_concept
]]

-- Create entity.
---@type data.FusionGeneratorPrototype
---@diagnostic disable-next-line: assign-type-mismatch
local ent = copy(RAW["generator"]["steam-turbine"])
ent.name = "condensing-turbine"
ent.type = "fusion-generator"
ent.minable.result = "condensing-turbine"
--local originalFluidBox = ent.fluid_box
---@diagnostic disable-next-line: inject-field
ent.fluid_box = nil
ent.max_fluid_usage = 5.0/60.0 -- 5 per second.
ent.input_fluid_box = {
	filter = "steam",
	maximum_temperature = 200.0,
		-- TODO testing.
	minimum_temperature = 200.0,
	pipe_covers = pipecoverspictures(),
	pipe_connections = {
		{ flow_direction = "input", direction = defines.direction.south, position = {0, 2} },
	},
	production_type = "input",
	volume = 100,
}
ent.output_fluid_box = {
	filter = "water",
	--minimum_temperature = 100.0, -- Doesn't do anything.
	--maximum_temperature = 100.0, -- Doesn't do anything.
	pipe_covers = pipecoverspictures(),
	pipe_connections = {
		{ flow_direction = "output", direction = defines.direction.north, position = {0, -2} }
	},
	production_type = "output",
	volume = 100,
}
-- Note, it seems there's no way to set effectivity. So this would have to have 100% efficiency.
ent.energy_source = {
	type = "electric",
	output_flow_limit = "1MW", -- This field is mandatory for fusion-generator. This is for normal quality.
	usage_priority = "secondary-output", -- Same as both steam turbine and fusion generator.
	-- drain = "500kW", -- Doesn't do anything.
	-- input_flow_limit = "500kW", -- Doesn't do anything.
}
-- Fusion generator expects graphics_set, while turbine has horizontal_animation and vertical_animation. So we need to convert.
local empty = {
	filename = "__core__/graphics/empty.png",
	priority = "medium",
	width = 1,
	height = 1,
}
local verticalGraphicsSet = {
	animation = RAW["generator"]["steam-turbine"].vertical_animation,
	fluid_input_graphics = {{sprite = empty}}
}
local horizontalGraphicsSet = {
	animation = RAW["generator"]["steam-turbine"].horizontal_animation,
	fluid_input_graphics = {{sprite = empty}}
}
ent.graphics_set = {
	glow_color = { 1, 0, 0.4, 1 },
	north_graphics_set = verticalGraphicsSet,
	east_graphics_set = horizontalGraphicsSet,
	south_graphics_set = verticalGraphicsSet,
	west_graphics_set = horizontalGraphicsSet,
}
extend{ent}

-- Create item.
local item = copy(ITEM["steam-turbine"])
item.name = "condensing-turbine"
item.place_result = "condensing-turbine"
Icon.set(item, {"steam-turbine", "water"})
item.order = "g"
extend{item}

-- Create recipe.
Recipe.make{
	copy = "steam-turbine",
	recipe = "condensing-turbine",
	resultCount = 1,
	-- Will set ingredients later, in infra.
}

-- Create tech.
local tech = copy(RAW["technology"]["steam-power"])
tech.name = "condensing-turbine"
tech.effects = {
	{
		type = "unlock-recipe",
		recipe = "condensing-turbine",
	},
}
tech.unit = {
	count = 250,
	ingredients = {
		{"automation-science-pack", 1},
		{"logistic-science-pack", 1},
		{"chemical-science-pack", 1},
	},
	time = 30,
}
tech.research_trigger = nil
tech.prerequisites = {"heating-tower"}
extend{tech}