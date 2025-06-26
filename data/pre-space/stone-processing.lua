--[[ This file creates recipes for processing stone into other materials, and creates those items.

Early in progression, crushing: stone -> sand + clay
Later, we expand this system to provide more resources: calcite, silica, phosphoric acid, chromite, alumina, rare earths, magnesium ore.
Crush and screen: stone -> sand + clay + gravel + calcite + magnesium ore + chromite dust
Acid leach: gravel + sulfuric acid -> gypsum + phosphoric acid + carbon dioxide
Gypsum is a byproduct, dumped or used to make structure factors.
Washing: sand + water -> silica + clay + mudwater
As above, mudwater can be dumped or filtered again for sand + clay + water.
Clay leaching: clay + sulfuric acid -> alumina + silica + rare earth ore + sulfuric wastewater
]]

-- Create gypsum item.
local gypsum = copy(ITEM.stone)
gypsum.name = "gypsum"
Icon.set(gypsum, "LSA/stone-processing/gypsum/1")
Icon.variants(gypsum, "LSA/stone-processing/gypsum/%", 4)
extend{gypsum}

-- Create gravel item.
local gravel = copy(ITEM.stone)
gravel.name = "gravel"
Icon.set(gravel, "LSA/stone-processing/gravel/1")
Icon.variants(gravel, "LSA/stone-processing/gravel/%", 4)
extend{gravel}

-- Create clay item.
local clay = copy(ITEM.spoilage)
clay.name = "clay"
Icon.set(clay, "LSA/stone-processing/clay/1")
Icon.variants(clay, "LSA/stone-processing/clay/%", 4)
Item.clearSpoilage(clay)
extend{clay}

-- Create chromite dust item, copying gravel graphics for now (TODO better graphics).
local chromiteDust = copy(ITEM.gravel)
chromiteDust.name = "chromite-dust"
extend{chromiteDust}

-- Create magnesium ore item, copying gravel graphics for now (TODO better graphics).
local magnesiumOre = copy(ITEM.gravel)
magnesiumOre.name = "magnesium-ore"
extend{magnesiumOre}

-- Create rare earth ore item, copying gravel graphics for now (TODO better graphics).
local rareEarthOre = copy(ITEM.gravel)
rareEarthOre.name = "rare-earth-ore"
extend{rareEarthOre}

-- Create alumina item, copying gravel graphics for now (TODO better graphics).
local alumina = copy(ITEM.gravel)
alumina.name = "alumina"
extend{alumina}

-- Create recipe for basic stone crushing.
local basicStoneCrushing = Recipe.make{
	copy = RECIPE.barrel,
	recipe = "basic-stone-crushing",
	ingredients = {{"stone", 2}},
	results = {"sand", "clay"},
	time = 2,
	categories = {"crushing", "handcrafting"},
	icons = {"stone"},
	iconArrangement = "crushing",
	enabled = true, -- TODO
}

--Crush and screen: stone -> sand + clay + gravel + calcite + magnesium ore + chromite dust
Recipe.make{
	copy = basicStoneCrushing,
	recipe = "stone-crushing-screening",
	ingredients = {{"stone", 5}},
	results = {
		{"sand", 2},
		{"clay", 1},
		{"gravel", 1},
		{"calcite", 1},
		{"magnesium-ore", 1},
		{"chromite-dust", 1},
	},
	time = 5,
	categories = {"crushing"},
}

-- Acid leach: gravel + sulfuric acid -> gypsum + phosphoric acid + carbon dioxide
Recipe.make{
	copy = basicStoneCrushing,
	recipe = "gravel-acid-leach",
	ingredients = {{"gravel", 2}, {"sulfuric-acid", 20}},
	results = {
		{"gypsum", 1},
		{"phosphoric-acid", 10},
		{"carbon-dioxide", 10},
	},
	time = 1,
	categories = {"exothermic"},
	icons = {"gravel", "sulfuric-acid"},
	iconArrangement = "verticalExo",
	-- TODO recipe colors
}

-- Washing: sand + water -> silica + clay + mudwater
Recipe.make{
	copy = basicStoneCrushing,
	recipe = "sand-washing",
	ingredients = {{"sand", 2}, {"water", 10}},
	results = {
		{"silica", 1},
		{"clay", 1},
		{"mudwater", 5},
	},
	time = 2,
	categories = {"chemistry"},
	icons = {"LSA/glass-etc/sand/3", "water"},
	iconArrangement = "vertical",
	-- TODO recipe colors
}

-- Mudwater filtration: mudwater -> sand + clay + water.
Recipe.make{
	copy = basicStoneCrushing,
	recipe = "mudwater-filtering",
	ingredients = {{"mudwater", 10}},
	results = {{"sand", 1}, {"clay", 1}, {"water", 10}},
	time = 1,
	categories = {"filtration"},
	-- TODO recipe colors
	icons = {"mudwater"},
	iconArrangement = "filtration",
}

-- Clay leaching: clay + sulfuric acid -> alumina + silica + rare earth ore + sulfuric wastewater
Recipe.make{
	copy = basicStoneCrushing,
	recipe = "clay-leaching",
	ingredients = {{"clay", 2}, {"sulfuric-acid", 10}},
	results = {{"alumina", 1}, {"silica", 1}, {"rare-earth-ore", 1}, {"sulfuric-wastewater", 10}},
	time = 2,
	categories = {"exothermic"},
	icons = {"clay", "sulfuric-acid"},
	iconArrangement = "verticalExo",
	-- TODO recipe colors
}
