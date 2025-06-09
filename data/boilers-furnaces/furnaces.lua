--[[ This file creates the fluid-fuelled furnace, mostly copied from Adamo's Gas Furnace mod - https://mods.factorio.com/mod/gas-furnace.
Also edits other furnaces.]]

local FurnaceConst = require("const.furnace-const")

-- Graphics set for steel furnaces, giving them visible pipes. Mostly copied from Adamo's Gas Furnace mod.
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

-- Edit the base steel furnace to use new graphics, collision box.
local steelFurnace = FURNACE["steel-furnace"]
steelFurnace.graphics_set = advancedFurnaceGraphicsSet
steelFurnace.selection_box = FurnaceConst.boundingBox
steelFurnace.collision_box = FurnaceConst.boundingBox
steelFurnace.map_generator_bounding_box = FurnaceConst.boundingBox
steelFurnace.energy_source.smoke = nil -- No smoke, since it's not venting waste gases.
steelFurnace.energy_source.light_flicker = {
	color = FurnaceConst.fireGlow,
	minimum_light_size = 0.1,
	light_intensity_to_size_coefficient = 1
}
Icon.set(steelFurnace, "LSA/from_gas_furnace/icon")
local steelFurnaceItem = ITEM["steel-furnace"]
Icon.set(steelFurnaceItem, "LSA/from_gas_furnace/icon")

-- Edit the base stone furnace to use the same collision box as the rest of them.
local stoneFurnace = FURNACE["stone-furnace"]
stoneFurnace.selection_box = FurnaceConst.boundingBox
stoneFurnace.collision_box = FurnaceConst.boundingBox
stoneFurnace.map_generator_bounding_box = FurnaceConst.boundingBox

-- Add factoriopedia descriptions.
for _, name in pairs{"stone-furnace", "steel-furnace"} do
	FURNACE[name].factoriopedia_description = {"factoriopedia-description." .. name}
end