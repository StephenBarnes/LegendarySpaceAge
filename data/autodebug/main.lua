-- This file will run automated checks. For example, checking that when the player unlocks a recipe, he has the ingredients available.

-- This controls whether to actually run the full debug. Takes like 30 seconds to run, mostly because of getTechPrePostSets().
local RUN_FULL_DEBUG = false

-- This controls whether to run shorter debugs that don't need tech pre/post sets.
local RUN_QUICK_DEBUG = true


local toposortTechs = require("toposort-techs")
local getThingToRecipes = require("get-thing-to-recipes")
local getRecipeToPlanets = require("get-recipe-to-planets")
local getTechPrePostSets = require("get-tech-pre-post-sets")

local checkAllRecipesHaveMachines = require("check-recipes-have-machines")
local checkAllRecipesHaveIngredients = require("check-recipes-have-ingredients")
local checkRoundNumbers = require("check-round-numbers")
local checkRecipesObtainable = require("check-recipes-obtainable")
local checkModulesBeaconsEnabled = require("check-modules-beacons-enabled")

local function runFullDebug()
	log("Legendary Space Age: running full progression debug.")

	-- List with all techs' names, sorted so that all dependencies only go forwards.
	local toposortedTechs = toposortTechs()
	if toposortedTechs == nil then
		log("Legendary Space Age ERROR: toposorting techs failed.")
		return false
	end
	-- Table from item/fluid to recipes that use it as ingredient.
	local thingToRecipes = getThingToRecipes()
	-- Mapping of recipe to each planet it can be performed on.
	local recipeToPlanets = getRecipeToPlanets()

	-- Tables to hold mapping from tech name to items/fluids available right before and right after that tech.
	local preTechSets, postTechSets = getTechPrePostSets(toposortedTechs, thingToRecipes, recipeToPlanets)
	if preTechSets == nil or postTechSets == nil then
		log("Legendary Space Age ERROR: getting pre/post tech sets failed.")
		return false
	end

	--log("Available after space-science-pack:" .. serpent.block(postTechSets["space-science-pack"]))
	-- TODO sanity-checks.

	local success = true
	success = checkAllRecipesHaveMachines() and success
	success = checkAllRecipesHaveIngredients(toposortedTechs, postTechSets) and success
	success = checkRoundNumbers() and success
	success = checkRecipesObtainable() and success
	success = checkModulesBeaconsEnabled() and success
	-- TODO check all science packs required by techs are available before those techs.
	-- TODO check that when a recipe is unlocked, at least one machine that can craft it has been unlocked.
	-- TODO check that there are no items and fluids with the same name.
	-- TODO check that all non-hidden enabled techs have all prerequisites non-hidden and enabled.
	-- TODO check that there are no items or fluids (or item subtypes) that have no recipes producing them. Except for things only mined, etc.
	-- TODO check that recipes in techs after the nth circuit use the most advanced circuit. Eg should use white circuits for centrifuges, not red circuits.
	-- TODO add more checks here
	return success
end

local function runQuickDebug()
	log("Legendary Space Age: running quick debug.")

	local success = true
	success = checkAllRecipesHaveMachines() and success
	success = checkRoundNumbers() and success
	success = checkRecipesObtainable() and success
	success = checkModulesBeaconsEnabled() and success
	-- TODO check all science packs required by techs are available before those techs.
	-- TODO check that when a recipe is unlocked, at least one machine that can craft it has been unlocked.
	-- TODO check that there are no items and fluids with the same name.
	-- TODO check that all non-hidden enabled techs have all prerequisites non-hidden and enabled.
	-- TODO check that there are no items or fluids (or item subtypes) that have no recipes producing them. Except for things only mined, etc.
	-- TODO check that recipes in techs after the nth circuit use the most advanced circuit. Eg should use white circuits for centrifuges, not red circuits.
	-- TODO add more checks here
	return success
end

if RUN_FULL_DEBUG then
	if runFullDebug() then
		log("Legendary Space Age: full progression debug passed.")
	else
		log("Legendary Space Age ERROR: one or more progression debug checks failed.")
	end
elseif RUN_QUICK_DEBUG then
	if runQuickDebug() then
		log("Legendary Space Age: quick progression debug passed.")
	else
		log("Legendary Space Age ERROR: one or more quick progression debug checks failed.")
	end
end