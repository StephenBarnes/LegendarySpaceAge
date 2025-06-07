--[[ This file creates the "filler" intermediate and its multiple recipes. See main.lua in this folder for more info.
Filler represents any fine powder that's mostly chemically inert, usable for eg making plastic or landfill or concrete.
Made from: sand, gravel, silica, gypsum, ash, smelting slags, crushed ores, resin powder, sawdust (crushed wood chips), clay, maybe more.
NOT made from alkali ash (not chemically inert), ice (melts). Probably not acid-salts?
]]

-- Create item.
local fillerItem = copy(ITEM["stone"])
fillerItem.name = "filler"
Icon.set(fillerItem, "LSA/intermediate-factors/filler/3")
Icon.variants(fillerItem, "LSA/intermediate-factors/filler/%", 3)
fillerItem.stack_size = 200
extend{fillerItem}

-- Create recipe: sand -> filler
local fillerFromSand = Recipe.make{
	copy = RECIPE.barrel,
	recipe = "filler-from-sand",
	ingredients = {"sand"},
	results = {"filler"},
	time = 0.1,
	category = "crafting",
	additional_categories = {"mini-assembling"},
	icons = {"filler", "sand"},
	allow_as_intermediate = true,
	enabled = true, -- TODO techs
}

-- Create recipe: ash -> filler
Recipe.make{
	copy = fillerFromSand,
	recipe = "filler-from-ash",
	ingredients = {"ash"},
	icons = {"filler", "ash"},
}

-- Create recipe: silica -> filler
Recipe.make{
	copy = fillerFromSand,
	recipe = "filler-from-silica",
	ingredients = {"silica"},
	icons = {"filler", "silica"},
}

-- Create recipe: crushing gypsum -> filler
Recipe.make{
	copy = fillerFromSand,
	recipe = "filler-from-gypsum",
	ingredients = {"gypsum"},
	icons = {"filler", "gypsum", "crush"},
	iconArrangement = "crushing",
	category = "crushing",
	additional_categories = {},
}


-- TODO create more recipes, once items exist.
-- TODO add recipe for crushed ores -> filler.
-- TODO add recipe for crushed coal -> filler.
-- TODO add recipe for resin powder -> filler.
-- TODO add recipe for clay -> filler.
-- TODO add recipe for low-grade fertilizer -> filler.
-- TODO add recipes from crushing the salts.
-- TODO add recipe for gravel -> filler. (Additional crushing step, not classifier.)
-- TODO add recipe for gypsum -> filler. (Additional crushing step, not classifier.)
-- TODO add recipe for smelting slags -> filler. (Additional crushing step, not classifier.)
-- TODO add recipe for crushing wood pulp -> filler. (Additional crushing step, not classifier.)
-- TODO add recipe for crushing sulfur -> filler? (Additional crushing step, not classifier.)
-- TODO add recipe for other filler ingredients.