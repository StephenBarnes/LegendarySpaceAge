--[[
This file swaps buildings on build, for 2 cases:
	* We can swap depending on surface.
		For example: to make rocket silos on Apollo only need 10 parts per rocket, we swap them to rocket-silo-10parts.
		For example: to make furnaces on Nauvis and Gleba not need external air input.
	* We can swap depending on quality.
		For example: to make entities scale their power consumption in line with their speed.
			This was originally necessary to prevent free-energy exploits using e.g. quality battery chargers that produce more energy than they consume. And similar for char recipe, and gasifier.
			But they added an easier way to do that without registering new protos in 2.0.56 so that's no longer necessary.
			Leaving this code here because we could use it for different quality-specific changes in the future. (TODO)
			See data/broad-changes/quality-variants-dff.lua for the data-side of this.
]]

local EntitySubstitutions = require("const.entity-substitutions-const")
local QualitySubstitutions = require("const.quality-variants")

-- Given entity base name (quality suffix removed), returns true if it has quality variants.
local function entityHasQualityVariants(entType, entName)
	return (QualitySubstitutions.qualityVersions[entType] ~= nil) and (QualitySubstitutions.qualityVersions[entType][entName] ~= nil)
end

-- Given entity name, removes quality suffix, if any.
---@param entName string
---@return string
local function trimQualitySuffix(entName)
	return QualitySubstitutions.qualityToOriginal[entName] or entName
end

-- Given entity name and quality, add quality suffix. For normal quality, doesn't add anything.
---@param entType string
---@param entName string
---@param quality LuaQualityPrototype
---@return string
local function addQualitySuffx(entType, entName, quality)
	return QualitySubstitutions.qualityVersions[entType][entName].qualityNames[quality.level]
end

-- Perform surface substitutions.
---@param entType string
---@param nameWithoutQuality string
---@param surface LuaSurface
---@param isGhost boolean
---@return string
local function performSurfaceSubstitutions(entType, nameWithoutQuality, surface, isGhost)
	local typeSubstitutions = EntitySubstitutions[entType]
	if typeSubstitutions == nil then return nameWithoutQuality end
	local substitutions = typeSubstitutions[nameWithoutQuality]
	if substitutions == nil then return nameWithoutQuality end
	if isGhost and substitutions.excludeGhosts then return nameWithoutQuality end
	if not isGhost and substitutions.onlyGhosts then return nameWithoutQuality end
	local nameAfterSurfaceSubst = substitutions.bySurface[surface.name]
	if nameAfterSurfaceSubst == nil then nameAfterSurfaceSubst = substitutions.bySurface["default"] end
	assert(nameAfterSurfaceSubst ~= nil, "No substitution found for " .. entType .. " " .. nameWithoutQuality .. " on surface " .. surface.name)
	return nameAfterSurfaceSubst
end

-- When an entity is built, replace it with other entity, applying surface and quality substitutions. Return the modified entity, if any.
---@param event EventData.on_built_entity|EventData.on_robot_built_entity|EventData.on_space_platform_built_entity|EventData.script_raised_built|EventData.script_raised_revive|EventData.on_entity_cloned
---@return LuaEntity|nil
local function onBuilt(event)
	local ent = event.entity
	if ent == nil or not ent.valid then return nil end
	local surface = ent.surface
	if surface == nil or not surface.valid then return end

	--[[ General approach:
	1. Get name of entity, or if it's a ghost, get name of what it's ghosting.
	2. From ent's name, remove quality suffix, if any.
	3. If the entity is subject to surface substitutions, then substitute it with the correct name for that surface.
	4. If the new, surface-substituted entity has quality variants, then add quality suffix.
	5. If the final "correct name" differs from the entity's name, then destroy the entity and create a new one with the correct name.
	]]

	local entName, entType, isGhost
	if ent.name ~= "entity-ghost" then
		entName, entType, isGhost = ent.name, ent.type, false
	else
		entName, entType, isGhost = ent.ghost_name, ent.ghost_type, true
	end

	local nameWithoutQuality = trimQualitySuffix(entName)
	local nameAfterSurfaceSubst = performSurfaceSubstitutions(entType, nameWithoutQuality, surface, isGhost)

	local correctName = nameAfterSurfaceSubst
	if entityHasQualityVariants(entType, nameAfterSurfaceSubst) then
		correctName = addQualitySuffx(entType, nameAfterSurfaceSubst, ent.quality)
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
	-- Copy recipe, if available. Only available for CraftingMachine subtypes.
	if entType == "assembling-machine" or entType == "furnace" then
		local recipe = ent.get_recipe()
		if recipe ~= nil then
			info.recipe = recipe.name
		end
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
	if info.recipe ~= nil then
		newEnt.set_recipe(info.recipe)
	end
	-- Issue: this doesn't work for rocket-silo. Something weird about flipping/rotating rocket silos specifically, can't flip them once placed. So I'm rather just making rocket silos vertically symmetric.
	-- Checked: when using this for furnaces etc, there's no mirroring issue.

	return newEnt
end

return {
	onBuilt = onBuilt,
}