--[[ This file adds the condensing turbine, which is like a regular turbine but gives back the steam as water.
The turbine has 40% efficiency, vs regular turbine at 80% efficiency.
Using the fusion-generator prototype, since that allows you to have one fluid input and a different fluid output, originally designed to allow hot plasma input and fluoroketone output.
Credit to meifray for the idea, in this mod: mods.factorio.com/mod/condenser_turbine_proof_of_concept

NOTE turns out Space Exploration also has condensing turbines, with a different implementation. The main entity is a furnace turning steam into water and "internal steam", which gets outputted into a fluid tank buffer, then goes into a generator that consumes internal steam. Not sure which approach is better between the two. If I didn't want to add effectivity then the fusion-generator approach would be simpler, with no hidden ents. But since I want effectivity under 100%, I have to use hidden ents below, and then both approaches seem to have the same complexity. SE also has "big turbine" converting hot steam to cold steam and water, using same system.
]]

local MIN_TEMP = 100
local MAX_TEMP = 500

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
	maximum_temperature = MAX_TEMP,
	minimum_temperature = MIN_TEMP,
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
-- Also I'm adding lid graphics on top, to cover up the exposed rotating part, and so players can tell them apart from regular steam turbines.
local empty = {
	filename = "__core__/graphics/empty.png",
	priority = "medium",
	width = 1,
	height = 1,
}
---@diagnostic disable-next-line: undefined-field
table.insert(ent.vertical_animation.layers, {
	filename = "__LegendarySpaceAge__/graphics/condensing-turbine/lid-V.png",
	width = 217,
	height = 347,
	repeat_count = 8,
	line_length = 1,
	shift = util.by_pixel(4.75, 6.75),
	run_mode = "backward",
	scale = 0.5,
})
---@diagnostic disable-next-line: undefined-field
table.insert(ent.horizontal_animation.layers, {
	filename = "__LegendarySpaceAge__/graphics/condensing-turbine/lid-H.png",
	width = 320,
	height = 245,
	repeat_count = 8,
	line_length = 1,
	shift = util.by_pixel(0, -2.75),
	run_mode = "backward",
	scale = 0.5,
})
local verticalGraphicsSet = {
	---@diagnostic disable-next-line: undefined-field
	animation = ent.vertical_animation,
	fluid_input_graphics = {{sprite = empty}}
}
local horizontalGraphicsSet = {
	---@diagnostic disable-next-line: undefined-field
	animation = ent.horizontal_animation,
	fluid_input_graphics = {{sprite = empty}}
}
ent.graphics_set = {
	glow_color = { 1, 0, 0.4, 1 },
	north_graphics_set = verticalGraphicsSet,
	east_graphics_set = horizontalGraphicsSet,
	south_graphics_set = verticalGraphicsSet,
	west_graphics_set = horizontalGraphicsSet,
}
Icon.set(ent, "LSA/condensing-turbine/icon")
-- TODO edit the icon to add the lid.
extend{ent}

-- Create item.
local item = copy(ITEM["steam-turbine"])
item.name = "condensing-turbine"
item.place_result = "condensing-turbine"
Icon.set(item, "LSA/condensing-turbine/icon")
extend{item}

-- Create recipe.
Recipe.make{
	copy = "steam-turbine",
	recipe = "condensing-turbine",
	resultCount = 1,
	clearIcons = true,
	-- Will set ingredients later, in infra.
}

--[[ Move steam turbine to a new tech.
Its advantages over the steam engine are: (1) has higher efficiency, and (2) can process hotter steam.
LSA removes heat pipes, so there isn't really hotter steam. Could add that back I guess?
]]

-- Create tech for steam power 2.
local tech2 = copy(RAW["technology"]["steam-power"])
tech2.name = "steam-power-2"
tech2.effects = {
	{
		type = "unlock-recipe",
		recipe = "steam-turbine",
	}
}
tech2.unit = {
	count = 250,
	ingredients = {
		{"automation-science-pack", 1},
		{"logistic-science-pack", 1},
	},
	time = 30,
}
tech2.localised_description = {"technology-description.steam-power-2"}
tech2.prerequisites = {"steam-power", "fluid-handling"}
extend{tech2}

-- Create tech steam-power-3 for condensing turbine.
local tech3 = copy(RAW["technology"]["steam-power"])
tech3.name = "steam-power-3"
tech3.effects = {
	{
		type = "unlock-recipe",
		recipe = "condensing-turbine",
	},
}
tech3.unit = {
	count = 250,
	ingredients = {
		{"automation-science-pack", 1},
		{"logistic-science-pack", 1},
		{"chemical-science-pack", 1},
	},
	time = 30,
}
tech3.research_trigger = nil
tech3.prerequisites = {"steam-power-2", "chemical-science-pack"}
tech3.localised_description = {"technology-description.steam-power-3"}
extend{tech3}

------------------------------------------------------------------------
--[[ Rest of this file uses evil tricks to make the condensing turbine not have 100% efficiency.
Namely:
	* Create condensing-turbine-evil, which is a copy of condensing-turbine, except its input fluidbox is linked, and consumes steam-evil.
	* Create steam-evil, which is a fluid that's like steam, but with specific heat changed so that steam-evil has 40% of the energy of steam at a given temperature.
	* Create steam-evilizer, which turns steam into steam-evil. Intake is at condensing-turbine's input, outputs into linked input of the condensing-turbine-evil.
	* In control stage, when player places a condensing-turbine, we replace it with a condensing-turbine-evil plus a steam-evilizer. So the steam gets converted to steam-evil before being used to power the condensing-turbine-evil.
This is all so that it looks like the condensing turbine is consuming steam (actually steam-evil) and generating energy with 40% efficiency.
]]

local HIDE_EVIL = true -- Whether to hide all of these entities, etc. Set to false for debugging.

-- Create condensing-turbine-evil.
local ctEvilEnt = copy(ent)
ctEvilEnt.name = "condensing-turbine-evil"
ctEvilEnt.input_fluid_box.pipe_connections[1].position = {0, 0}
ctEvilEnt.input_fluid_box.pipe_covers = nil
ctEvilEnt.input_fluid_box.filter = "steam-evil"
ctEvilEnt.input_fluid_box.pipe_connections[1].connection_type = "linked"
ctEvilEnt.input_fluid_box.pipe_connections[1].linked_connection_id = 1
ctEvilEnt.placeable_by = {item = "condensing-turbine", count = 1}
--table.insert(ctEvilEnt.flags, "not-rotatable")
	-- Used to use this, but disabling now bc I'll rather respond to rotation and flip events.
	-- Note this only affects the evil ent, not the base ent, so you can still rotate before placing.
	-- Note it works in a weird way when you try to rotate blueprints - doesn't actually turn the turbines, but does rotate the blueprint, so they overlap, but when built they fix themselves.
if HIDE_EVIL then
	ctEvilEnt.localised_name = {"entity-name.condensing-turbine"}
	ctEvilEnt.localised_description = {"entity-description.condensing-turbine"}
	ctEvilEnt.hidden = true
	ctEvilEnt.input_fluid_box.hide_connection_info = true
end
extend{ctEvilEnt}

-- Create steam-evil.
local steamEvil = copy(FLUID["steam"])
steamEvil.name = "steam-evil"
-- For regular steam, heat capacity is 1kJ, so 200C steam is 200kJ per unit.
-- We want 500C steam-evil to have 200kJ per unit, so heat capacity is 200/500 = 0.4kJ per unit.
steamEvil.heat_capacity = "0.4kJ"
if HIDE_EVIL then
	steamEvil.hidden = true
	steamEvil.factoriopedia_alternative = "steam"
	steamEvil.localised_name = {"fluid-name.steam"}
	steamEvil.localised_description = {"fluid-description.steam"}
end
extend{steamEvil}

-- Create multiple recipes for evilizing steam. It's a furnace, so it'll automatically choose the right one. This allows processing 200C steam as well as 500C steam.
for _, data in pairs{
	{outputTemp = MAX_TEMP, minTemp = MAX_TEMP, maxTemp = MAX_TEMP},
	{outputTemp = 450, minTemp = 450, maxTemp = 499.99},
	{outputTemp = 400, minTemp = 400, maxTemp = 449.99},
	{outputTemp = 300, minTemp = 300, maxTemp = 399.99},
	{outputTemp = 200, minTemp = 200, maxTemp = 299.99},
	{outputTemp = MIN_TEMP, minTemp = MIN_TEMP, maxTemp = 199.99},
} do
	---@type data.RecipePrototype
	local evilRecipe = {
		type = "recipe",
		name = "steam-evilizing-" .. data.outputTemp,
		ingredients = {
			{type = "fluid", name = "steam", amount = 5, minimum_temperature = data.minTemp, maximum_temperature = data.maxTemp},
		},
		results = {
			{type = "fluid", name = "steam-evil", amount = 5, temperature = data.outputTemp},
		},
		energy_required = 0.1,
		auto_recycle = false,
		allow_productivity = false,
		allow_speed = false,
		allow_quality = false,
		allowed_module_categories = {},
		category = "steam-evilizing",
		icons = ent.icons,
		hide_from_player_crafting = true,
		hide_from_stats = true,
		-- Note that water produced by the condensing-turbine-evil, and steam-evil consumed by it, are hidden from stats. Seems to be an engine bug/feature. Also applies to base-game's fusion-generators consuming plasma and making hot fluoroketone. Hiding the steam consumption here to match that behavior.
	}
	if HIDE_EVIL then
		Recipe.hide(evilRecipe)
	end
	extend{evilRecipe}
end

-- Create crafting category.
---@type data.RecipeCategory
local evilCategory = {
	type = "recipe-category",
	name = "steam-evilizing",
}
if HIDE_EVIL then
	evilCategory.hidden = true
	evilCategory.hidden_in_factoriopedia = true
end
extend{evilCategory}

-- Create steam-evilizer.
---@type data.FurnacePrototype
local steamEvilizerEnt = {
	type = "furnace",
	name = "steam-evilizer",
	icon = "__core__/graphics/empty.png",
	icon_size = 64,
	icon_mipmaps = 4,
	crafting_categories = {"steam-evilizing"},
	crafting_speed = 1,
	energy_usage = "1W",
	energy_source = {
		type = "void",
	},
	allowed_effects = {},
	source_inventory_size = 0,
	result_inventory_size = 0,
	fluid_boxes = {
		{
			production_type = "input",
			filter = "steam",
			pipe_covers = pipecoverspictures(),
			pipe_connections = {
				{ flow_direction = "input", direction = defines.direction.south, position = {0, 2} },
			},
			volume = 10,
			minimum_temperature = MIN_TEMP,
			maximum_temperature = MAX_TEMP,
		},
		{
			production_type = "output",
			filter = "steam-evil",
			pipe_connections = {
				{ flow_direction = "output", direction = defines.direction.north, position = {0, 1}, connection_type = "linked", linked_connection_id = 1 }
			},
			volume = 10,
			hide_connection_info = HIDE_EVIL,
		},
	},
	collision_box = ent.collision_box,
	selection_box = {{-1, -1}, {1, 1}},
	show_recipe_icon_on_map = false,
	show_recipe_icon = false,
	selection_priority = Gen.ifThenElse(HIDE_EVIL, 1, 100),
	collision_mask = {layers={}},
	remove_decoratives = "false",
	allow_copy_paste = false,
	allowed_module_categories = {},
	flags = {"not-on-map", "not-repairable", "not-deconstructable", "not-flammable", "not-blueprintable", "placeable-neutral", "no-copy-paste"},
}
if HIDE_EVIL then
	steamEvilizerEnt.hidden = true
	steamEvilizerEnt.factoriopedia_alternative = "condensing-turbine"
	steamEvilizerEnt.selectable_in_game = false
	steamEvilizerEnt.localised_name = {"entity-name.condensing-turbine"}
	steamEvilizerEnt.localised_description = {"entity-description.condensing-turbine"}
end
extend{steamEvilizerEnt}