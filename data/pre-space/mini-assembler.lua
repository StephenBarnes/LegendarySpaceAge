--[[ This file creates mini-assemblers / classifiers, which are 2x1 furnaces with 2 loaders (input and output) automatically created.
The loaders are specified in child-entity-const.lua, which is then read by child-entities.lua, which creates the loaders.

These are used for "classifying" items into factor intermediates, for recipes that don't logically require any assembling work. (For example classifying sand as "filler" so it can be used to make plastic or concrete.)

Observations while trying to make this:
* In control-stage code (child-created handler), setting loader.drop_target to the parent entity doesn't work, value stores nil after setting it.
* In control-stage code (child-created handler), setting loader.drop_position to the parent entity's position doesn't work, throws error saying it's "not an inserter".
* Trying to put a loader at non-integer coordinates doesn't work, it gets rounded to nearest map tile.
* Can create loader on top of assembler, but it still belongs to a specific tile, so can't put 2 loaders in one tile.
* By setting loader.container_distance = 0, it outputs into the same tile it's currently on, which is inside the assembler. So this is the solution used here - make assembler 2x1, with 2 loaders overlapping the assembler, each loader loading into its own tile (ie into the assembler).
]]

-- Create recipe category.
extend{{
	type = "recipe-category",
	name = "mini-assembling",
}}

-- Tiers of transport belts. TODO factor this out into a const file, and then also use that in the infra file that sets belt speeds.
local tiers = {
	[1] = {
		tint = {.961, .745, .205},
		speed = 10,
		splitter = "splitter",
		techName = "logistics",
		simulation = "0eNqllNtuwyAMht/F16QKWdI2eZWpimjidkgEEDjVqirvPkh26HrQEu0S/Pv7sTFcYK96tE5qguoCsjHaQ/V6AS+PWqi4p0WHUAE5ob01jpI9KoKBgdQtvkPFB/ZAroxo0V3JsmHHADVJkjhZjItzrftuH5QVZ1+5Uh+kDqGkeUNPwMAaH9KMjvyAWq8KBmeoknxVjAaTvPZIJPXRR5nDzpyw7kNMETpsa0nYhdBBKI8Mpu3pIJ+2jbEWXWKVIAymjeljU3iaMuhMGxWCEoViPNJ38bsh1n9TS8Zu+nBXw/a6glY6bKZgzoDONmaanmwfG31Hf2FPLuXOpfzdqWufB9x8NpfzReBiPjhdBF7PBxeLwJv54HwReDsfvF4ELv8cOf73zEn9ZOR4Ovt18vI/z5Ncj0P8KuI6uP18TwxO4cGOPsU6K/OyLDZpVmzKbBg+AMnoliQ=",
	},
	[2] = {
		tint = {.97, .22, .16},
		speed = 20,
		splitter = "fast-splitter",
		techName = "logistics-2",
		simulation = "0eNqllFtugzAQRfcy3ybCFEhgK1WEHJiklsC27CFqFLH32tBH2iRtrH4yj3M9l7HPsOtHNFYqgvoMstXKQf18BicPSvQhpsSAUMNeOErICuWMtpTssCeYGEjV4SvUfGL3enotOrQXtdm0ZYCKJElcxOaPU6PGYecra84+AFLtpfKppH1BR8DAaOfbtAoiHlWuCgYnqJN0VcwCS3njkEiqgwtlFgd9xGb0uZ7QYtdIwsGn9qJ3yGAJLwd5l221MWgT0wtCL9rqMdjD05TBoLtQIfxcKOYjfTqwnYIJP2bJ2C0zrgbZXI7RSYvtkswZ0MmEdj2SGYPlVxJP7Ld/dCVVfffsUuwGPI+Dcx5FLyLpaRS9jKQXUfR1JD2Pom8i6WUUvXpsK/nfaynVna3k6cO3mFf/vsZTeFNCwMt9vWgMjv5mz0JFmVV5VRXrNCvWVTZNb8AoqNU=",
	},
	[3] = {
		tint = {.17, .77, .93},
		speed = 50,
		splitter = "express-splitter",
		techName = "logistics-3",
		simulation = "0eNqllN2OwiAQhd9lrqkptVXbV9mYprajS0KBwNRoTN99od0fd11XyV7CDN9hDjNcYCcHNFYoguoCotXKQfVyAScOqpFhTzU9QgV4MhadS8g2yhltKdmhJBgZCNXhCSo+sj+OSd10aK/Ss3HLABUJEjhLTotzrYZ+5zMrzj4YQu2F8qGkfUVHwMBo549pFXQ8arUoGJyhWi6KiT9n1w6JhDq4kGWx10esBx+ThBa7WhD2PrRvpEMG8/Z8j3fVVhuDNjGyIfSarR6CRzxNGfS6CxkNJRKb6UafHmzHYMOPUjJ2x46bUjZXhXTCYjvHcgZ0NgGgBzJDsP1GZMkePNWNWPnNt2u5X/B5NJ6nMfwins9j+Kt4fh7DX8fzixj+Jp6/iuGXT/cof9ikQt3pUZ4+PdS8/MdUkx1wDB9MWHuxr0+OwdHP+SRTrLIyL8tinWbFuszG8Q1MZrR+",
	},
	[4] = {
		tint = {.675, .81, .325},
		speed = 100,
		splitter = "turbo-splitter",
		techName = "turbo-transport-belt",
		simulation = "0eNqllNtuwyAMht/F16QKWQ5NXmWqIpK4HVICiDjVqirvPkh26NZ2K9ol2P5+/GM4Q9NPaKxUBNUZZKvVCNXzGUZ5UKL3e0oMCBXQZBsdkRVqNNpS1GBPMDOQqsNXqPjM7hb1WnRoL5KTeccAFUmSuMoti1OtpqFxmRVnHwSp9lK5UNS+4EjAwOjRlWnlVRwq32QMTlAVm2zhr9n1iERSHUafZXHQR6wnF+sJLXa1JBxcaC/6ERms2+s53lVbbQzayPSC0Gm2evL+8DhmMOjOZwiKehTLiT4d2M3ehB+tJOymGVeNbC/a6KTFdo2lDOhkfLmeyEze8iuJJ/brJV1Jld88uxS7AU8D4ZyH0LNQehxCz0PpWQi9CKWnIfRtKD0PoZcPTiX/cyylujOVPH74EfPyH6+Y7ISz/1D82ol9fWgMju5dLzJZnpRpWWZFnGRFmczzG2Y3q/o=",
	},
}

local circuitConnectors = circuit_connector_definitions.create_vector(
	universal_connector_template,
	{
		{ variation = 2,  main_offset = util.by_pixel(0.75, -18),       shadow_offset = util.by_pixel(0.75, -18),       show_shadow = true },
		{ variation = 2,  main_offset = util.by_pixel(-8.375, -11.625), shadow_offset = util.by_pixel(-8.375, -11.625), show_shadow = true },
		{ variation = 2,  main_offset = util.by_pixel(0.75, -18),       shadow_offset = util.by_pixel(0.75, -18),       show_shadow = true },
		{ variation = 2,  main_offset = util.by_pixel(-8.375, -11.625), shadow_offset = util.by_pixel(-8.375, -11.625), show_shadow = true },
	}
)

for tier, tierVals in pairs(tiers) do
	-- Create mini-assembler.
	---@type data.FurnacePrototype
	---@diagnostic disable-next-line: assign-type-mismatch
	local miniAssembler = copy(ASSEMBLER["assembling-machine-1"])
	miniAssembler.name = "mini-assembler-" .. tier
	miniAssembler.type = "furnace"
	miniAssembler.tile_height = 2
	miniAssembler.tile_width = 1
	miniAssembler.minable = {mining_time = 0.1, result = "mini-assembler-" .. tier}
	miniAssembler.crafting_categories = {"mini-assembling"}
	miniAssembler.placeable_by = {item = "mini-assembler-" .. tier, count = 1}
	miniAssembler.source_inventory_size = 1
	miniAssembler.result_inventory_size = 1
	miniAssembler.fast_replaceable_group = "mini-assembler"
	if tiers[tier + 1] ~= nil then
		miniAssembler.next_upgrade = "mini-assembler-" .. (tier + 1)
	else
		miniAssembler.next_upgrade = nil
	end
	local graphicsDir = "__LegendarySpaceAge__/graphics/mini-assembler/"
	local graphicsScale = 0.5
	local graphicsShiftEW = {0, 0.05} -- Looks fine.
	local graphicsShiftNS = {0, 0.12} -- Looks fine.
	miniAssembler.graphics_set = {
		animation = {
			north = {
				layers = {
					{
						filename = graphicsDir .. "S.png",
						width = 70,
						height = 99,
						frame_count = 1,
						line_length = 1,
						shift = graphicsShiftNS,
						scale = graphicsScale,
					},
					{
						filename = graphicsDir .. "tint/S.png",
						width = 70,
						height = 99,
						frame_count = 1,
						line_length = 1,
						shift = graphicsShiftNS,
						scale = graphicsScale,
						tint = tierVals.tint,
					},
					{
						filename = graphicsDir .. "NS_shadow.png",
						width = 111,
						height = 100,
						frame_count = 1,
						line_length = 1,
						shift = graphicsShiftNS,
						scale = graphicsScale,
						draw_as_shadow = true,
					},
				}
			},
			south = {
				layers = {
					{
						filename = graphicsDir .. "N.png",
						width = 70,
						height = 99,
						frame_count = 1,
						line_length = 1,
						shift = graphicsShiftNS,
						scale = graphicsScale,
					},
					{
						filename = graphicsDir .. "tint/N.png",
						width = 70,
						height = 99,
						frame_count = 1,
						line_length = 1,
						shift = graphicsShiftNS,
						scale = graphicsScale,
						tint = tierVals.tint,
					},
					{
						filename = graphicsDir .. "NS_shadow.png",
						width = 111,
						height = 100,
						frame_count = 1,
						line_length = 1,
						shift = graphicsShiftNS,
						scale = graphicsScale,
						draw_as_shadow = true,
					},
				}
			},
			east = {
				layers = {
					{
						filename = graphicsDir .. "W.png",
						width = 68,
						height = 77,
						frame_count = 1,
						line_length = 1,
						shift = graphicsShiftEW,
						scale = graphicsScale,
					},
					{
						filename = graphicsDir .. "tint/W.png",
						width = 68,
						height = 77,
						frame_count = 1,
						line_length = 1,
						shift = graphicsShiftEW,
						scale = graphicsScale,
						tint = tierVals.tint,
					},
					{
						filename = graphicsDir .. "EW_shadow.png",
						width = 123,
						height = 80,
						frame_count = 1,
						line_length = 1,
						shift = graphicsShiftEW,
						scale = graphicsScale,
						draw_as_shadow = true,
					},
				}
			},
			west = {
				layers = {
					{
						filename = graphicsDir .. "E.png",
						width = 68,
						height = 77,
						frame_count = 1,
						line_length = 1,
						shift = graphicsShiftEW,
						scale = graphicsScale,
					},
					{
						filename = graphicsDir .. "tint/E.png",
						width = 68,
						height = 77,
						frame_count = 1,
						line_length = 1,
						shift = graphicsShiftEW,
						scale = graphicsScale,
						tint = tierVals.tint,
					},
					{
						filename = graphicsDir .. "EW_shadow.png",
						width = 123,
						height = 80,
						frame_count = 1,
						line_length = 1,
						shift = graphicsShiftEW,
						scale = graphicsScale,
						draw_as_shadow = true,
					},
				}
			},
		}
	}
	-- NOTE there's weird engine behavior where 2x1 assemblers with no fluidboxes behave weirdly when you rotate them. Rotation event gets fired but the assembler's .direction doesn't change, and directional sprites don't update, and assigning assembler.direction / .mirroring / .orientation does nothing, value stays the same. So I'll add a fluidbox so that rotations work as expected.
	miniAssembler.fluid_boxes = {
		{
			production_type = "output",
			hide_connection_info = true,
			volume = 10,
			pipe_connections = {
				{
					position = {0, 0.5},
					direction = WEST,
					connection_type = "linked",
					linked_connection_id = 1,
				}
			}
		}
	}
	miniAssembler.selection_box = {{-0.5, -1}, {0.5, 1}}
	miniAssembler.collision_box = {{-0.45, -1}, {0.45, 1}}
	miniAssembler.crafting_speed = tierVals.speed * 0.1 -- All of these recipes take 0.1 seconds.
	miniAssembler.open_sound = copy(data.raw.container["iron-chest"].open_sound)
	miniAssembler.close_sound = copy(data.raw.container["iron-chest"].close_sound)
	miniAssembler.working_sound = nil
	miniAssembler.build_sound = nil
	miniAssembler.mined_sound = nil
	-- Circuit connectors, using https://mods.factorio.com/mod/circuit-connector-placement-helper
	miniAssembler.circuit_connector = circuitConnectors
	miniAssembler.alert_icon_shift = {0, -0.2}
	miniAssembler.icon_draw_specification.shift = {0, -0.15}
	miniAssembler.energy_source = {
		type = "void",
	}
	miniAssembler.max_health = 150
	miniAssembler.icon = nil
	miniAssembler.icons = {
		{icon = "__LegendarySpaceAge__/graphics/mini-assembler/icon.png"},
		{icon = "__LegendarySpaceAge__/graphics/mini-assembler/tint/icon.png", tint = tierVals.tint},
	}
	miniAssembler.allowed_effects = {}
	miniAssembler.allowed_module_categories = {}
	miniAssembler.localised_description = {"entity-description.mini-assembler"}
	miniAssembler.factoriopedia_simulation = { init = [[
		game.simulation.camera_position = {0, 0.5}
		game.simulation.camera_zoom = 3.5
		game.surfaces[1].create_entities_from_blueprint_string{
			string = "]]
			.. tierVals.simulation .. [[",
			position = {0, 0}
		}
		local ma = game.surfaces[1].create_entity{name = "mini-assembler-]] .. tier .. [[", position = {-0.5, 0}, direction = 12}
		local l1 = game.surfaces[1].create_entity{name = "lsa-loader-]] .. tier .. [[", position = {0, 0}, direction = 4}
		local l2 = game.surfaces[1].create_entity{name = "lsa-loader-]] .. tier .. [[", position = {-1, 0}, direction = 12}
		l1.loader_type = "output"
		l2.loader_type = "input"
		l1.update_connections()
		l2.update_connections()
		ma.update_connections()
		]]
	}
	extend{miniAssembler}

	local miniAssemblerItem = copy(ITEM["assembling-machine-1"])
	miniAssemblerItem.name = "mini-assembler-" .. tier
	miniAssemblerItem.place_result = "mini-assembler-" .. tier
	miniAssemblerItem.icon = nil
	miniAssemblerItem.icons = miniAssembler.icons
	miniAssemblerItem.stack_size = 100
	miniAssemblerItem.weight = ROCKET / 200
	extend{miniAssemblerItem}

	local hiddenLoader = copy(data.raw["loader-1x1"]["loader-1x1"])
	hiddenLoader.name = "lsa-loader-" .. tier
	hiddenLoader.structure = nil
	hiddenLoader.container_distance = 0
	hiddenLoader.allow_container_interaction = true
	hiddenLoader.selection_priority = 200 -- So it can be selected in editor mode.
	hiddenLoader.selection_box = {{-0.3, -0.3}, {0.3, 0.3}}
	hiddenLoader.flags = {
		"no-automated-item-removal",
		"no-automated-item-insertion",
		"player-creation",
		"not-on-map",
		"not-blueprintable",
		"not-deconstructable",
		"not-on-map",
	}
	hiddenLoader.selectable_in_game = false
	hiddenLoader.collision_mask = {layers={transport_belt=true}}
	hiddenLoader.speed = tierVals.speed / 480 -- This speed property holds 1/480 of items per second according to docs.
	hiddenLoader.belt_animation_set = data.raw.splitter[tierVals.splitter].belt_animation_set
	extend{hiddenLoader}

	-- Create recipe. Will be edited in infra files.
	Recipe.make{
		copy = "assembling-machine-1",
		recipe = "mini-assembler-" .. tier,
		resultCount = 1,
		time = 1,
		addToTech = tierVals.techName,
	}
end