--[[ This file edits nuclear reactors to work with the heat shuttle system.
Basically we want to hide the vanilla "reactor"-type nuclear reactor, and create a new one that's a crafting machine, which burns nuclear fuel and does heating recipes.
]]

-- Create nuclear-nonreactor entity.
local baseNuclearReactor = RAW.reactor["nuclear-reactor"]
---@type data.FurnacePrototype
local ent = {
	name = "nuclear-nonreactor",
	type = "furnace",
	icon = baseNuclearReactor.icon,
	icon_size = baseNuclearReactor.icon_size,
	icons = baseNuclearReactor.icons,
	crafting_categories = {"crafting"}, -- TODO change to "heating" once that recipe category exists.
	source_inventory_size = 1,
	result_inventory_size = 1,
	energy_source = baseNuclearReactor.energy_source,
	energy_usage = baseNuclearReactor.consumption,
	crafting_speed = 10,
	module_slots = 0,
	minable = {
		mining_time = 0.5,
		result = "nuclear-nonreactor",
	},
	localised_name = baseNuclearReactor.localised_name or {"entity-name.nuclear-reactor"},
	localised_description = baseNuclearReactor.localised_description or {"entity-description.nuclear-reactor"},
	factoriopedia_description = baseNuclearReactor.factoriopedia_description,
	max_health = baseNuclearReactor.max_health,
	corpse = baseNuclearReactor.corpse,
	dying_explosion = baseNuclearReactor.dying_explosion,
	placeable_by = {item = "nuclear-nonreactor", count = 1},
	collision_box = baseNuclearReactor.collision_box,
	selection_box = baseNuclearReactor.selection_box,
	allowed_effects = {},
	damaged_trigger_effect = baseNuclearReactor.damaged_trigger_effect,
	impact_category = baseNuclearReactor.impact_category,
	working_sound = baseNuclearReactor.working_sound,
	open_sound = baseNuclearReactor.open_sound,
	close_sound = baseNuclearReactor.close_sound,
	graphics_set = {
		animation = {
			layers = {
				{
					filename = "__base__/graphics/entity/nuclear-reactor/reactor.png",
					width = 302,
					height = 318,
					scale = 0.5,
					shift = util.by_pixel(-5, -7)
				},
				{
					filename = "__LegendarySpaceAge__/graphics/misc/nuclear-reactor-shadow-no-heat-pipes.png",
					width = 525,
					height = 323,
					scale = 0.5,
					shift = { 1.625, 0 },
					draw_as_shadow = true
				},
			},
		},
		working_visualisations = {
			{
				effect = "uranium-glow",
				light = {intensity = 0.5, size = 4, shift = {0, 0}, color = {0, 1, 0}},
				fadeout = true,
			},
			{
				effect = "uranium-glow",
				fadeout = true,
				constant_speed = true,
				animation = {
					layers = {
						{
							filename = "__base__/graphics/entity/nuclear-reactor/reactor-lights-color.png",
							blend_mode = "additive",
							draw_as_glow = true,
							width = 320,
							height = 320,
							scale = 0.5,
							shift = { -0.03125, -0.1875 },
						},
					},
				},
			},
		},
	},
	-- TODO check sound
	-- TODO meltdown action? sth similar for destroyed crafting machine?
	--[[
	meltdown_action = {
		type = "direct",
		action_delivery = {
			type = "instant",
			target_effects = {{
				type = "create-entity",
				entity_name = "atomic-rocket"
			}}
		},
	},
	]]
}
local nuclearReactorConnector = circuit_connector_definitions["nuclear-reactor"]
ent.circuit_connector = {nuclearReactorConnector, nuclearReactorConnector, nuclearReactorConnector, nuclearReactorConnector}
extend{ent}

-- Create nuclear-nonreactor item.
local item = copy(ITEM["nuclear-reactor"])
item.name = "nuclear-nonreactor"
item.place_result = "nuclear-nonreactor"
extend{item}

-- Create nuclear-nonreactor recipe.
Recipe.make{
	copy = "nuclear-reactor",
	recipe = "nuclear-nonreactor",
	resultCount = 1,
	category = "crafting",
}

-- Edit nuclear tech to replace the other recipe with the new one.
Tech.replaceRecipeInTech("nuclear-reactor", "nuclear-nonreactor", "nuclear-power")

-- Hide the old nuclear reactor item, entity, recipe.
Item.hide("nuclear-reactor", "nuclear-nonreactor")
Recipe.hide("nuclear-reactor", "nuclear-nonreactor")
Entity.hide(baseNuclearReactor, nil, "nuclear-nonreactor")