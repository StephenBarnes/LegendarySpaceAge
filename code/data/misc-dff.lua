-- Move iron rod to be enabled from the start, and remove it from techs.
-- Needs to be in data-final-fixes bc rust mod adds stick derusting in data-final-fixes.
RECIPE["iron-stick"].enabled = true
Tech.removeRecipesFromTechs(
	{"iron-stick"},
	{"railway", "circuit-network", "electric-energy-distribution-1", "concrete"})

-- Move wooden-pole fuse recipe to electric-energy-distribution-1.
Tech.removeRecipeFromTech("po-small-electric-fuse", "basic-electricity")
Tech.addRecipeToTech("po-small-electric-fuse", "electric-energy-distribution-1", 3)

-- Edit the spent-filter-recycling recipe to have the same results as filter-recycling.
RECIPE["spent-filter-recycling"].results = RECIPE["filter-recycling"].results