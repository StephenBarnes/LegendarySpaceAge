local Tech = require("code.util.tech")
local Item = require("code.util.item")

-- Change Gleba rocket fuel recipe to require carbon, produced from spoilage.
-- Originally 2 bioflux + 30 jelly + water.
table.insert(data.raw.recipe["rocket-fuel-from-jelly"].ingredients,
	{ type = "item", name = "carbon", amount = 2 })

-- Gleba: remove recipes for making iron/copper bacteria from jelly/mash.
Tech.removeRecipeFromTech("iron-bacteria", "jellynut")
Tech.removeRecipeFromTech("copper-bacteria", "yumako")

-- Gleba: increase spoilage time of iron/copper bacteria.
Item.multiplySpoilTime("iron-bacteria", 3)
Item.multiplySpoilTime("copper-bacteria", 3)

-- Artificial soil tech makes more sense after biochamber.
Tech.setPrereqs("artificial-soil", {"biochamber"})

-- Artificial soil recipes should be biochamber-only.
for _, recipeName in pairs{"artificial-yumako-soil", "artificial-jellynut-soil", "overgrowth-yumako-soil", "overgrowth-jellynut-soil"} do
	data.raw.recipe[recipeName].category = "organic"
end

-- Allow bacteria cultivation on any surface.
data.raw.recipe["iron-bacteria-cultivation"].surface_conditions = nil
data.raw.recipe["copper-bacteria-cultivation"].surface_conditions = nil

-- Double rocket capacity for bioflux
-- Decided against this bc it's already high, don't want to remove the incentive to set up toxophages etc.
--Item.multiplyWeight("bioflux", 0.5, "capsule")

-- Change ingredients of biological science pack.
data.raw.recipe["agricultural-science-pack"].ingredients = {
	{type = "item", name = "nutrients", amount = 4},
	{type = "item", name = "pentapod-egg", amount = 1},
	--{type = "item", name = "iron-bacteria", amount = 1},
	{type = "item", name = "copper-bacteria", amount = 1},
	{type = "item", name = "slipstack-pearl", amount = 1},
}

-- Reduce yields of jellystem and yumako, bc right now they're absurdly high, can run 1 rocket per minute off like 2 ag towers.
data.raw.plant["yumako-tree"].minable.results = {{type = "item", name = "yumako", amount_min = 10, amount_max = 20}}
data.raw.plant["jellystem"].minable.results = {{type = "item", name = "jellynut", amount_min = 10, amount_max = 20}}

-- Make stromatolites give smaller yields bc right now it's insanely high, like 400 ore from 1 cluster of stromatolites.
data.raw["simple-entity"]["iron-stromatolite"].minable.results = {
	{type = "item", name = "stone", amount_min = 3, amount_max = 7}, -- Unchanged
	{type = "item", name = "iron-ore", amount_min = 13, amount_max = 17}, -- Unchanged
	{type = "item", name = "iron-bacteria", amount_min = 3, amount_max = 7}, -- Changed 23-37 to 3-7.
}
data.raw["simple-entity"]["copper-stromatolite"].minable.results = {
	{type = "item", name = "stone", amount_min = 3, amount_max = 7}, -- Unchanged
	{type = "item", name = "copper-ore", amount_min = 13, amount_max = 17}, -- Unchanged
	{type = "item", name = "copper-bacteria", amount_min = 3, amount_max = 7}, -- Changed 23-37 to 3-7.
}

-- Make spoilage spoil to nothing. From testing, you can simply not define spoil result or trigger, and it'll disappear.
data.raw.item.spoilage.spoil_ticks = 60 * 60 * 20