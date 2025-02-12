local Tech = require("code.util.tech")
local Recipe = require("code.util.recipe")
local Item = require("code.util.item")

-- Nerf heating towers' efficiency, and reduce energy consumption.
data.raw.reactor["heating-tower"].energy_source.effectivity = 1 -- 2.5 to 1
data.raw.reactor["heating-tower"].consumption = "10MW" -- Originally 40MW.

-- Remove the quality tooltip icon.
data.raw.sprite["quality_info"].filename = "__LegendarySpaceAge__/graphics/misc/empty-quality-icon.png"

-- Add electric energy distribution as prereq to Fulgora and Vulcanus, since you can't get wood for wooden poles there, and now you can't even research electric energy distribution there since you can't build labs.
Tech.addTechDependency("electric-energy-distribution-1", "planet-discovery-fulgora")
Tech.addTechDependency("electric-energy-distribution-1", "planet-discovery-vulcanus")

-- Make some recipe times more sane.
data.raw.recipe["stone-brick"].energy_required = 2 -- Originally 3.2.
for _, recipeName in pairs{"hazard-concrete", "refined-hazard-concrete"} do
	data.raw.recipe[recipeName].energy_required = 10 -- Originally 0.25.
end

-- Increase storage of starting base, so there's enough space for all starting items.
data.raw.container["crash-site-spaceship"].inventory_size = 10
data.raw.container["crash-site-spaceship-wreck-big-2"].inventory_size = 5
data.raw.container["crash-site-spaceship-wreck-medium-1"].inventory_size = 5

-- TODO make module recipes more complex -- add resin, and maybe make tier 2 and tier 3 require stuff from separate planets.

-- TODO tech tree change - add nuclear science, move nuclear stuff to after first 3 planetary sciences, and then change all costs to include all science packs they're dependent on.

-- Edit items from mining boulders - more niter, more stone, more coal.
data.raw["simple-entity"]["huge-rock"].minable.results = {
	{type = "item", name = "stone", amount_min = 25, amount_max = 75}, -- Was 24-50.
	{type = "item", name = "coal", amount_min = 25, amount_max = 75}, -- Was 24-50.
	{type = "item", name = "niter", amount_min = 0, amount_max = 20}, -- Added.
}
data.raw["simple-entity"]["big-rock"].minable.results = {
	{type = "item", name = "stone", amount_min = 30, amount_max = 50}, -- Was 20.
	{type = "item", name = "coal", amount_min = 0, amount_max = 30}, -- Added.
	{type = "item", name = "niter", amount_min = 0, amount_max = 10}, -- Added.
}
data.raw["simple-entity"]["big-sand-rock"].minable.results = {
	{type = "item", name = "stone", amount_min = 30, amount_max = 50}, -- Was 19-25.
	{type = "item", name = "coal", amount_min = 0, amount_max = 20}, -- Added.
	{type = "item", name = "niter", amount_min = 0, amount_max = 20}, -- Added.
}
-- TODO also boulders etc in other places, eg Vulcanus needs niter.

-- Allow burner inserters to leech. Unclear why this is off by default.
data.raw.inserter["burner-inserter"].allow_burner_leech = true

-- Diurnal Dynamics: hide flare from factoriopedia, since we're disabling it using mod setting.
data.raw.capsule["data-dd-flare-capsule"].hidden_in_factoriopedia = true
data.raw.recipe["data-dd-flare-capsule"].hidden_in_factoriopedia = true
-- Also hide non-user-facing stuff from factoriopedia. (Shouldn't be created at all if flares are disabled.)
data.raw.explosion["data-dd-explosion-flare"].hidden = true
data.raw.projectile["data-dd-flare-capsule"].hidden = true
data.raw["smoke-with-trigger"]["data-dd-flare-cloud"].hidden = true

-- Reduce health of furnaces and pipes, to encourage building walls.
data.raw.pipe.pipe.max_health = 35 -- Reduced from 100 to 35. Wall is 350.
data.raw.furnace["stone-furnace"].max_health = 100 -- Reduced from 200 to 100.

-- Make bots faster. This makes them a bit ridiculous at full +6 bot speed tech, but that's fine.
data.raw["construction-robot"]["construction-robot"].speed = 0.12 -- Was 0.06
data.raw["logistic-robot"]["logistic-robot"].speed = 0.10 -- Was 0.05

-- Logistics 1 tech doesn't give "faster ways of transportation".
data.raw.technology["logistics"].localised_description = {"technology-description.logistics-1"}

-- Spidertron Enhancements
data.raw["character-corpse"]["spidertron-enhancements-corpse"].hidden_in_factoriopedia = true
--data.raw["spider-vehicle"]["spidertron-enhancements-dummy-spidertron"].hidden_in_factoriopedia = true
--data.raw["spider-vehicle"]["spidertron-enhancements-dummy-spidertron"].factoriopedia_alternative = "spidertron"

-- Beacon interface should be hidden. TODO move to file for apprentice foundry.
Item.hide("beacon-interface--beacon")