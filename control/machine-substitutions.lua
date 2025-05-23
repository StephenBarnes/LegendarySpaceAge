--[[
This file swaps buildings on build, for 2 cases:
	* We can swap depending on surface.
		For example: to make rocket silos on Apollo only need 10 parts per rocket, we swap them to rocket-silo-10parts.
		For example: to make furnaces on Nauvis and Gleba not need external air input.
	* We can swap depending on quality.
		For example: to make entities scale their power consumption in line with their speed.
			This is necessary to prevent free-energy exploits using e.g. quality battery chargers that produce more energy than they consume. And similar for char recipe, and gasifier.
			See data/final-fixes/quality-power-scaling.lua for the data-side of this and more explanation.
]]

local SurfaceSubstitutions = require("const.planet-machine-substitutions-const")
local QualitySubstitutions = require("const.quality-scaling-power-consumption")

local MiscConst = require("const.misc-const")
local qualitySeparator = MiscConst.qualitySeparator
local qualitySuffixLen = #qualitySeparator + MiscConst.qualityNumDigits

-- Given entity base name (quality suffix removed), returns true if it's subject to quality scaling.
local function entityQualityScales(entType, entName)
	return (QualitySubstitutions[entType] ~= nil) and QualitySubstitutions[entType][entName]
end

-- Given entity name, removes quality suffix, if any.
---@param entName string
---@return string
local function trimQualitySuffix(entName)
	-- Check if the name ends with the quality separator followed by number.
	if #entName <= qualitySuffixLen then return entName end
	local qualitySeparatorPlusNumber = entName:sub(-qualitySuffixLen)
	local possibleQualitySeparator = qualitySeparatorPlusNumber:sub(1, #qualitySeparator)
	if possibleQualitySeparator ~= qualitySeparator then return entName end
	return entName:sub(1, -qualitySuffixLen-1)
end

-- Given entity name and quality, add quality suffix. For normal quality, doesn't add anything.
---@param entName string
---@param quality LuaQualityPrototype
---@return string
local function addQualitySuffx(entName, quality)
	if quality.level == 0 then return entName end
	return entName..qualitySeparator..string.format("%0"..MiscConst.qualityNumDigits.."d", quality.level)
end

-- When an entity is built, replace it with other entity, applying surface and quality substitutions.
---@param event EventData.on_built_entity|EventData.on_robot_built_entity|EventData.on_space_platform_built_entity|EventData.script_raised_built|EventData.script_raised_revive|EventData.on_entity_cloned
local function onBuilt(event)
	local ent = event.entity
	if ent == nil or not ent.valid then return end
	local surface = ent.surface
	if surface == nil or not surface.valid then return end

	--[[ General approach:
	1. Get name of entity, or if it's a ghost, get name of what it's ghosting.
	2. From ent's name, remove quality suffix, if any.
	3. If the entity is subject to surface substitutions, then substitute it with the correct name for that surface.
	4. If the new, surface-substituted entity is subject to quality scaling, then add quality suffix.
	5. If the final "correct name" differs from the entity's name, then destroy the entity and create a new one with the correct name.
	]]

	local entName, entType, isGhost
	if ent.name ~= "entity-ghost" then
		entName, entType, isGhost = ent.name, ent.type, false
	else
		entName, entType, isGhost = ent.ghost_name, ent.ghost_type, true
	end

	local nameWithoutQuality = trimQualitySuffix(entName)

	local nameAfterSurfaceSubst = entName
	local typeSubstitutions = SurfaceSubstitutions[entType]
	if typeSubstitutions ~= nil then
		local substitutions = typeSubstitutions[nameWithoutQuality]
		if substitutions ~= nil then
			nameAfterSurfaceSubst = substitutions[surface.name]
			if nameAfterSurfaceSubst == nil then nameAfterSurfaceSubst = substitutions["default"] end
			assert(nameAfterSurfaceSubst ~= nil, "No substitution found for " .. entType .. " " .. entName .. " on surface " .. surface.name)
		end
	end

	local correctName = nameAfterSurfaceSubst
	if entityQualityScales(entType, nameAfterSurfaceSubst) then
		correctName = addQualitySuffx(nameAfterSurfaceSubst, ent.quality)
	end

	if entName == correctName then return end

	local info = {
		position = ent.position,
		quality = ent.quality,
		force = ent.force,
		fast_replace = true,
		player = ent.last_user,
		orientation = ent.orientation,
		direction = ent.direction,
		mirroring = ent.mirroring,
	}
	if entType == "assembling-machine" then
		info.recipe = ent.get_recipe()
	end

	if not isGhost then
		info.name = correctName
	else
		info.name = "entity-ghost"
		info.inner_name = correctName
		info.tags = ent.tags
	end

	ent.destroy()
	local newEnt = surface.create_entity(info)
	if newEnt == nil or not newEnt.valid then return end
	newEnt.mirroring = info.mirroring
	-- Issue: this doesn't work for rocket-silo. Something weird about flipping/rotating rocket silos specifically, can't flip them once placed. So I'm rather just making rocket silos vertically symmetric.
	-- TODO when using this for furnaces etc, check if the mirroring issue appears there too.
end

return {
	onBuilt = onBuilt,
}