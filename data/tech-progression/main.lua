-- This file adjusts the overall progression, by moving techs around, changing dependencies, moving recipes between techs, etc.

-- Early techs: basic electricity, then electronics, then personal burner generator, then red science, then automation, then filtration, then steam power.
Tech.setPrereqs("electronics", {"basic-electricity", "char", "glass"})
Tech.setPrereqs("automation", {"electronics", "lamp"})
Tech.addTechDependency("filtration-lake-water", "steam-power")
TECH["steam-power"].unit = nil
TECH["steam-power"].research_trigger = {
	type = "craft-fluid",
	fluid = "water",
	amount = 1000,
}
TECH["automation"].unit = nil
TECH["automation"].research_trigger = {
	type = "craft-item",
	item = "electronic-circuit",
	count = 1,
}

-- In the gap between automation and automation-science-pack, player does production challenge of like 150 hot iron per minute.
TECH["automation-science-pack"].prerequisites = {"automation"}
Tech.removeRecipeFromTech("lab", "electronics")
Tech.addRecipeToTech("lab", "automation-science-pack")
Recipe.edit{
	recipe = "automation-science-pack",
	ingredients = {"mechanism", "wiring"},
	time = 1,
}

-- Move electric inserter to automation tech.
Tech.removeRecipeFromTech("inserter", "electronics")
Tech.addRecipeToTech("inserter", "automation")

-- Unlock electronics when a hand-crank is built.
TECH["electronics"].unit = nil
TECH["electronics"].research_trigger = {
	type = "build-entity",
	entity = "er-hcg",
}

-- Move pipe recipes from steam power to automation.
-- Remove offshore pump recipe from steam power, will add to filtration.
TECH["steam-power"].effects = {
	{type = "unlock-recipe", recipe = "boiler"},
	{type = "unlock-recipe", recipe = "gas-boiler"},
	{type = "unlock-recipe", recipe = "electric-boiler"},
	{type = "unlock-recipe", recipe = "steam-engine"},
}
-- Remove tech for electric boiler, rather putting recipe in steam-power tech.
Tech.hideTech("electric-boiler")

-- Tank ship shouldn't depend on Fluid handling 2. 
Tech.setPrereqs("tank_ship", {"automated_water_transport", "fluid-handling"})

-- Logistics 2 depends on rubber.
Tech.addTechDependency("rubber-1", "logistics-2")

-- Car shouldn't need logistics 2, should need rubber.
Tech.setPrereqs("automobilism", {"rubber-1", "engine"})

-- Railway shouldn't depend on logistics 2.
Tech.setPrereqs("railway", {"engine"})

-- Logistics chain 2->3
Tech.addTechDependency("logistics-2", "logistics-3")

-- Move chem plant to early game, since it's needed for coal coking and gunpowder.
Tech.removeRecipeFromTech("chemical-plant", "oil-processing")

-- Coal liquefaction tech should be soon after oil processing.
Tech.setPrereqs("coal-liquefaction", {"oil-processing"})
Tech.setUnit("coal-liquefaction", {count = 200, ingredients = {{"automation-science-pack", 1}, {"logistic-science-pack", 1}}, time = 30})

-- Concrete no longer needs automation-2 since assembling machine 1 can handle fluids.
Tech.setPrereqs("concrete", {"cement", "steel-processing"})
-- Same for fluid-handling.
Tech.setPrereqs("fluid-handling", {"logistic-science-pack"})

-- Plastics need syngas.
Tech.setPrereqs("plastics", {"coal-liquefaction"})

-- Sulfur tech unlocks sulfuric acid. So it needs fluid handling. But also we need sulfuric acid -> rubber-1 -> fluid-handling.
-- Could solve this by moving sulfuric acid recipe to rubber tech, removing sulfur tech.
-- But we also need sulfuric acid for eg fertilizer. So rather keep it as a separate tech.
Tech.setPrereqs("sulfur-processing", {"filtration-lake-water", "automation-science-pack"})
TECH["sulfur-processing"].unit = TECH["ammonia-1"].unit

Tech.setPrereqs("explosives", {"coal-liquefaction", "ammonia-1"}) -- Previously sulfur-processing

-- Remove pointless "gas and oil gathering" tech, merge with petrochemistry 1.
Tech.hideTech("oil-gathering")
TECH["oil-processing"].unit = TECH["oil-gathering"].unit
TECH["oil-processing"].research_trigger = nil
TECH["oil-processing"].prerequisites = {"fluid-handling"}
Tech.addRecipeToTech("pumpjack", "oil-processing", 2)

-- Move advanced-oil-processing to after oil-processing.
Tech.setPrereqs("advanced-oil-processing", {"oil-processing"})
TECH["advanced-oil-processing"].unit = {
	count = 75,
	time = 30,
	ingredients = {
		{"automation-science-pack", 1},
		{"logistic-science-pack", 1},
	},
}

-- Remove the lubricant tech. Rather merge it with actuator / advanced robotics.
Tech.hideTech("lubricant")
Tech.replacePrereq("logistics-3", "lubricant", "electric-engine")
Tech.setPrereqs("electric-engine", {"processing-unit", "steel-processing"})
Tech.addRecipeToTech("lubricant", "electric-engine", 1)

-- Rubber-2 is needed to make rubber from petrochems on Vulcanus and Fulgora.
Tech.addTechDependency("rubber-2", "planet-discovery-vulcanus")
Tech.addTechDependency("rubber-2", "planet-discovery-fulgora")

-- Fulgora needs electric mining drill, bc burner miners don't work.
Tech.addTechDependency("electric-mining-drill", "planet-discovery-fulgora")

-- Electric mining drill shouldn't be affected by tech multiplier since it's very early-game, making it 250 science instead of 25 is just annoying because it's not high enough to justify setting up with burner miners.
TECH["electric-mining-drill"].ignore_tech_cost_multiplier = true

-- Move long inserter to logistics 2.
Tech.removeRecipeFromTech("long-handed-inserter", "automation")
Tech.addRecipeToTech("long-handed-inserter", "logistics-2")

-- Fast inserter should go after actuator.
Tech.setPrereqs("fast-inserter", {"electric-engine"})
TECH["fast-inserter"].unit = {count = 50, ingredients = {{"automation-science-pack", 1}, {"logistic-science-pack", 1}, {"chemical-science-pack", 1}}, time = 30}
Tech.setPrereqs("bulk-inserter", {"fast-inserter"})
TECH["bulk-inserter"].unit = {count = 100, ingredients = {{"automation-science-pack", 1}, {"logistic-science-pack", 1}, {"chemical-science-pack", 1}}, time = 30}
-- Inserter capacity techs should need more advanced science packs, since they're now after chem science.
TECH["inserter-capacity-bonus-1"].unit = {count = 150, ingredients = {{"automation-science-pack", 1}, {"logistic-science-pack", 1}, {"chemical-science-pack", 1}}, time = 30}
TECH["inserter-capacity-bonus-2"].unit = {count = 200, ingredients = {{"automation-science-pack", 1}, {"logistic-science-pack", 1}, {"chemical-science-pack", 1}}, time = 30}

-- Remove tech for advanced combinators, and move selector combinator recipe.
Tech.hideTech("advanced-combinators")
Tech.addRecipeToTech("selector-combinator", "circuit-network", 4)
-- Move circuit network to after electric-energy-distribution-1, so there's not so much right after green science.
Tech.removePrereq("circuit-network", "logistic-science-pack")
Tech.addTechDependency("electric-energy-distribution-1", "circuit-network")

-- Add red circuit dependency to lasers, so we can add it as ingredient.
Tech.addTechDependency("advanced-circuit", "laser")

-- Automation 2 after green science.
Tech.setPrereqs("automation-2", {"logistic-science-pack"})

-- Heating tower tech should be fairly early.
Tech.setPrereqs("heating-tower", {"steel-processing", "fluid-handling", "advanced-material-processing"})
TECH["heating-tower"].unit = {count = 300, ingredients = {{"automation-science-pack", 1}, {"logistic-science-pack", 1}}, time = 30}
TECH["heating-tower"].research_trigger = nil

-- Heating tower doesn't need to go to Aquilo, since we now have heating tower -> condensing turbine -> space platforms.
Tech.removePrereq("planet-discovery-aquilo", "heating-tower")
Tech.addTechDependency("condensing-turbine", "rocket-silo")

-- Nuclear is going to post-triplets, and heating tower is early, so remove heating tower stuff fom nuclear tech.
Tech.removeRecipesFromTechs({"heat-exchanger", "heat-pipe", "steam-turbine"}, {"nuclear-power"})

-- Logistic (green) science needs steam, rubber.
Recipe.edit{
	recipe = "logistic-science-pack",
	ingredients = {
		{"steam", 10},
		{"sensor", 1},
		{"rubber", 1},
	},
	category = "crafting-with-fluid",
	time = 1,
	resultCount = 1,
}
-- Could make green science depend only on rubber and steam-power. But that's sorta guiding people in the direction of not automating circuit boards. Rather make it a prereq. That also lets us assume resin is available after green science.
Tech.setPrereqs("logistic-science-pack", {"rubber-1", "wood-circuit-board"})

-- Military stuff: move things around so military science pack can be made from poison/slowdown capsules, which now come earlier, while grenades come later.
-- Also, change stuff so that shotgun and shotgun turrets come first, then SMG and rotary gun turrets.
TECH["military-science-pack"].prerequisites = {"military-2"}
Recipe.edit{
	recipe = "military-science-pack",
	ingredients = {"poison-capsule", "slowdown-capsule", "piercing-rounds-magazine"},
	resultCount = 1,
	time = 1,
}
Tech.removeRecipesFromTechs({"poison-capsule", "slowdown-capsule"}, {"military-3"})
Tech.addRecipeToTech("poison-capsule", "military-2")
Tech.addRecipeToTech("slowdown-capsule", "military-2")
Tech.removeRecipeFromTech("grenade", "military-2")
Tech.addRecipeToTech("grenade", "military-3")
TECH["military-2"].prerequisites = {"military", "ammonia-1", "steel-processing"}
	-- It also needs pitch for the poison capsule - but you can get that from either advanced-oil-processing or coal-coking techs, so not going to have prereqs for that.
Tech.addTechDependency("explosives", "military-3")
Tech.removePrereq("military-4", "explosives")
Tech.setPrereqs("stronger-explosives-1", {"military-3"})
Tech.addSciencePack("stronger-explosives-1", "military-science-pack")
Tech.setPrereqs("gate", {"stone-wall", "steel-processing", "logistic-science-pack"})
Tech.removeRecipesFromTechs({"shotgun", "shotgun-shell"}, {"military"})
Tech.addRecipeToTech("firearm-magazine", "military")
TECH["military"].prerequisites = {"gunpowder", "automation-science-pack"}
TECH["gun-turret"].prerequisites = {"military"}

-- Add red circuit prereq to techs that need red circuits as ingredients.
Tech.addTechDependency("advanced-circuit", "electric-energy-distribution-2")
Tech.addTechDependency("advanced-circuit", "advanced-material-processing-2")
Tech.addTechDependency("advanced-circuit", "tank")

-- Gleba science pack
RECIPE["agricultural-science-pack"].ingredients = {
	--{type = "item", name = "slipstack-pearl", amount = 1},
	{type = "item", name = "activated-pentapod-egg", amount = 1},
	{type = "item", name = "stingfrond-sprout", amount = 1},
		-- Want it to be tied to cyclosomes, not neurofibrils. And don't want to have to worry about the phase, so using sprout rather than cyclosomes.
	--{type = "item", name = "sprouted-boomnut", amount = 1},
	{type = "item", name = "petrophage", amount = 1},
	--{type = "item", name = "marrow", amount = 1},
}
-- Allow science pack to be made on any planet - it's probably not optimal (since eg stingfronds are hard to cultivate on Nauvis) but might still be interesting.
RECIPE["agricultural-science-pack"].surface_conditions = nil

TECH["agricultural-science-pack"].research_trigger = { -- TODO later this should be a rate trigger on bioflux.
	type = "craft-item",
	item = "bioflux",
	count = 1000,
}

-- Make gate tech auto-unlock, otherwise I'm going to just forgo it.
TECH["gate"].unit = nil
TECH["gate"].research_trigger = {
	type = "craft-item",
	item = "stone-wall",
	count = 100,
}
TECH["gate"].prerequisites = {"stone-wall"}

-- Wall needs red science.
Tech.setPrereqs("stone-wall", {"automation-science-pack"})

-- Lamp should be earlier.
Tech.setPrereqs("lamp", {"basic-electricity", "glass"})
TECH["lamp"].unit = nil
TECH["lamp"].research_trigger = {
	type = "craft-item",
	item = "glass",
	count = 1,
}

-- Add gas vent and waste pump to fluid-handling tech.
Tech.addRecipeToTech("waste-pump", "fluid-handling")
Tech.addRecipeToTech("gas-vent", "fluid-handling")

-- Gleba needs advanced oil processing, to turn pitch (from petrophages) into light oil for explosives etc.
Tech.addTechDependency("advanced-oil-processing", "planet-discovery-gleba")

-- Hide health techs.
Tech.hideTech("health")

-- Rocket silo shouldn't depend on rocket fuel. Should depend on hydrogen/oxygen techs.
Tech.removePrereq("rocket-silo", "rocket-fuel")
-- TODO add hydrogen/oxygen techs.

-- Rocket silo doesn't need concrete, since we replaced those ingredients with structure etc.
Tech.removePrereq("rocket-silo", "concrete")

-- Remove rocket fuel from rocket part recipe. TODO later we should re-write this recipe completely maybe.
RECIPE["rocket-part"].ingredients = {
	{type = "item", name = "electric-engine-unit", amount = 1},
	{type = "item", name = "low-density-structure", amount = 1},
	{type = "item", name = "shielding", amount = 1},
}

-- Chemical science pack: 1 barrel diesel + 2 plastic -> 2 chemical science packs.
Recipe.edit{
	recipe = "chemical-science-pack",
	ingredients = {
		{"plastic-bar", 1},
		{"diesel", 20, type = "fluid"},
		{"ammonia", 20},
	},
	resultCount = 1,
	time = 1,
	category = "chemistry",
}
TECH["chemical-science-pack"].prerequisites = {"plastics", "diesel", "ammonia-1"}

-- Blue circuits need a new dependency on red circuits.
Tech.addTechDependency("advanced-circuit", "processing-unit")

-- Remove steel prereq from some techs that don't really need steel, due to our factor intermediate system.
Tech.removePrereq("electric-energy-distribution-1", "steel-processing")
Tech.removePrereq("engine", "steel-processing") -- TODO change engine recipe

-- Solar comes after blue circuits. It and its dependent techs should use chem science.
Tech.setPrereqs("solar-energy", {"processing-unit"})
Tech.addSciencePack("solar-energy", "chemical-science-pack")
Tech.addSciencePack("solar-panel-equipment", "chemical-science-pack")
Tech.addSciencePack("battery-equipment", "chemical-science-pack")
Tech.addSciencePack("belt-immunity-equipment", "chemical-science-pack")
Tech.addSciencePack("night-vision-equipment", "chemical-science-pack")
Tech.addTechDependency("solar-energy", "rocket-silo")

-- Battery needs green science.
Tech.addTechDependency("logistic-science-pack", "battery")

-- Move engine to after fluid handling.
Tech.removePrereq("engine", "logistic-science-pack")
Tech.addTechDependency("fluid-handling", "engine")

-- TODO elevated rail tech should be a prereq for Vulcanus and Fulgora. So it should also not require purple science. Also it shouldn't have a concrete prereq either.
Tech.addTechDependency("elevated-rail", "planet-discovery-vulcanus")
Tech.addTechDependency("elevated-rail", "planet-discovery-fulgora")
Tech.removeSciencePack("production-science-pack", "elevated-rail")
Tech.setPrereqs("elevated-rail", {"railway", "chemical-science-pack"})

-- Fulgoran techs: EM plants -> white circuits -> superclocking -> electromagnetic-science-pack.
Tech.setPrereqs("electromagnetic-science-pack", {"superclocked-circuits"})
TECH["electromagnetic-science-pack"].research_trigger = {
	type = "craft-item",
	item = "white-circuit",
	count = 10,
} -- TODO later this should be a rate trigger on white circuits.

-- Production science pack: need to remove prod module at least, since I'm deleting all modules.
-- TODO later rewrite this recipe entirely to be more interesting.
Recipe.edit{
	recipe = "production-science-pack",
	ingredients = { -- Originally 30 rail + 1 electric furnace + 1 prod module 1 -> 3 prod science packs.
		{"electric-engine-unit", 1},
		{"sensor", 1},
		{"structure", 1},
	},
	resultCount = 1,
}

-- Make red circuits require beacons 1, so that I can put the charging recipe in the red-circuit tech.
Tech.addTechDependency("basic-beacons", "advanced-circuit")

-- Move AAI signal transmission tech to after Fulgora.
Tech.addTechDependency("electromagnetic-science-pack", "aai-signal-transmission")
Tech.removePrereq("aai-signal-transmission", "space-science-pack")
Tech.addSciencePack("aai-signal-transmission", "electromagnetic-science-pack")

-- Add first 2 qualities to assembler 3 tech. (Originally in quality module tech. Assembler 3 now has builtin quality bonus.)
local assembler3Tech = TECH["automation-3"]
table.insert(assembler3Tech.effects, {
	type = "unlock-quality",
	quality = "uncommon",
})
table.insert(assembler3Tech.effects, {
	type = "unlock-quality",
	quality = "rare",
})

-- Make assembler 3 mandatory before Fulgora, since white circuits add quality, so we need quality to be unlocked by then.
Tech.addTechDependency("automation-3", "planet-discovery-fulgora")
-- Make assembler 3 tech not require purple science, so you can do Fulgora before purple science.
Tech.setPrereqs("automation-3", {"automation-2", "electric-engine"})
Tech.removeSciencePack("production-science-pack", "automation-3")

-- Logistics 1 tech doesn't give "faster ways of transportation".
TECH["logistics"].localised_description = {"technology-description.logistics-1"}

-- Move cryo tech to early game.
Tech.setPrereqs("cryogenic-plant", {"air-separation", "coal-liquefaction"}) -- Needs coal liquefaction for syngas.
Tech.setUnit("cryogenic-plant", {
	count = 100,
	ingredients = {{"automation-science-pack", 1}, {"logistic-science-pack", 1}},
	time = 15,
})
TECH["cryogenic-plant"].research_trigger = nil
-- Cryo plant is needed before rocket silo.
Tech.addTechDependency("cryogenic-plant", "rocket-silo")
-- Repair cryo science pack tech.
TECH["cryogenic-science-pack"].prerequisites = {"lithium-processing"}
TECH["cryogenic-science-pack"].research_trigger = {
	type = "craft-item",
	item = "lithium-plate",
	count = 10,
}
-- Make a separate tech for regenerative cooling.
local cryo2Tech = copy(TECH["cryogenic-plant"])
cryo2Tech.name = "cryogenic-plant-2"
cryo2Tech.prerequisites = {"cryogenic-plant", "chemical-science-pack"}
cryo2Tech.effects = {
	{type = "unlock-recipe", recipe = "regenerative-cooling"},
}
cryo2Tech.unit = {
	count = 100,
	ingredients = {{"automation-science-pack", 1}, {"logistic-science-pack", 1}, {"chemical-science-pack", 1}},
	time = 30,
}
cryo2Tech.localised_description = {"technology-description.cryogenic-plant-2"}
extend{cryo2Tech}

-- Add dependency from fluid containers to rocket silo, since you need barrelled nitrogen for Apollo.
Tech.addTechDependency("fluid-containers", "rocket-silo")

--[[ Changes for lunar science and asteroid science.
Overall progression goes (space platform + thrusters) -> (Apollo + lunar science) -> (asteroid belts + crushers/grabbers + space science) -> planets.
Note that I'm reusing tech IDs to preserve tech dependencies etc, especially since other planet mods might use them:
	* space-platform-thruster tech is reused for asteroid science pack.
	* space-science-pack is reused for Apollo and lunar science pack.
]]
Tech.moveRecipeToTech("thruster", "space-platform-thruster", "space-platform")
Tech.removeRecipeFromTech("ice-melting", "space-platform-thruster") -- Will add to Apollo tech when that's created.
Tech.moveRecipeToTech("asteroid-collector", "space-platform", "space-platform-thruster")
for _, recipeName in pairs{
	"crusher",
	"metallic-asteroid-crushing",
	"oxide-asteroid-crushing",
	"carbonic-asteroid-crushing",
} do
	Tech.removeRecipeFromTech(recipeName, "space-platform")
end

-- Make a new tech for asteroid crushing.
local asteroidCrushingTech = copy(TECH["space-platform-thruster"])
asteroidCrushingTech.name = "asteroid-crushing"
asteroidCrushingTech.effects = {
	{type = "unlock-recipe", recipe = "crusher"},
	{type = "unlock-recipe", recipe = "metallic-asteroid-crushing"},
	{type = "unlock-recipe", recipe = "oxide-asteroid-crushing"},
	{type = "unlock-recipe", recipe = "carbonic-asteroid-crushing"},
}
Icon.set(asteroidCrushingTech, "SA/asteroid-productivity")
asteroidCrushingTech.prerequisites = {"space-platform-thruster"}
extend{asteroidCrushingTech}
Tech.addTechDependency("asteroid-crushing", "advanced-asteroid-processing")
Tech.addTechDependency("asteroid-crushing", "asteroid-reprocessing")

-- Since we're adding asteroid science, make techs also require that. Add it to all techs that require lunar science pack, except a few specific ones.
local function techUsesLunarScience(ingredients)
	for _, ingredient in pairs(ingredients) do
		if ingredient[1] == "space-science-pack" then
			return true
		end
	end
	return false
end
local lunarScienceOnlyTechs = Table.listToSet{
	"electric-weapons-damage-2",
	"worker-robots-speed-6",
	"stronger-explosives-5",
	"stronger-explosives-6",
	"asteroid-science-pack",
}
for techName, tech in pairs(TECH) do
	if not lunarScienceOnlyTechs[techName] then
		if tech.unit ~= nil then
			if techUsesLunarScience(tech.unit.ingredients) then
				table.insert(tech.unit.ingredients, {"asteroid-science-pack", 1})
			end
		end
	end
end
-- some techs that depended on lunar science pack now also need asteroid science pack, so replace the prereq.
for _, techName in pairs{
	"laser-weapons-damage-7",
	"follower-robot-count-5",
	"refined-flammables-6",
	"physical-projectile-damage-7",
} do
	Tech.replacePrereq(techName, "space-science-pack", "space-platform-thruster")
end

-- Make tech for chem plant.
-- TODO

-- TODO make techs for electronics, unlocking extra recipes for sensors, electronic components, etc. Using graphics from 1.1 techs.

-- TODO Make tech for chemistry, and move chem plant to that.

-- TODO edit recipes for other science packs.

-- TODO lubricant should come earlier, so that we can unlock advanced parts early, and then put it in many recipes.

-- TODO later, instead of using a tech multiplier in the map preset, rather just go through and set units (counts, times, ingredients) for all techs individually. Otherwise there's weird stuff like mismatches in science times (ie number of labs vs science assemblers), weird counts that don't make sense, etc.

-- TODO should engines need rubber? If so, need to add rubber=>engine dependency.

-- TODO write some code to toposort the whole tech tree and then assign order strings.

-- TODO tech tree change - add nuclear science, move nuclear stuff to after first 3 planetary sciences, and then change all costs to include all science packs they're dependent on.