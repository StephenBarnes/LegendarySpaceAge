--[[ This file creates duplicates of the stone-furnace and steel-furnace that use heat shuttles as fuel.
]]

local PetrochemConst = require("const.petrochem-const")
local FurnaceConst = require("const.furnace-const")

-- Heat icon, for "subscript" on heat furnaces.
local heatIcon = "LSA/heat-shuttles/heat-red"


-- Graphics set for steel furnaces, giving them visible pipes. Mostly copied from Adamo's Gas Furnace mod - https://mods.factorio.com/mod/gas-furnace
local advancedFurnaceGraphicsSet = {
	working_visualisations = {
		{
			animation = {
				filename = "__base__/graphics/entity/steel-furnace/steel-furnace-fire.png",
				priority = "high",
				line_length = 8,
				width = 57,
				height = 81,
				frame_count = 48,
				direction_count = 1,
				shift = util.by_pixel(-0.5, -16.9),
				scale = 0.5,
				draw_as_glow = true,
				tint = FurnaceConst.fireCore,
				tint_as_overlay = true
			}
		},
		{
			effect = "flicker",
			animation = {
				filename = "__base__/graphics/entity/steel-furnace/steel-furnace-glow.png",
				priority = "high",
				width = 60,
				height = 43,
				frame_count = 1,
				shift = util.by_pixel(0, 0),
				blend_mode = "additive-soft",
				draw_as_glow = true,
				tint = FurnaceConst.fireGlow
			}
		},
		{
			effect = "flicker",
			animation = {
				filename = "__LegendarySpaceAge__/graphics/from_gas_furnace/entity-working.png",
				priority = "high",
				width = 269,
				height = 221,
				direction_count = 1,
				frame_count = 1,
				shift = util.by_pixel(0, -12),
				scale = 0.5,
				blend_mode = "additive",
				tint = FurnaceConst.fireGlow
			}
		},
		{
			fadeout = true,
			effect = "flicker",
			animation = {
				filename = "__base__/graphics/entity/steel-furnace/steel-furnace-ground-light.png",
				priority = "high",
				line_length = 1,
				width = 152,
				height = 126,
				draw_as_light = true,
				shift = util.by_pixel(1, 36),
				blend_mode = "additive",
				scale = 0.5,
				tint = FurnaceConst.fireGlow
			},
		},
	},
	animation = {
		layers = {
			{
				filename = "__LegendarySpaceAge__/graphics/from_gas_furnace/entity.png",
				priority = "extra-high",
				width = 269,
				height = 221,
				frame_count = 1,
				shift = util.by_pixel(0, -12),
				scale = 0.5
			},
			{
				filename = "__base__/graphics/entity/steel-furnace/steel-furnace-shadow.png",
				priority = "high",
				width = 277,
				height = 85,
				frame_count = 1,
				draw_as_shadow = true,
				shift = util.by_pixel(60.25, 17.25),
				scale = 0.5
			}
		},
	},
}

-- Create fluid-fuelled carbon furnace. Code and graphics mostly copied from Adamo's Gas Furnace mod - https://mods.factorio.com/mod/gas-furnace
local ffcFurnace = copy(FURNACE["steel-furnace"])
ffcFurnace.name = "ffc-furnace"
ffcFurnace.minable.result = "ffc-furnace"
ffcFurnace.placeable_by = {item = "ffc-furnace", count = 1}
ffcFurnace.energy_source = {
	type = "fluid",
	fluid_box = {
		base_area = 1,
		height = 1,
		volume = 200,
		pipe_picture = GreyPipes.pipeBlocks(),
		pipe_covers = pipecoverspictures(),
		pipe_connections = {
			{flow_direction = "input-output", position = {0.5, -0.5}, direction = EAST},
			{flow_direction = "input-output", position = {-0.5, -0.5}, direction = WEST},
		},
		secondary_draw_orders = {north = -16, east = -1, west = -1, south = -2},
	},
	burns_fluid = true,
	scale_fluid_usage = true,
	hide_connection_info = false, -- Show arrows for fuel pipes.
	smoke = {{ -- TODO maybe remove this? Since it's not going to vent waste gases.
		name = "smoke",
		north_position = {0.7, -1.9},
		south_position = {0.7, -1.9},
		east_position = {0.7, -1.9},
		west_position = {0.7, -1.9},
		frequency = 2,
		starting_vertical_speed = 0.08,
		starting_frame_deviation = 60,
		deviation = {0.075, 0.075}
	}},
	light_flicker = {
		color = FurnaceConst.fireGlow,
		minimum_light_size = 0.1,
		light_intensity_to_size_coefficient = 1
	},
}
ffcFurnace.graphics_set = advancedFurnaceGraphicsSet
ffcFurnace.fluid_boxes = nil -- TODO
ffcFurnace.collision_box = FurnaceConst.boundingBox
ffcFurnace.map_generator_bounding_box = FurnaceConst.boundingBox
ffcFurnace.icon = nil
ffcFurnace.icons = {
	{icon = "__LegendarySpaceAge__/graphics/from_gas_furnace/icon.png", icon_size = 64, scale = .5, shift = {2, 0}},
	{icon = "__LegendarySpaceAge__/graphics/fluids/gas-2.png", icon_size = 64, scale = 0.3, shift = {-5, 6}, tint = PetrochemConst.richgasColor},
}
-- Should only be able to place where there's oxygen/air? (TODO later allow anywhere, with oxygen/air input.)
ffcFurnace.surface_conditions = RAW["mining-drill"]["burner-mining-drill"].surface_conditions
extend{ffcFurnace}

-- Create item for ffc-furnace.
local ffcFurnaceItem = copy(ITEM["steel-furnace"])
ffcFurnaceItem.name = "ffc-furnace"
ffcFurnaceItem.place_result = "ffc-furnace"
ffcFurnaceItem.icon = nil
ffcFurnaceItem.icons = copy(ffcFurnace.icons)
extend{ffcFurnaceItem}

-- Create recipe for ffc-furnace. Will be edited in infra/.
Recipe.make{
	recipe = "ffc-furnace",
	copy = "steel-furnace",
	results = {"ffc-furnace"},
	main_product = "ffc-furnace",
	clearIcons = true,
	addToTech = "advanced-material-processing",
}

-- Edit the base steel furnace to use the same graphics, collision box, and smoke as the ffc-furnace.
local steelFurnace = FURNACE["steel-furnace"]
steelFurnace.graphics_set = advancedFurnaceGraphicsSet
steelFurnace.collision_box = FurnaceConst.boundingBox
steelFurnace.map_generator_bounding_box = FurnaceConst.boundingBox
steelFurnace.energy_source.smoke = copy(ffcFurnace.energy_source.smoke)
steelFurnace.energy_source.light_flicker = copy(ffcFurnace.energy_source.light_flicker)
Icon.set(steelFurnace, "LSA/from_gas_furnace/icon")
local steelFurnaceItem = ITEM["steel-furnace"]
Icon.set(steelFurnaceItem, "LSA/from_gas_furnace/icon")

-- Edit the base stone furnace to use the same collision box as the rest of them.
local stoneFurnace = FURNACE["stone-furnace"]
stoneFurnace.collision_box = FurnaceConst.boundingBox
stoneFurnace.map_generator_bounding_box = FurnaceConst.boundingBox

-- Create basic heat furnace entity.
local stoneHeatEnt = copy(FURNACE["stone-furnace"])
stoneHeatEnt.name = "stone-furnace-heat"
stoneHeatEnt.minable.result = "stone-furnace-heat"
stoneHeatEnt.placeable_by = {item = "stone-furnace-heat", count = 1}
stoneHeatEnt.energy_source.burner_usage = "heat-provider"
stoneHeatEnt.energy_source.fuel_categories = {"heat-provider"}
stoneHeatEnt.crafting_categories = {"heat-furnace"}
Icon.set(stoneHeatEnt, {"base/stone-furnace", heatIcon}, "heat")
extend{stoneHeatEnt}

-- Create item for basic heat furnace.
local stoneHeatItem = copy(ITEM["stone-furnace"])
stoneHeatItem.name = "stone-furnace-heat"
stoneHeatItem.place_result = "stone-furnace-heat"
Icon.set(stoneHeatItem, {"base/stone-furnace", heatIcon}, "heat")
extend{stoneHeatItem}

-- Create steel heat furnace entity.
local steelHeatEnt = copy(FURNACE["steel-furnace"])
steelHeatEnt.name = "steel-furnace-heat"
steelHeatEnt.minable.result = "steel-furnace-heat"
steelHeatEnt.placeable_by = {item = "steel-furnace-heat", count = 1}
steelHeatEnt.energy_source.burner_usage = "heat-provider"
steelHeatEnt.energy_source.fuel_categories = {"heat-provider"}
steelHeatEnt.crafting_categories = {"heat-furnace"}
Icon.set(steelHeatEnt, {"LSA/from_gas_furnace/icon", heatIcon}, "heat")
-- TODO adjust steel carbon furnace and steel heat furnace to rather use graphics same as fluid-fuelled carbon furnace, since I want to give them fluid inputs/outputs.
extend{steelHeatEnt}

-- Create item for steel heat furnace.
local steelHeatItem = copy(ITEM["steel-furnace"])
steelHeatItem.name = "steel-furnace-heat"
steelHeatItem.place_result = "steel-furnace-heat"
Icon.set(steelHeatItem, {"LSA/from_gas_furnace/icon", heatIcon}, "heat")
extend{steelHeatItem}

-- Create recipes. These will be edited in infra/.
Recipe.make{
	recipe = "stone-furnace-heat",
	copy = "stone-furnace",
	results = {"stone-furnace-heat"},
	main_product = "stone-furnace-heat",
	clearIcons = true,
	enabled = true,
}
Recipe.make{
	recipe = "steel-furnace-heat",
	copy = "steel-furnace",
	results = {"steel-furnace-heat"},
	main_product = "steel-furnace-heat",
	clearIcons = true,
	addToTech = "advanced-material-processing",
}

-- TODO later we need to change all of these to assembling-machine, probably.