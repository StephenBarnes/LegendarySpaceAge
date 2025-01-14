local Tech = require("code.util.tech")

-- Move iron rod to be enabled from the start, and remove it from techs.
-- Needs to be in data-final-fixes bc rust mod adds stick derusting in data-final-fixes.
data.raw.recipe["iron-stick"].enabled = true
data.raw.recipe["rocs-rusting-iron-iron-stick-derusting"].enabled = true
Tech.removeRecipesFromTechs(
	{"iron-stick", "rocs-rusting-iron-iron-stick-derusting"},
	{"railway", "circuit-network", "electric-energy-distribution-1", "concrete"})

-- Move wooden-pole fuse recipe to electric-energy-distribution-1.
Tech.removeRecipeFromTech("po-small-electric-fuse", "electric-energy-distribution-1")
Tech.addRecipeToTech("po-small-electric-fuse", "electric-energy-distribution-1", 3)