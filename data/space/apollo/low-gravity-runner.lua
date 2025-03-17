-- This file makes a new character that's the same as the default, but runs a bit faster with slower animation. For while player is on the moon.

local animationMult = .55
local runMult = .9
local newChar = copy(RAW.character.character)
newChar.name = "low-gravity-character"
for i, anim in pairs(newChar.animations) do
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
newChar.running_speed = newChar.running_speed * runMult
newChar.hidden = true
newChar.hidden_in_factoriopedia = true
newChar.factoriopedia_alternative = "character"
extend{newChar}