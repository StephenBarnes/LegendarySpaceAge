require("util.globals")
require("util.globals-data")

-- Files that create things needed in subsequent files.
require("data.broad-changes.crafting-categories")
require("data.broad-changes.fluid-boxes")

-- Files that create new protos.
require("data.pre-space.char-furnace")
require("data.broad-changes.map-gen-preset")
require("data.broad-changes.remove-mapgen-presets")
require("data.pre-space.gunpowder")
require("data.pre-space.rubber")
require("data.pre-space.sand-and-glass")
require("data.pre-space.ash")
require("data.misc")
require("data.broad-changes.gui")
require("data.broad-changes.character-stats")
require("data.broad-changes.diurnal-dynamics")
require("data.tech-progression.labs")
require("data.metallurgy.metallurgy-d")
require("data.metallurgy.machine-parts")
require("data.metallurgy.rust")
require("data.petrochem.main")
require("data.cryo.main")
require("data.pre-space.cement")
require("data.circuits-modules.recipes-etc")
require("data.circuits-modules.primed-circuits")
require("data.circuits-modules.priming-buildings")
require("data.filtration.filtration-plant")
require("data.filtration.filters")
require("data.pre-space.freshwater")
require("data.pre-space.ammonia")
require("data.pre-space.niter")
require("data.broad-changes.briefing")
require("data.pre-space.tree-farming")
require("data.pre-space.storage-tanks")
require("data.pre-space.handcrank")
require("data.pre-space.heating-towers")
require("data.pre-space.cargo-ships")
require("data.space.rocket-parts-outside-silos")
require("data.pre-space.deep-drill")
require("data.pre-space.air-separator")
require("data.tech-progression.mech-armor")
require("data.broad-changes.planet-drop-techs")
require("data.pre-space.shotgun-turrets")
require("data.circuits-modules.beacons")
require("data.pre-space.personal-battery-generator")
require("data.pre-space.early-equipment-grids")
require("data.pre-space.landmines")
require("data.pre-space.water-etc")
require("data.pre-space.condensing-turbine")
require("data.pre-space.drill-nodes")

-- Editing planets
require("data.pre-space.misc")
require("data.pre-space.nauvis-worldgen")
require("data.vulcanus.main")
require("data.fulgora.main")
require("data.gleba.main")
require("data.nauvis-part-two.main")
require("data.aquilo.main")

-- Files that create protos, and require previous protos.
require("data.pre-space.gas-vent")
require("data.pre-space.waste-pump")
require("data.broad-changes.barrelling")
require("data.intermediate-factors.main")
require("data.broad-changes.fuel")
require("data.space.main")
require("data.tech-progression.tech-rate-triggers")
require("data.vulcanus.no-lava-in-pipes")

-- Files that adjust protos
require("data.circuits-modules.remove-modules")
require("data.broad-changes.item-groups")
require("data.broad-changes.surface-properties")
require("data.tech-progression.advanced-logistics")
require("data.infra.main")
require("data.broad-changes.ocean-dumping")
require("data.tech-progression.main")
require("data.broad-changes.stack-sizes")
require("data.broad-changes.quality")

-- TODO temp testing: make player run animation slower, for low-gravity later.
--local animationMult = 0.6
--local runMult = 0.63 -- I think this should be slightly higher than animationMult, since you move further per stride on the moon but also don't want to slip too much.
--[[
local animationMult = 0.4
local runMult = 1.2
for i, anim in pairs(RAW.character.character.animations) do
	for _, k in pairs{"running_with_gun", "flipped_shadow_running_with_gun", "running"} do
		if anim[k] ~= nil then
			local animLayers = anim[k].layers
			assert(animLayers ~= nil, "No layers for " .. k .. " for " .. i .. ": " .. serpent.block(anim))
			for _, layer in pairs(animLayers) do
				layer.animation_speed = layer.animation_speed * animationMult
			end
		elseif anim.armors == nil or anim.armors[1] ~= "mech-armor" then -- We expect mech-armor to have missing animations, but not the other ones.
			log("Warning: no " .. k .. " for " .. i .. " " .. serpent.block(anim))
		end
	end
end
RAW.character.character.running_speed = RAW.character.character.running_speed * runMult
]]