-- TODO move most of this out to other files.

-- TODO tech tree change - add nuclear science, move nuclear stuff to after first 3 planetary sciences, and then change all costs to include all science packs they're dependent on.

-- Edit items from mining boulders - more niter, more stone, more coal.
RAW["simple-entity"]["huge-rock"].minable.results = {
	{type = "item", name = "stone", amount_min = 25, amount_max = 75}, -- Was 24-50.
	{type = "item", name = "coal", amount_min = 25, amount_max = 75}, -- Was 24-50.
	{type = "item", name = "niter", amount_min = 0, amount_max = 20}, -- Added.
}
RAW["simple-entity"]["big-rock"].minable.results = {
	{type = "item", name = "stone", amount_min = 30, amount_max = 50}, -- Was 20.
	{type = "item", name = "coal", amount_min = 0, amount_max = 30}, -- Added.
	{type = "item", name = "niter", amount_min = 0, amount_max = 10}, -- Added.
}
RAW["simple-entity"]["big-sand-rock"].minable.results = {
	{type = "item", name = "stone", amount_min = 30, amount_max = 50}, -- Was 19-25.
	{type = "item", name = "coal", amount_min = 0, amount_max = 20}, -- Added.
	{type = "item", name = "niter", amount_min = 0, amount_max = 20}, -- Added.
}
-- TODO also boulders etc in other places, eg Vulcanus needs niter.

-- Diurnal Dynamics: hide flare from factoriopedia, since we're disabling it using mod setting.
RAW.capsule["data-dd-flare-capsule"].hidden_in_factoriopedia = true
RECIPE["data-dd-flare-capsule"].hidden_in_factoriopedia = true
-- Also hide non-user-facing stuff from factoriopedia. (Shouldn't be created at all if flares are disabled.)
RAW.explosion["data-dd-explosion-flare"].hidden = true
RAW.projectile["data-dd-flare-capsule"].hidden = true
RAW["smoke-with-trigger"]["data-dd-flare-cloud"].hidden = true

-- Reduce health of furnaces and pipes, to encourage building walls.
RAW.pipe.pipe.max_health = 35 -- Reduced from 100 to 35. Wall is 350.
FURNACE["stone-furnace"].max_health = 100 -- Reduced from 200 to 100.
-- TODO rather go through all infra and edit healths. A lot of them are too high or low.

-- Make bots faster. This makes them a bit ridiculous at full +6 bot speed tech, but that's fine.
RAW["construction-robot"]["construction-robot"].speed = 0.12 -- Was 0.06
RAW["logistic-robot"]["logistic-robot"].speed = 0.10 -- Was 0.05

-- Logistics 1 tech doesn't give "faster ways of transportation".
TECH["logistics"].localised_description = {"technology-description.logistics-1"}

-- Beacon interface should be hidden. TODO move to file for apprentice foundry.
Item.hide("beacon-interface--beacon")

-- Change GUI.
RAW["utility-constants"].default.select_slot_row_count = 12 -- Was 10. This is the number of slots per row in the crafting menu, Factoriopedia, etc.
RAW["utility-constants"].default.select_group_row_count = 7 -- Was 6. This is the number of item-group's per row in the crafting menu, Factoriopedia, etc. The width of the menu seems to be determined by select_slot_row_count above, then gets split up for the item-groups; unless there's not enough, then these group tabs push it wider? Might still be something off here.

-- Boost some character speed stats, because this modpack is for people who are not slow in the head.
local character = RAW.character.character
character.ticks_to_keep_aiming_direction = 50 -- default 100
character.running_speed = .2 -- default 0.15
--character.distance_per_frame = .13 -- default 0.13, seems to be for calculating how fast to play animation frames (along with eg speed bonuses from exoskeletons), so shouldn't be changed.
-- TODO maybe add some techs for running speed bonuses? Or can we have eg techs for spidertron running speed, car driving speed, etc.?