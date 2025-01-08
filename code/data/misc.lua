local Tech = require("code.util.tech")
local Recipe = require("code.util.recipe")

-- Nerf heating towers' efficiency, and reduce energy consumption.
data.raw.reactor["heating-tower"].energy_source.effectivity = 1 -- 2.5 to 1
data.raw.reactor["heating-tower"].consumption = "8MW"

-- Make space platform tiles more complex and expensive to produce.
-- Originally 20 steel plate + 20 copper cable.
data.raw.recipe["space-platform-foundation"].ingredients = {
	{ type = "item", name = "low-density-structure", amount = 10 },
		-- Effectively 200 copper plate, 20 steel plate, 50 plastic.
	{ type = "item", name = "copper-cable", amount = 10 },
	{ type = "item", name = "electric-engine-unit", amount = 1 },
		-- Effectively lubricant plus metals.
	{ type = "item", name = "processing-unit", amount = 1 },
		-- Effectively sulfuric acid + plastic + metals.
}

-- Remove the quality tooltip icon.
data.raw.sprite["quality_info"].filename = "__LegendarySpaceAge__/graphics/misc/empty-quality-icon.png"

-- Add electric energy distribution as prereq to Fulgora and Vulcanus, since you can't get wood for wooden poles there, and now you can't even research electric energy distribution there since you can't build labs.
Tech.addTechDependency("electric-energy-distribution-1", "planet-discovery-fulgora")
Tech.addTechDependency("electric-energy-distribution-1", "planet-discovery-vulcanus")

-- Make some recipe times more sane.
data.raw.recipe["stone-brick"].energy_required = 4 -- Originally 3.2.
for _, recipeName in pairs{"wooden-chest", "iron-chest", "steel-chest"} do
	data.raw.recipe[recipeName].energy_required = 4 -- Originally 0.5.
end
for _, recipeName in pairs{"hazard-concrete", "refined-hazard-concrete"} do
	data.raw.recipe[recipeName].energy_required = 10 -- Originally 0.25.
end

-- Move iron rod to be enabled from the start, and remove it from techs.
data.raw.recipe["iron-stick"].enabled = true
data.raw.recipe["rocs-rusting-iron-iron-stick-derusting"].enabled = true
Tech.removeRecipesFromTechs(
	{"iron-stick", "rocs-rusting-iron-iron-stick-derusting"},
	{"railway", "circuit-network", "electric-energy-distribution-1", "concrete"})
-- And add iron rod as ingredient in some recipes.
data.raw.recipe["burner-inserter"].ingredients = {
	{ type = "item", name = "iron-stick", amount = 2 },
	{ type = "item", name = "iron-gear-wheel", amount = 2 },
}
data.raw.recipe["inserter"].ingredients = {
	{ type = "item", name = "iron-stick", amount = 2 },
	{ type = "item", name = "iron-gear-wheel", amount = 2 },
	{ type = "item", name = "electronic-circuit", amount = 1 },
}
data.raw.recipe["long-handed-inserter"].ingredients = {
	{ type = "item", name = "iron-stick", amount = 2 },
	{ type = "item", name = "iron-gear-wheel", amount = 2 },
	{ type = "item", name = "inserter", amount = 1 },
}
data.raw.recipe["radar"].ingredients = {
	{ type = "item", name = "iron-stick", amount = 5 },
	{ type = "item", name = "iron-plate", amount = 10 },
	{ type = "item", name = "iron-gear-wheel", amount = 5 },
	{ type = "item", name = "electronic-circuit", amount = 5 },
}



-- Make assembler 1 take fluid ingredients? For latex. TODO

-- TODO remove health techs.

-- TODO make module recipes more complex -- add resin, and maybe make tier 2 and tier 3 require stuff from separate planets.

-- TODO tech tree change - add nuclear science, move nuclear stuff to after first 3 planetary sciences, and then change all costs to include all science packs they're dependent on.

-- TODO change oil processing to require research, not trigger.

-- TODO get rid of advanced combinators tech, rather move the selector combinator into the main combinators tech.