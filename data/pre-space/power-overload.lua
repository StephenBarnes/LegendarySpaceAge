-- This file adjusts the Power Overload mod by Xorimuth.

-- Hide the "high energy interface" since it's not needed for anything in this modpack.
Recipe.hide("po-interface")
Tech.removeRecipeFromTech("po-interface", "po-electric-energy-distribution-3")

-- Using custom descriptions for techs.
TECH["electric-energy-distribution-1"].localised_description = {"technology-description.electric-energy-distribution-1"}
TECH["electric-energy-distribution-2"].localised_description = {"technology-description.electric-energy-distribution-2"}
--TECH["po-electric-energy-distribution-3"].localised_description = {"technology-description.po-electric-energy-distribution-3"}

-- Change transformer and all the combinators to also be craftable in EM plants.
for _, recipeName in pairs({"selector-combinator", "arithmetic-combinator", "decider-combinator", "constant-combinator", "power-switch", "programmable-speaker", "display-panel", "small-lamp", "po-transformer"}) do
	assert(RECIPE[recipeName] ~= nil, "Couldn't find recipe "..recipeName.." to change to EM plants.")
	RECIPE[recipeName].category = "electronics"
end

-- Hide high-power interface in Factoriopedia since I'm removing it.
RAW["item"]["po-interface"].hidden_in_factoriopedia = true
RAW["electric-pole"]["po-interface"].hidden_in_factoriopedia = true
-- Hide extra Factoriopedia entries.
-- TODO remove the ones below since mod dev will probably do it.
RAW["electric-pole"]["po-interface-east"].hidden_in_factoriopedia = true
RAW["electric-pole"]["po-interface-north"].hidden_in_factoriopedia = true
RAW["electric-pole"]["po-interface-south"].hidden_in_factoriopedia = true

-- Do we need the big pylons with 5GW power? Graphics are low-res, could upscale.
-- Fusion reactor consumes 100MW fuel, 10MW electricity, and generates 100MW times neighbor bonus of maybe 600% max. Fusion generator produces 50MW.
-- Big plant might be like 8 reactors? So 100MW * 7 * 8 = 5.6GW.
-- Although, each generator only gives 50MW (assuming no quality) so it's still entirely doable with big poles around 500MW. Just need to connect one fusion power plant to multiple networks.
-- So, let's remove the big pylons.
Tech.hideTech("po-electric-energy-distribution-3")
Recipe.hide("po-huge-electric-pole")
ITEM["po-huge-electric-pole"].hidden = true
RAW["electric-pole"]["po-huge-electric-pole"].hidden = true
RECIPE["po-huge-electric-pole-recycling"] = nil
Recipe.hide("po-huge-electric-fuse")
ITEM["po-huge-electric-fuse"].hidden = true
RAW["electric-pole"]["po-huge-electric-fuse"].hidden = true
RECIPE["po-huge-electric-fuse-recycling"] = nil

--[[ Obsolete stuff, now that pylons are removed:
-- Make the pylons require blue circuits, since they depend on that.
--Recipe.substituteIngredient("po-huge-electric-pole", "advanced-circuit", "processing-unit")
--Recipe.substituteIngredient("po-huge-electric-fuse", "advanced-circuit", "processing-unit")
-- Actually, make pylons require supercapacitors.
Recipe.substituteIngredient("po-huge-electric-pole", "advanced-circuit", "supercapacitor")
Recipe.substituteIngredient("po-huge-electric-fuse", "advanced-circuit", "supercapacitor")

-- Make the pylon tech require EM science packs.
Tech.setPrereqs("po-electric-energy-distribution-3", {"electromagnetic-science-pack"})
Tech.copyUnit("lightning-collector", "po-electric-energy-distribution-3")

-- Set pylons' crafting category same as the others, so it can be made in EM plants.
--RECIPE["po-huge-electric-pole"].category = RECIPE["big-electric-pole"].category
--RECIPE["po-huge-electric-fuse"].category = RECIPE["big-electric-pole"].category
-- Actually rather make them only buildable in EM plants.
RECIPE["po-huge-electric-pole"].category = "electromagnetics"
RECIPE["po-huge-electric-fuse"].category = "electromagnetics"

-- Reorder pylon recipe to be after substation
RECIPE["po-huge-electric-pole"].order = "a[energy]-e[huge]"
]]

-- Reduce ingredients for fuses, since default is 20 times normal power pole which seems excessive. Rather just the pole plus a wiring. Must be in dff stage or data-updates.
for _, size in pairs{"small", "medium", "big"} do
	Recipe.edit{
		recipe = "po-"..size.."-electric-fuse",
		ingredients = {
			{"electronic-components", 2},
			{size.."-electric-pole", 1},
		},
		time = RECIPE[size.."-electric-pole"].energy_required,
	}
end