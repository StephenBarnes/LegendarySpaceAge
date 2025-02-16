--[[ This file gets the sets of items/fluids available right before and right after each tech.
Right before each tech, it's basically the union of everything in the post-set of each prereq tech.
Right after each tech, it's that set plus also the tech's own unlocked recipes.
There are also some items implicitly unlocked by others (eg pumpjack unlocks crude oil) and some items that are available from the start (eg stone).

We consider items/fluids on different planets, or space, as separate things.
Each item/fluid gets a ID like: "nauvis:item:iron-ore" or "vulcanus:fluid:water".
We also have IDs for recipes like "recipe:iron-plate".
We also have IDs for player being able to land on a planet like "planet:nauvis", and imports to a planet like "imports:nauvis", and exports from a planet like "exports:nauvis". Note "exports:gleba" means we can launch a rocket carrying stuff from Gleba, while "imports:gleba" means we can import to Gleba, which requires a tech.
]]

local Util = require("data.autodebug.util")
local VERBOSE = true

------------------------------------------------------------------------
--- CONSTANTS

local unlockedAtStart = Table.listToSet{
	"planet:nauvis",
	"nauvis:item:wood",
	"nauvis:item:resin",
	"nauvis:item:tree-seed",
	"nauvis:item:iron-ore",
	"nauvis:item:copper-ore",
	"nauvis:item:coal",
	"nauvis:item:stone",
	"nauvis:item:niter",
}
-- Add all recipes that are enabled at start.
for recipeName, recipe in pairs(RECIPE) do
	if (recipe.enabled == nil or recipe.enabled) and (not recipe.hidden) and (recipe.category ~= "recycling") then
		unlockedAtStart["recipe:"..recipeName] = true
	end
end
assert(unlockedAtStart["recipe:iron-gear-wheel"] == true)

-- Table of sets of things that unlock other things implicitly, without explicit recipes.
local implicitUnlocks = {
	-- Minable resources.
	{{"planet:fulgora"}, {"fulgora:item:scrap"}},
	{{"planet:gleba"}, {"gleba:item:wood", "gleba:item:wood", "gleba:item:yumako", "gleba:item:jellynut"}}, -- TODO more
	{{"planet:vulcanus"}, {"vulcanus:item:iron-ore", "vulcanus:item:calcite"}}, -- TODO more
	{{"planet:aquilo"}, {"aquilo:item:ice"}},
	{{"space:item:asteroid-collector"}, {"space:item:metallic-asteroid-chunk", "space:item:carbonic-asteroid-chunk", "space:item:oxide-asteroid-chunk"}},

	-- Fluids from offshore pumps.
	{{"nauvis:item:offshore-pump"}, {"nauvis:fluid:lake-water"}},
	{{"gleba:item:offshore-pump"}, {"gleba:fluid:slime"}},
	{{"fulgora:item:offshore-pump"}, {"fulgora:fluid:sludge"}},
	{{"vulcanus:item:offshore-pump"}, {"vulcanus:fluid:lava"}},
	{{"aquilo:item:offshore-pump"}, {"aquilo:fluid:ammoniacal-solution"}},

	-- Pumpjacks.
	{{"nauvis:item:pumpjack"}, {"nauvis:fluid:crude-oil", "nauvis:fluid:natural-gas"}},
	{{"aquilo:item:pumpjack"}, {"aquilo:fluid:natural-gas", "aquilo:fluid:fluorine", "aquilo:fluid:lithium-brine"}},
	{{"vulcanus:item:pumpjack"}, {"vulcanus:fluid:volcanic-gas", "vulcanus:item:sulfur"}},

	-- Rocket silo plus rocket parts allows you to go to space, and import/export space and Nauvis.
	{{"nauvis:item:rocket-silo", "nauvis:item:rocket-part"}, {"planet:space", "exports:nauvis", "imports:nauvis", "exports:space", "imports:space"}},
}
-- Add some implicit unlocks that apply to all planets.
local implicitUnlocksForAllPlanets = {
	{{"fluid:water", "item:electric-boiler"}, {"fluid:steam"}},
}
-- Add spoilage rules.
for itemType, _ in pairs(defines.prototypes.item) do
	for _, item in pairs(RAW[itemType] or {}) do
		if item.spoil_result ~= nil then
			table.insert(implicitUnlocksForAllPlanets, {{"item:"..item.name}, {"item:"..item.spoil_result}})
		end
	end
end
-- Expand these implicit unlocks on all planets to planet-specific sets.
for _, unlock in pairs(implicitUnlocksForAllPlanets) do
	for planetName, _ in pairs(Util.allPlanets) do
		local planetUnlock = copy(unlock)
		for key1, val1 in pairs(planetUnlock) do
			for key2, val2 in pairs(val1) do
				planetUnlock[key1][key2] = planetName..":"..val2
			end
		end
		table.insert(implicitUnlocks, planetUnlock)
		--log("Adding planet-specialized unlock: "..serpent.line(planetUnlock))
	end
end
-- Add implicit unlocks for rocket silos and rocket parts on other planets.
for _, planetName in pairs{"aquilo", "vulcanus", "fulgora", "gleba"} do
	table.insert(implicitUnlocks, {{planetName..":item:rocket-silo", planetName..":item:rocket-part"}, {"exports:"..planetName}})
end
-- Add implicit unlocks for wood/coal to ash, except on Fulgora and in space.
for _, planetName in pairs{"nauvis", "vulcanus", "gleba", "aquilo"} do
	table.insert(implicitUnlocks, {{planetName..":item:wood", planetName..":item:char-furnace"}, {planetName..":item:ash"}})
	table.insert(implicitUnlocks, {{planetName..":item:coal", planetName..":item:char-furnace"}, {planetName..":item:ash"}})
end
-- Add implicit unlocks for minable rocks, on each planet.
-- TODO
-- Build a table of these implicit unlocks indexed by item, for faster lookup.
local implicitUnlocksByItem = {}
for _, unlock in pairs(implicitUnlocks) do
	for _, prereqItem in pairs(unlock[1]) do
		Table.addToValList(implicitUnlocksByItem, prereqItem, unlock)
	end
end
-- Could add implicit unlock from recycler to all recycling recipes. Note this ignores the fact that we have to import the recycler to each planet.
-- For speed, could rather disable this. Just ignore recycling recipes for progression checks, since they don't make anything new available, except on Fulgora.
-- Hm, but we need to check progression on Fulgora. So I'll pretend all recycling recipes are Fulgora-only, in the get-recipe-to-planets file.
local recyclingRecipes = {}
for _, recipe in pairs(RECIPE) do
	if recipe.category == "recycling" then
		table.insert(recyclingRecipes, "recipe:"..recipe.name)
	end
end
implicitUnlocksByItem["fulgora:item:recycler"] = recyclingRecipes

-- Table of things implicitly unlocked by techs.
local unlockedImplicitlyByTech = {
}
-- Add implicit unlocks for planet discovery and atmospheric navigation techs.
for _, planetName in pairs{"aquilo", "vulcanus", "fulgora", "gleba"} do
	unlockedImplicitlyByTech["planet-discovery-"..planetName] = {"planet:"..planetName}
	if planetName ~= "aquilo" then -- TODO need to add atmospheric navigation tech for Aquilo. Ask that mod author, or else reimplement everything here.
		unlockedImplicitlyByTech["atmospheric-navigation-"..planetName] = {"imports:"..planetName}
	end
end

------------------------------------------------------------------------

---@param recipe data.RecipePrototype
---@param availableThings table<string, boolean>
---@param planet string
local function allProductsAlreadyAvailable(recipe, availableThings, planet)
	assert(recipe.results ~= nil, "Recipe has no products: "..serpent.line(recipe))
	for _, product in pairs(recipe.results) do
		local productID = Util.getCanonicalName(product, planet)
		if not availableThings[productID] then
			return false
		end
	end
	return true
end

---@param recipe data.RecipePrototype
---@param availableThings table<string, boolean>
---@param planet string
local function allIngredientsAvailable(recipe, availableThings, planet)
	assert(recipe.ingredients ~= nil, "Recipe has no ingredients: "..serpent.line(recipe))
	for _, ingredient in pairs(recipe.ingredients) do
		local ingredientID = Util.getCanonicalName(ingredient, planet)
		if not availableThings[ingredientID] then
			return false
		end
	end
	return true
end

-- Extends a set of available things (items, fluids, recipes) to include all products of recipes whose ingredients are available, and all implicit unlocks, and all imports.
local function extendToClosure(availableThings, thingToRecipes, recipeToPlanets)
	local anotherRound = true
	local anotherRoundReason = "INITIAL" -- Holds a string explaining why we're doing another round. For debugging.
	local numRounds = 0

	while anotherRound do
		numRounds = numRounds + 1
		anotherRound = false

		-- Add products of recipes, if ingredients are available.
		for recipeName, recipePlanets in pairs(recipeToPlanets) do
			if availableThings["recipe:"..recipeName] then
				for planetName, _ in pairs(recipePlanets) do
					if availableThings["planet:"..planetName] then
						if not allProductsAlreadyAvailable(RECIPE[recipeName], availableThings, planetName) then
							if allIngredientsAvailable(RECIPE[recipeName], availableThings, planetName) then
								-- TODO should also check that at least one of the machines are available, or it's handcraftable. Eg chem plants on Vulcanus.
								anotherRound = true
								anotherRoundReason = "Recipe: "..recipeName.." on planet "..planetName
								for _, product in pairs(RECIPE[recipeName].results) do
									local productID = Util.getCanonicalName(product, planetName)
									availableThings[productID] = true
								end
							end
						end
					end
				end
			end
		end

		-- Add implicit unlocks from things that are now unlocked.
		for availableThing, _ in pairs(availableThings) do
			for _, implicitUnlock in pairs(implicitUnlocksByItem[availableThing] or {}) do
				local unlockPrereqs = implicitUnlock[1]
				local unlockedItems = implicitUnlock[2]
				local allPrereqsSatisfied = (#unlockPrereqs == 1) or Table.allInSet(unlockPrereqs, availableThings)
				if allPrereqsSatisfied then
					for _, unlockedItem in pairs(unlockedItems) do
						if not availableThings[unlockedItem] then
							availableThings[unlockedItem] = true
							anotherRound = true
							anotherRoundReason = "Implicit unlock: "..availableThing
						end
					end
				end
			end
		end

		-- Add imports from planets where unlocked.
		for sourcePlanet, _ in pairs(Util.allPlanets) do
			for destPlanet, _ in pairs(Util.allPlanets) do
				if sourcePlanet ~= destPlanet then
					if availableThings["exports:"..sourcePlanet] and availableThings["imports:"..destPlanet] then
						for thing, _ in pairs(availableThings) do
							-- If thing starts with string sourcePlanet .. ":"
							if string.sub(thing, 1, #sourcePlanet + 5) == sourcePlanet..":item" then
								local destThing = destPlanet..":"..string.sub(thing, #sourcePlanet + 2)
								if not availableThings[destThing] then
									availableThings[destThing] = true
									anotherRound = true
									anotherRoundReason = "Import "..destThing.." from "..thing
								end
							end
						end
					end
				end
			end
		end

		if VERBOSE and anotherRound then
			log("Another round, last reason: "..anotherRoundReason)
		end

		if numRounds > 30 then
			error("Possibly-infinite loop in extendToClosure, availableThings: "..serpent.line(availableThings))
			anotherRound = false
		end
	end
end

-- Function that makes mappings from tech to the set of EVERYTHING available right before and right after that tech.
---@param toposortedTechs string[]
---@param thingToRecipes table<string, data.RecipePrototype[]>
---@param recipeToPlanets table<string, table<string, boolean>>
---@return table<string, table<string, boolean>>?, table<string, table<string, boolean>>?
local function getTechPrePostSets(toposortedTechs, thingToRecipes, recipeToPlanets)
	-- Tables from tech to stuff that's available before/after that tech is researched.
	-- Later, we can check that the stuff available before the tech contains all science packs required by the tech.
	-- Later, we can check that the stuff available after the tech contains all ingredients of the tech's unlocked recipes.
	local availableAfterTech = {}
	local availableBeforeTech = {}

	-- Look through all techs in toposorted order, figuring out what's available before and after that tech.
	for _, techName in pairs(toposortedTechs) do
		local tech = TECH[techName]
		local availableBeforeThisTech = {}
		local techPrereqs = tech.prerequisites or {}

		-- Before this tech, we have everything unlocked after all of its prereq techs, if any.
		if #techPrereqs == 0 then
			Table.setFields(availableBeforeThisTech, unlockedAtStart)
		else
			for _, prereqName in pairs(techPrereqs) do
				local availableAfterPrereq = availableAfterTech[prereqName]
				assert(availableAfterPrereq ~= nil, "Tech "..techName.." has prereq "..prereqName.." which has not been processed; this should never happen.")
				Table.setFields(availableBeforeThisTech, availableAfterPrereq)
			end
		end

		-- Form closure of everything now unlocked - e.g. if we unlocked a recipe, and its ingredients are unlocked, then its products should now also be unlocked.
		if #techPrereqs == 0 or #techPrereqs > 1 then -- Optimization: don't need to take closure if it was copied directly from another tech.
			if VERBOSE then log("Extending pre-tech set to closure for tech "..techName) end
			extendToClosure(availableBeforeThisTech, thingToRecipes, recipeToPlanets)
		end

		-- After this tech, we have everything from before the tech. Then we'll add new stuff from this tech's unlocks.
		local availableAfterThisTech = copy(availableBeforeThisTech)
		local anythingAddedToPostTech = false -- Optimization: don't extend to closure if nothing new was unlocked.

		-- Add newly-unlocked recipes.
		for _, effect in pairs(tech.effects or {}) do
			if effect.type == "unlock-recipe" then
				local recipe = RECIPE[effect.recipe]
				assert(recipe ~= nil, effect.recipe)
				availableAfterThisTech["recipe:"..recipe.name] = true
				anythingAddedToPostTech = true
			end
		end

		-- Add anything implicitly unlocked by this tech.
		if unlockedImplicitlyByTech[techName] ~= nil then
			for _, unlockedItem in pairs(unlockedImplicitlyByTech[techName]) do
				if VERBOSE then log("Unlocking from tech: "..serpent.line(unlockedItem)) end
				availableAfterThisTech[unlockedItem] = true
				anythingAddedToPostTech = true
			end
		end

		-- Form the closure of everything now unlocked - e.g. if we unlocked a recipe, and its ingredients are unlocked, then its products should now also be unlocked.
		if anythingAddedToPostTech then
			if VERBOSE then log("Extending post-tech set to closure for tech "..techName) end
			extendToClosure(availableAfterThisTech, thingToRecipes, recipeToPlanets)
		end

		availableBeforeTech[techName] = availableBeforeThisTech
		availableAfterTech[techName] = availableAfterThisTech
	end

	return availableBeforeTech, availableAfterTech
end

return getTechPrePostSets