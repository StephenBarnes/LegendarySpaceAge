--[[ This file adds more landmine types to make defense more interesting. Namely poison landmines and slowdown landmines. Reusing capsule effects.
]]

for _, kind in pairs{"poison", "slowdown"} do
	-- Create ent for landmine.
	local ent = copy(RAW["land-mine"]["land-mine"])
	ent.name = kind .. "-land-mine"
	ent.icon = "__LegendarySpaceAge__/graphics/landmines/" .. kind .. "-icon.png"
	ent.minable.result = kind .. "-land-mine"
	ent.picture_safe.filename = "__LegendarySpaceAge__/graphics/landmines/" .. kind .. "-ent.png"
	ent.picture_set.filename = "__LegendarySpaceAge__/graphics/landmines/" .. kind .. "-set.png"
	-- Not changing .picture_set_enemy, so in multiplayer, you can't tell the enemy's landmines' types apart. (Color-coding is for convenience of the placer, obviously you wouldn't actually paint them bright colors.)
	ent.action = RAW.projectile[kind .. "-capsule"].action
	extend{ent}

	-- Create item.
	local item = copy(ITEM["land-mine"])
	item.name = kind .. "-land-mine"
	item.icon = "__LegendarySpaceAge__/graphics/landmines/" .. kind .. "-icon.png"
	item.place_result = kind .. "-land-mine"
	extend{item}

	-- Create recipes. Details will be set in infra/6-military/capsules.lua where I'm also setting details for capsule recipes.
	Recipe.make{
		recipe = kind .. "-land-mine",
		copy = "land-mine",
		ingredients = {},
		resultCount = 1,
		time = 1,
		clearIcons = true,
	}

	-- Add recipes to tech.
	Tech.addRecipeToTech(kind .. "-land-mine", "land-mine")
end