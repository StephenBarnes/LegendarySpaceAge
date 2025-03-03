-- Edit items from mining boulders - more niter, more stone, more coal.
RAW["simple-entity"]["huge-rock"].minable.results = {
	{type = "item", name = "stone", amount=100}, -- Was 24-50.
	{type = "item", name = "coal", amount=25}, -- Was 24-50.
	{type = "item", name = "niter", amount=10}, -- Added.
}
RAW["simple-entity"]["big-rock"].minable.results = {
	{type = "item", name = "stone", amount=50}, -- Was 20.
	{type = "item", name = "coal", amount=10}, -- Added.
	{type = "item", name = "niter", amount=10}, -- Added.
}
RAW["simple-entity"]["big-sand-rock"].minable.results = {
	{type = "item", name = "stone", amount=50}, -- Was 19-25.
	{type = "item", name = "coal", amount=10}, -- Added.
	{type = "item", name = "niter", amount=10}, -- Added.
}
-- TODO also boulders etc in other places, eg Vulcanus needs niter.