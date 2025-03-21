--[[ This file has data-stage tools for creating exclusion zone entities.
These entities are used to prevent building entities too close to other entities of the same type.
Currently used for telescopes, deep drills, and air separators.

We create simple-entities for the exclusion zones. One is more horizontal, the other more vertical.
We place 4 of these around the entity, one on each side. That way we leave a gap in the middle for the entity to be built. This is necessary for ghosts to not get destroyed by their own exclusion zones.
]]

local Const = require "util.const.exclusion-zones"

local ALLOW_SELECT = false -- Whether to allow selecting the exclusion zones, for debugging.

---@param ent data.EntityPrototype
local function create(ent)
	local dims = Const[ent.name].dims
	assert(dims ~= nil, "No dimensions for entity "..ent.name.." in Const.exclusionZones.")
	local exclusionEntName = ent.name .. "-exclusion"
	local collisionLayerName = exclusionEntName
	local icons = {
		{
			icon = ent.icon,
			icon_size = 64,
			scale = 0.5,
		},
		{
			icon = "__LegendarySpaceAge__/graphics/misc/no.png",
			icon_size = 64,
			scale = 0.5,
		},
	}
	local localisedName = {"entity-name." .. exclusionEntName}
	local localisedDescription = {"entity-description." .. exclusionEntName}
	local tileSize = Const[ent.name].size
	assert((tileSize == ent.tile_width) and (tileSize == ent.tile_height),
		"Entity "..ent.name.." must have square size equal to what's set in constants file.")

	local collisionBox = {{-dims[1]/2, -dims[2]/2}, {dims[1]/2, dims[2]/2}}
	---@type data.SimpleEntityPrototype
	local exclusion1 = {
		type = "simple-entity",
		name = exclusionEntName .. "-1",
		icons = icons,
		selection_box = Gen.ifThenElse(ALLOW_SELECT, collisionBox, nil),
		collision_box = collisionBox,
		selection_priority = 1, -- So other stuff on top of it gets selected instead of this. Seems chests are 50, setting this to 0 makes it actually 50 in-game. So I'm guessing 0 doesn't work, but other than that higher number gets selected preferentially.
		selectable_in_game = ALLOW_SELECT,
		collision_mask = {layers={[collisionLayerName] = true}},
		localised_name = localisedName,
		localised_description = localisedDescription,
		remove_decoratives = "false",
		flags = {"not-on-map", "not-repairable", "not-deconstructable", "not-flammable", "not-blueprintable", "placeable-neutral"},
		allow_copy_paste = false,
		hidden_in_factoriopedia = true,
	}
	local exclusion2 = copy(exclusion1)
	exclusion2.name = exclusionEntName .. "-2"
	local collisionBox2 = {{-dims[2]/2, -dims[1]/2}, {dims[2]/2, dims[1]/2}}
	exclusion2.selection_box = Gen.ifThenElse(ALLOW_SELECT, collisionBox2, nil)
	exclusion2.collision_box = collisionBox2
	extend{exclusion1, exclusion2}

	-- Create collision layer.
	assert(data.raw["collision-layer"][collisionLayerName] == nil, "Collision layer "..collisionLayerName.." already exists.")
	extend{{
		type = "collision-layer",
		name = collisionLayerName,
	}}

	-- Set Entity.radius_visualisation_specification to show the exclusion zone.
	assert(ent.radius_visualisation_specification == nil, "Entity "..ent.name.." already has a radius visualisation specification.")
	ent.radius_visualisation_specification = {
		sprite = {
			filename = "__LegendarySpaceAge__/graphics/exclusion-zones/grid_" .. dims[1] .. "_" .. dims[2] .. ".png",
			priority = "extra-high-no-scale",
			width = dims[2] * 2 + tileSize,
			height = dims[2] * 2 + tileSize,
		},
		distance = dims[2] + tileSize/2,
	}

	if ent.collision_mask == nil then
		ent.collision_mask = copy(RAW["utility-constants"].default.building_collision_mask)
	end
	ent.collision_mask.layers[collisionLayerName] = true
end

return {
	create = create,
}