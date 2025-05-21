--[[ This file adds a recipe for "char": air/oxygen + (any carbon-based fuel) -> carbon + coke gas.
This is done in any burner furnace (stone, steel, fluid-fuelled). Burns any fuel that can go in a furnace, including carbon itself.
This allows the player to get carbon early-game, to make circuits.

Previously I put this in a special "char-furnace" entity, but I'm rather removing that, simpler to just do it in any burner furnace.

We need to be careful that this doesn't allow burning carbon to make more carbon.
	Unfortunately quality scales the speed of every furnace, but not its energy consumption, and the modding API doesn't allow us to change that.
	So instead we use a horrible workaround that works by replacing entities when built, based on their quality, with a variant that has correspondingly scaled energy consumption.
	1 carbon is 500kJ, energy consumption of furnaces is at least 250kW for 1 crafting speed, so for zero energy gain/loss the recipe should take 2s. Minus coke oven gas fuel. Making it take 5s, so 40% efficient unless you use the coke oven gas for something.
]]

-- Create recipe for char/carbon.
Recipe.make{
	copy = "rocket-fuel",
	recipe = "char-carbon",
	results = {"carbon"},
	ingredients = {},
	time = 5,
	enabled = false,
	category = "smelting",
	icons = {"carbon", "stone-furnace"},
	allow_productivity = false,
	allow_consumption = false,
	allow_quality = true,
}

-- Create tech called "char", unlocking the recipe.
local charTech = copy(TECH["automation"])
charTech.name = "char"
charTech.effects = {
	{type = "unlock-recipe", recipe = "char-carbon"},
}
charTech.prerequisites = {}
charTech.research_trigger = {
	type = "mine-entity",
	entity = "coal",
	count = 1,
}
charTech.unit = nil
Icon.set(charTech, "LSA/petrochem/char-tech")
extend{charTech}