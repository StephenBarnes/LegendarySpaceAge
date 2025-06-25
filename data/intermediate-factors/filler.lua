--[[ This file creates the "fine-filler" factor and the "coarse filler" factor, and their multiple recipes. See main.lua in this folder for more info.
Fine filler represents any fine powder that's mostly chemically inert, usable for eg making plastic.
Coarse filler represents any coarse mineral that's mostly chemically inert, usable for eg making landfill and concrete.

Coarse is made from: fine filler (by compressing), stone, crushed ores, gypsum, slag, wood chips, maybe more.
Fine is made from: coarse filler (by crushing), sand, gravel, silica, ash, resin powder, clay, maybe more.

Fillers are NOT made from alkali ash (not chemically inert), ice (melts). Probably not acid-salts?
]]

-- Create items.
local fineFillerItem = copy(ITEM["stone"])
fineFillerItem.name = "fine-filler"
Icon.set(fineFillerItem, "LSA/intermediate-factors/fine-filler/3")
Icon.variants(fineFillerItem, "LSA/intermediate-factors/fine-filler/%", 3)
fineFillerItem.stack_size = 200
local coarseFillerItem = copy(fineFillerItem)
coarseFillerItem.name = "coarse-filler"
Icon.set(coarseFillerItem, "LSA/intermediate-factors/coarse-filler/1")
Icon.variants(coarseFillerItem, "LSA/intermediate-factors/coarse-filler/%", 3)
coarseFillerItem.stack_size = 100
extend{fineFillerItem, coarseFillerItem}

-- Create recipe: sand -> fine filler
local fineFillerFromSand = Recipe.make{
	copy = RECIPE.barrel,
	recipe = "fine-filler-from-sand",
	ingredients = {"sand"},
	results = {"fine-filler"},
	main_product = "fine-filler",
	time = 0.1,
	category = "crafting",
	additional_categories = {"mini-assembling"},
	icons = {"fine-filler", "sand"},
	allow_as_intermediate = true,
	enabled = true, -- TODO techs
}

-- Create recipe: fine filler -> coarse filler
Recipe.make{
	copy = fineFillerFromSand,
	recipe = "coarse-filler-from-fine-filler",
	ingredients = {"fine-filler"},
	results = {"coarse-filler"},
	main_product = "coarse-filler",
	icons = {"coarse-filler", "fine-filler"},
	category = "crafting",
	additional_categories = {},
	time = 1,
}

-- Create crushing recipe: coarse filler -> fine filler
Recipe.make{
	copy = fineFillerFromSand,
	recipe = "fine-filler-from-coarse-filler",
	ingredients = {"coarse-filler"},
	icons = {"fine-filler", "coarse-filler"},
	iconArrangement = "crushing",
	category = "crushing",
	additional_categories = {},
	time = 1,
}

-- Create recipe: ash -> fine filler
Recipe.make{
	copy = fineFillerFromSand,
	recipe = "fine-filler-from-ash",
	ingredients = {"ash"},
	icons = {"fine-filler", "ash"},
}

-- Create recipe: silica -> fine filler
Recipe.make{
	copy = fineFillerFromSand,
	recipe = "fine-filler-from-silica",
	ingredients = {"silica"},
	icons = {"fine-filler", "silica"},
}

-- Create recipe: gypsum -> coarse filler
local coarseFillerFromGypsum = Recipe.make{
	copy = fineFillerFromSand,
	recipe = "coarse-filler-from-gypsum",
	ingredients = {"gypsum"},
	results = {"coarse-filler"},
	icons = {"coarse-filler", "gypsum"},
	main_product = "coarse-filler",
	time = 0.1,
}

-- Create recipes: crushed ores -> coarse filler
for _, oreName in pairs{"iron-ore", "copper-ore", "tungsten-ore"} do
	Recipe.make{
		copy = coarseFillerFromGypsum,
		recipe = "coarse-filler-from-crushed-" .. oreName,
		ingredients = {"crushed-" .. oreName},
		icons = {"coarse-filler", "crushed-" .. oreName},
	}
end

-- Create recipes: slag -> coarse filler
for _, slagName in pairs{"iron-slag", "copper-slag"} do
	Recipe.make{
		copy = coarseFillerFromGypsum,
		recipe = "coarse-filler-from-" .. slagName,
		ingredients = {slagName},
		icons = {"coarse-filler", slagName},
	}
end

-- Create recipe: wood chips -> coarse filler
Recipe.make{
	copy = coarseFillerFromGypsum,
	recipe = "coarse-filler-from-wood-chips",
	ingredients = {"wood-chips"},
	icons = {"coarse-filler", "wood-chips"},
}

-- Create recipe: stone -> coarse filler
Recipe.make{
	copy = coarseFillerFromGypsum,
	recipe = "coarse-filler-from-stone",
	ingredients = {"stone"},
	icons = {"coarse-filler", "stone"},
}

-- Create recipe: chitin-fragments -> coarse filler
Recipe.make{
	copy = coarseFillerFromGypsum,
	recipe = "coarse-filler-from-chitin-fragments",
	ingredients = {"chitin-fragments"},
	icons = {"coarse-filler", "chitin-fragments"},
}

-- Create recipe: marrow -> coarse filler
Recipe.make{
	copy = coarseFillerFromGypsum,
	recipe = "coarse-filler-from-marrow",
	ingredients = {"marrow"},
	icons = {"coarse-filler", "marrow"},
	enabled = false, -- Added to marrow tech.
}



-- TODO create more recipes, once items exist.
-- TODO add recipe for crushed coal -> filler.
-- TODO add recipe for resin powder -> filler.
-- TODO add recipe for clay -> filler.
-- TODO add recipe for low-grade fertilizer -> filler.
-- TODO add recipes from crushing the salts.
-- TODO add recipe for gravel -> filler.
-- TODO add recipe for crushing sulfur -> filler?
-- TODO add recipe for other filler ingredients.