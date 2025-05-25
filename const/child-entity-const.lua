--[[ This file defines child entities that get created alongside entities, move around with them, get destroyed when the parent is destroyed, etc.
See control/child-entities.lua for how this is used.

Returned table maps entity name => child name => list of child requirements.
The child name is the name of the child entity to create.
You can require multiple children of the same name, but they should have different positions.
Each child requirement can have fields:
* pos - position relative to parent. Should be a tile center, or allow placing off-grid, otherwise we won't be able to find it to update/delete.
* adjustForOrientation - if we should move the child when parent rotates.
* createdHandler - function to call when child is created. Called as createdHandler(parent, child).
* destroyedHandler - function to call right before child is destroyed. Called as destroyedHandler(parentName, child).

Note that if children have the same name and position, we can get confused about which one to update/delete, so preferably don't do that. Position invisible children inside the parent entity.
	TODO maybe add table to record unit_number of children linking back to unit_number or position of parent, so we can find the correct child to update/delete. Still won't work for simple-entity children, but in that case they're probably interchangeable anyway. I don't think I actually need this for anything I want to implement though.
]]

local Export = {}

-- Create steam-evilizers for condensing turbines. This is so we can give condensing turbines lower efficiency than normal steam turbines, see data/pre-space/condensing-turbine.lua.
Export["condensing-turbine-evil"] = {
	["steam-evilizer"] = {{
		pos = {0, 0},
		adjustForOrientation = false,
		createdHandler = function(parent, child)
			child.destructible = false
			parent.fluidbox.add_linked_connection(1, child, 1)
		end,
	}},
}

-- Add air input for furnaces on planets with air in the atmosphere.
local FurnaceConst = require("const.furnace-const")
for _, furnaceName in pairs{"stone-furnace-air", "steel-furnace-air", "ff-furnace-air"} do
	Export[furnaceName] = {
		["invisible-fluid-supplier"] = {{
			pos = {.5, .5},
			adjustForOrientation = false,
			createdHandler = function(parent, child)
				child.destructible = false
				child.set_infinity_pipe_filter({name = "air", percentage = 1})
				parent.fluidbox.add_linked_connection(FurnaceConst.airLinkId, child, 1)
			end,
		}},
	}
end

-- TODO later I'll add invisible vents to stone furnaces.

-- TODO later I'll add checkerboard beacons for furnaces, so they give a speed bonus to adjacent furnaces (but checkerboard so they don't affect themselves).

-- Create exclusion zones for some entities, to prevent them from being built too close to each other.
local ExclusionZoneConst = require("const.exclusion-zones")
local function handleExclusionZoneCreation(parent, child)
	child.destructible = false
end
for entName, exclusionZoneConst in pairs(ExclusionZoneConst) do
	exclusionCenterDist = prototypes.entity[entName .. "-exclusion-1"].collision_box.right_bottom.y + exclusionZoneConst.size / 2
	if Export[entName] == nil then Export[entName] = {} end
	Export[entName][entName .. "-exclusion-1"] = { -- Create vertical exclusion zones.
		{
			pos = {0, exclusionCenterDist},
			adjustForOrientation = false,
			createdHandler = handleExclusionZoneCreation,
		},
		{
			pos = {0, -exclusionCenterDist},
			adjustForOrientation = false,
			createdHandler = handleExclusionZoneCreation,
		},
	}
	Export[entName][entName .. "-exclusion-2"] = { -- Create horizontal exclusion zones.
		{
			pos = {exclusionCenterDist, 0},
			adjustForOrientation = false,
			createdHandler = handleExclusionZoneCreation,
		},
		{
			pos = {-exclusionCenterDist, 0},
			adjustForOrientation = false,
			createdHandler = handleExclusionZoneCreation,
		},
	}
end

-- Add quality variants.
local QualityScaling = require("const.quality-scaling-power-consumption")
for entName, originalName in pairs(QualityScaling.qualityToOriginal) do
	if Export[originalName] ~= nil then
		Export[entName] = Export[originalName]
	end
end

return Export