-- This file makes cliffs for Apollo.

-- Create them same way as Vulcanus cliffs, using same sprites.
---@type data.CliffPrototype
local apolloCliffs = scaled_cliff({ -- Global function defined in entity-util.lua.
		mod_name = "__space-age__",
		name = "cliff-apollo",
		map_color = {.322, .299, .291},
		suffix = "vulcanus",
		subfolder = "vulcanus",
		scale = 1.0,
		has_lower_layer = true,
		sprite_size_multiplier = 2,
	}
)

-- Now make all the pictures have low alpha.
local tint = {.25, .25, .25, .25}
local function setTint(ar)
	for _, pic in pairs(ar) do
		pic.tint = tint
		if pic.layers then
			setTint(pic.layers)
		end
	end
end
for _, oriented in pairs(apolloCliffs.orientations) do
	oriented = oriented ---@type data.OrientedCliffPrototype
	setTint(oriented.pictures)
	setTint(oriented.pictures_lower)
end

-- Remove player from collision mask, so players can run over them.
apolloCliffs.collision_mask = copy(RAW["utility-constants"].default.default_collision_masks.cliff)
apolloCliffs.collision_mask.layers.player = nil
apolloCliffs.collision_mask.layers.is_object = nil

extend{apolloCliffs}