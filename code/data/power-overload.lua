-- This file adjusts the Power Overload mod by Xorimuth.

local Recipe = require("code.util.recipe")
local Tech = require("code.util.tech")

-- Hide the "high energy interface" since it's not needed for anything in this modpack.
Recipe.hide("po-interface")
Tech.removeRecipeFromTech("po-interface", "po-electric-energy-distribution-3")

-- Tempted to hide the fuses bc they look a bit weird. But they do make the design a bit more interesting.

-- Fix order of recipes in electric energy distribution 1 tech.
-- I think this can't run in data, must be data-updates, maybe bc rusting iron mod hasn't made its recipe yet.
Tech.reorderRecipeUnlocks("electric-energy-distribution-1",
	{
		"medium-electric-pole",
		"big-electric-pole",
		"po-medium-electric-fuse",
		"po-big-electric-fuse",
		"po-transformer",
		"iron-stick",
		"rocs-rusting-iron-iron-stick-derusting",
	})

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
--data.raw.recipe["po-huge-electric-pole"].category = data.raw.recipe["big-electric-pole"].category
--data.raw.recipe["po-huge-electric-fuse"].category = data.raw.recipe["big-electric-pole"].category
-- Actually rather make them only buildable in EM plants.
data.raw.recipe["po-huge-electric-pole"].category = "electromagnetics"
data.raw.recipe["po-huge-electric-fuse"].category = "electromagnetics"

-- Reduce ingredients for fuses, since default is 20 times normal power pole which seems excessive.
Recipe.copyIngredients("po-huge-electric-pole", "po-huge-electric-fuse")
Recipe.copyIngredients("medium-electric-pole", "po-medium-electric-fuse")
Recipe.copyIngredients("big-electric-pole", "po-big-electric-fuse")
Recipe.copyIngredients("small-electric-pole", "po-small-electric-fuse")

-- Reorder pylon recipe to be after substation
data.raw.recipe["po-huge-electric-pole"].order = "a[energy]-e[huge]"

-- Using custom descriptions for techs.
data.raw.technology["electric-energy-distribution-1"].localised_description = {"technology-description.electric-energy-distribution-1"}
data.raw.technology["electric-energy-distribution-2"].localised_description = {"technology-description.electric-energy-distribution-2"}
data.raw.technology["po-electric-energy-distribution-3"].localised_description = {"technology-description.po-electric-energy-distribution-3"}

-- Change transformer and all the combinators to also be craftable in EM plants.
for _, recipe in pairs({"selector-combinator", "arithmetic-combinator", "decider-combinator", "constant-combinator", "power-switch", "programmable-speaker", "display-panel", "small-lamp", "po-transformer"}) do
	local recipe = data.raw.recipe[recipe]
	if recipe == nil then
		log("ERROR: Couldn't find recipe "..recipe.." to change to EM plants.")
		return
	end
	recipe.category = "electronics"
end

-- Hide high-power interface in Factoriopedia since I'm removing it.
data.raw["item"]["po-interface"].hidden_in_factoriopedia = true
data.raw["electric-pole"]["po-interface"].hidden_in_factoriopedia = true
-- Hide extra Factoriopedia entries.
-- TODO remove the ones below since mod dev will probably do it.
data.raw["electric-pole"]["po-interface-east"].hidden_in_factoriopedia = true
data.raw["electric-pole"]["po-interface-north"].hidden_in_factoriopedia = true
data.raw["electric-pole"]["po-interface-south"].hidden_in_factoriopedia = true