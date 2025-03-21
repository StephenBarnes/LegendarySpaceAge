-- This file creates "drill nodes", which are placed on world gen and can be harvested with a borehole drill to produce extra resources (eg ice on Apollo, or iron/copper/coal/uranium nodes on Nauvis). Mostly created to provide ice on Apollo.

-- Constants are in separate file, since they're also used in control stage.
local NodeVals = require("util.const.drill-nodes")

-- Define a meta-prototype copied and edited to make the nodes' prototypes.
local nodeProto = copy(RAW.resource["crude-oil"])
	-- Using type "resource" so it gets highlighted on map, and isn't destructible.
nodeProto.tile_width = NodeVals.sideLen
nodeProto.tile_height = NodeVals.sideLen
nodeProto.selection_box = {
	{-NodeVals.sideLen/2, -NodeVals.sideLen/2},
	{NodeVals.sideLen/2, NodeVals.sideLen/2},
}
nodeProto.selection_priority = 41
	-- So borehole mining drills, or other buildings on top of it, which are priority 50 get selected first, but it gets selected over ores (priority 40) that cover it. (Because I'm planning to make nodes generate under ore patches, maybe.)
--nodeProto.render_layer = "above-tiles"
nodeProto.stages = {
	sheet = {
		filename = "__LegendarySpaceAge__/graphics/drill-nodes/01.png",
		priority = "extra-high",
		size = 194,
		frame_count = 1,
		variation_count = 1,
		scale = 1,
	},
	-- TODO add the rest of the pictures. Probably even in a spritesheet.
}
nodeProto.autoplace = nil -- TODO add autoplace.
nodeProto.infinite = true
nodeProto.minimum = 1
nodeProto.normal = 1
nodeProto.stateless_visualisation = nil -- Remove crude oil bubbling animation.
nodeProto.category = "drill-node"
nodeProto.placeable_by = { -- For picking.
	item = "deep-drill",
	count = 1,
}

-- Create entities.
for _, spec in pairs(NodeVals.specs) do
	local ent = copy(nodeProto)
	ent.name = "drill-node-" .. spec.name
	ent.stages.sheet.tint = spec.entTint
	ent.icon = nil
	ent.icons = {
		{icon = "__LegendarySpaceAge__/graphics/drill-nodes/icon.png", icon_size = 64, tint = spec.iconTint},
	}
	ent.minable = {
		mining_time = 1,
		results = spec.results,
	}
	-- Add smoke animation, like for crude oil.
	ent.stateless_visualisation = {
		{
			count = 1,
			render_layer = "smoke",
			animation = {
				filename = "__base__/graphics/entity/crude-oil/oil-smoke-outer.png",
				frame_count = 47,
				line_length = 16,
				width = 90,
				height = 188,
				animation_speed = 0.18,
				shift = {-0.3, -7.5},
				scale = 2.7,
				tint = util.multiply_color(spec.entTint, 0.12)
			}
		},
		-- Crude oil also has "oil-smoke-inner", but I'm not using that here bc the drill node is bigger than a crude oil spot.
	}
	ent.map_color = spec.mapTint
	extend{ent}
end

-- Create category for drill nodes.
extend{{
	type = "resource-category",
	name = "drill-node",
	order = "z",
}}

-- Create a fake borehole-drill entity, specifically just for the "mined by" here.
local deepDrill = ASSEMBLER["deep-drill"]
local dummyMiner = copy(RAW["mining-drill"]["pumpjack"])
dummyMiner.name = "drill-node-dummy-miner"
dummyMiner.type = "mining-drill"
dummyMiner.resource_categories = {"drill-node"}
dummyMiner.icon = deepDrill.icon
dummyMiner.localised_name = {"entity-name.deep-drill"}
dummyMiner.localised_description = {"entity-description.deep-drill"}
dummyMiner.subgroup = "extraction-machine"
dummyMiner.minable = nil
dummyMiner.placeable_by = { item = "deep-drill", count = 1 }
---@diagnostic disable-next-line: assign-type-mismatch
dummyMiner.graphics_set = deepDrill.graphics_set
dummyMiner.base_picture = nil
dummyMiner.stateless_visualisation = nil
dummyMiner.energy_source = deepDrill.energy_source
dummyMiner.energy_usage = deepDrill.energy_usage
--dummyMiner.hidden = true
--dummyMiner.hidden_in_factoriopedia = true
dummyMiner.factoriopedia_alternative = "deep-drill" -- Doesn't seem to work, but it's fine.
dummyMiner.factoriopedia_simulation = nil
dummyMiner.input_fluid_box = nil
dummyMiner.output_fluid_box = nil
dummyMiner.resource_searching_radius = (11 / 2) - 0.01 -- So it says it's 11x11.
dummyMiner.tile_height = deepDrill.tile_height
dummyMiner.tile_width = deepDrill.tile_width
dummyMiner.collision_box = deepDrill.collision_box
dummyMiner.selection_box = deepDrill.selection_box
dummyMiner.resource_drain_rate_percent = 1 -- Actually 0 but we can't set that.
dummyMiner.max_health = deepDrill.max_health
extend{dummyMiner}


-- Create recipes.
for i, spec in pairs(NodeVals.specs) do
	Recipe.make{
		copy = "deep-drill",
		recipe = "recipe-drill-node-" .. spec.name,
		ingredients = {},
		results = spec.results,
		order = tostring(i),
		localised_name = {"recipe-name.node-drilling", {"entity-name.drill-node-" .. spec.name}},
		localised_description = {"recipe-description.node-drilling", "drill-node-" .. spec.name},
		icons = {"deep-drill", "drill-node-" .. spec.name},
		iconArrangement = "planetFixed",
		category = "deep-drill",
		allow_productivity = true,
		allow_quality = true,
		hide_from_player_crafting = true,
		subgroup = "deep-drilling",
		show_amount_in_title = false,
		time = 1,
		addToTech = spec.addToTech,
		crafting_machine_tint = {
			primary = spec.entTint,
			secondary = spec.iconTint,
		},
	}
end