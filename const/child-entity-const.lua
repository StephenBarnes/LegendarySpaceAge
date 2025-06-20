--[[ This file defines child entities that get created alongside entities, move around with them, get destroyed when the parent is destroyed, etc.
See control/child-entities.lua for how this is used.

Returned table maps entity name => child name => list of child requirements.
The child name is the name of the child entity to create.
You can require multiple children of the same name, but they should have different positions.
Each child requirement can have fields:
* pos - position relative to parent. Should be a tile center, or allow placing off-grid, otherwise we won't be able to find it to update/delete.
* adjustForOrientation - if we should move the child when parent rotates.
* preCreatedHandler - function to call before trying to create the child. Called as preCreatedHandler(parent, info that will be used to create child).
* createdHandler - function to call when child is created. Called as createdHandler(parent, child).
* destroyedHandler - function to call right before child is destroyed. Called as destroyedHandler(parentName, child).
* adjustedHandler - function to call when parent is changed (rotated, flipped, moved). Called as adjustedHandler(parent, child, wasRotated, wasFlipped). Needed for loaders, since they have direction independent of "rotating" them (changing from input to output).
* shouldTeleport - if we should teleport the child when parent rotates or moves. (Can't teleport loaders and transport belts.)
* suppressRotationsAndFlips - if false/nil, rotating/flipping the parent will also rotate/flip the child. If true, that won't happen, but the adjustedHandler will still be called.
* surfaceSet - if specified, only create the child on these surfaces.

Note that if children have the same name and position, we can get confused about which one to update/delete, so preferably don't do that. Position invisible children inside the parent entity.
	TODO maybe add table to record unit_number of children linking back to unit_number or position of parent, so we can find the correct child to update/delete. Still won't work for simple-entity children, but in that case they're probably interchangeable anyway. I don't think I actually need this for anything I want to implement though.
]]

---@type table<string, table<string, {pos: {[1]: number, [2]: number}, adjustForOrientation: boolean, surfaceSet: table<string, boolean>?, createdHandler?: fun(parent: LuaEntity, child: LuaEntity), destroyedHandler?: fun(parentName: string, child: LuaEntity), adjustedHandler?: fun(parent: LuaEntity, child: LuaEntity, wasRotated: boolean, wasFlipped: boolean), shouldTeleport: boolean?, suppressRotationsAndFlips: boolean?, preCreatedHandler?: fun(parent: LuaEntity, info: table)}[]>>
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
for _, furnaceName in pairs{"stone-furnace-air", "steel-furnace-air"} do
	Export[furnaceName] = {
		["invisible-infinity-pipe"] = {{
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

-- For stone furnace, add an fluid-vent entity to automatically vent gases.
-- Could use infinity pipes, but they need to be set to a specific fluid, and can only destroy that one fluid, and we can't connect multiple to the same fluid output because the filters conflict.
for _, furnaceName in pairs{"stone-furnace", "stone-furnace-air"} do
	if Export[furnaceName] == nil then Export[furnaceName] = {} end
	Export[furnaceName]["stone-furnace-gas-vent"] = {{
		pos = {-.5, -.5},
		adjustForOrientation = false,
		createdHandler = function(parent, child)
			child.destructible = false
			parent.fluidbox.add_linked_connection(FurnaceConst.outputLinkId, child, FurnaceConst.outputLinkId)
		end,
	}}
end

-- Add air input for burner boilers on planets with air in the atmosphere.
local BoilerConst = require("const.boiler-const")
Export["burner-boiler-air"] = {
	["invisible-infinity-pipe"] = {{
		pos = {0, 0},
		adjustForOrientation = false,
		createdHandler = function(parent, child)
			child.destructible = false
			child.set_infinity_pipe_filter({name = "air", percentage = 1})
			parent.fluidbox.add_linked_connection(BoilerConst.airLinkId, child, 1)
		end,
	}},
}

-- TODO later I'll add invisible vents to stone furnaces.

-- TODO later I might (?) add hidden beacons for furnaces, so they give a speed bonus to adjacent furnaces. Also exo/endo plants, maybe reducing fuel consumption. Probably adjust beacons' modules in on_built event, using Beacon Interface mod.

-- Add hidden loader for mini-assembler.
local function frontLoaderCreatedHandler(parent, child)
	child.destructible = false
	child.loader_type = "input"
end
local function frontLoaderAdjustedHandler(parent, child, wasRotated, wasFlipped)
	if wasRotated then
		if child.loader_type == "input" then
			child.loader_type = "output"
		else
			child.loader_type = "input"
		end
	elseif wasFlipped and (child.direction == EAST or child.direction == WEST) then
		if child.loader_type == "input" then
			child.loader_type = "output"
		else
			child.loader_type = "input"
			child.direction = ControlUtils.flipDirection(child.direction)
		end
	end
end
local function backLoaderCreatedHandler(parent, child)
	child.destructible = false
	child.direction = ControlUtils.flipDirection(parent.direction)
	child.loader_type = "output"
end
local function backLoaderAdjustedHandler(parent, child, wasRotated, wasFlipped)
	if wasRotated then
		if child.loader_type == "output" then
			child.loader_type = "input"
		else
			child.loader_type = "output"
		end
	elseif wasFlipped and (child.direction == EAST or child.direction == WEST) then
		if child.loader_type == "output" then
			child.loader_type = "input"
		else
			child.loader_type = "output"
			child.direction = ControlUtils.flipDirection(child.direction)
		end
	end
end
local function preCreatedHandler(parent, info)
	-- When fast-replacing, the onBuilt gets run before the onDestroyed handler. So it tries to build loader on top of previous loader, and fails.
	-- So instead we need to find and delete the previous loader before placing the new one.
	local prevLoader = parent.surface.find_entities_filtered{type = "loader-1x1", position = info.position}[1]
	if prevLoader ~= nil then
		prevLoader.destroy()
	end
end
for i = 1, 4 do
	Export["mini-assembler-" .. i] = {
		["lsa-loader-" .. i] = {
			{ -- Front loader (top in default orientation) - initially input, can be output if rotated/flipped.
				-- Note that since loaders can't be teleported, we reuse this child for both input and output, adjusting it to be input or output when assembler is rotated/flipped.
				pos = {0, -0.5},
				adjustForOrientation = true,
				shouldTeleport = false,
				suppressRotationsAndFlips = true,
				createdHandler = frontLoaderCreatedHandler,
				adjustedHandler = frontLoaderAdjustedHandler,
				preCreatedHandler = preCreatedHandler,
			},
			{ -- Back loader (bottom in default orientation) - initially output, can be input if flipped/mirrored.
				pos = {0, 0.5},
				adjustForOrientation = true,
				shouldTeleport = false,
				suppressRotationsAndFlips = true,
				createdHandler = backLoaderCreatedHandler,
				adjustedHandler = backLoaderAdjustedHandler,
				preCreatedHandler = preCreatedHandler,
			},
		},
	}
end

-- TODO example of a child entity that doesn't work.
--[[
Export["burner inserter"] = {
	["fast-inserter"] = {{
		pos = {2, 1},
		adjustForOrientation = true,
		createdHandler = function(parent, child)
			log("For parent position " .. serpent.line(parent.position) .. ", child position " .. serpent.line(child.position))
		end,
		adjustedHandler = function(parent, child, wasRotated, wasFlipped)
			log("Adjusted, child position " .. serpent.line(child.position))
		end,
	}},
}
]]

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

-- Add hidden beacons for regulators.
local RegulatorConst = require("const.regulator-const")
for regulatorName, regulatorVals in pairs(RegulatorConst) do
	local moduleForThisRegulator = regulatorName .. "-regulator-module"
	Export[regulatorName .. "-regulator"] = {
		["regulator-hidden-beacon"] = {{
			pos = {0, 0},
			adjustForOrientation = false,
			createdHandler = function(parent, child)
				child.destructible = false
				child.operable = false
				local moduleInventory = child.get_inventory(defines.inventory.beacon_modules)
				if moduleInventory == nil then
					log("ERROR: Regulator hidden beacon has no module inventory.")
				else
					moduleInventory.insert{name = moduleForThisRegulator, count = 1}
					-- Not giving parent's quality to module, since it's already affecting beacon's transmission power.
				end
			end,
		}},
	}
end

-- Add hidden beacon for heating tower.
Export["heating-tower"] = {
	["heating-tower-beacon"] = {{
		pos = {0, 0},
		adjustForOrientation = false,
		preCreatedHandler = function(parent, info)
			game.print("Pre-created heating tower beacon at "..serpent.line(info.position))
		end,
		createdHandler = function(parent, child)
			child.destructible = false
			game.print("Created heating tower beacon at "..serpent.line(child.position))
		end,
	}},
}

-- Add quality variants.
local QualityScaling = require("const.quality-variants")
for entName, originalName in pairs(QualityScaling.qualityToOriginal) do
	if Export[originalName] ~= nil then
		Export[entName] = Export[originalName]
	end
end

return Export