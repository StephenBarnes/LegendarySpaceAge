-- Move wooden-pole fuse recipe to electric-energy-distribution-1.
Tech.removeRecipeFromTech("po-small-electric-fuse", "basic-electricity")
Tech.addRecipeToTech("po-small-electric-fuse", "electric-energy-distribution-1")

-- Fix order of recipes in electric energy distribution 1 tech.
Tech.reorderRecipeUnlocks("electric-energy-distribution-1",
	{
		"medium-electric-pole",
		"big-electric-pole",
		"po-small-electric-fuse",
		"po-medium-electric-fuse",
		"po-big-electric-fuse",
		"po-transformer",
	})