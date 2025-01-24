-- This file will run automated checks. For example, checking that when the player unlocks a recipe, he has the ingredients available.

local Config = require("code.config")

local toposortTechs = require("code.data.autodebug.toposort-techs")
local getThingToRecipes = require("code.data.autodebug.get-thing-to-recipes")
local getRecipeToPlanets = require("code.data.autodebug.get-recipe-to-planets")
local getTechPrePostSets = require("code.data.autodebug.get-tech-pre-post-sets")

local checkAllRecipesHaveMachines = require("code.data.autodebug.check-recipes-have-machines")
local checkAllRecipesHaveIngredients = require("code.data.autodebug.check-recipes-have-ingredients")

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
	-- TODO check all science packs required by techs are available before those techs.
	-- TODO check that when a recipe is unlocked, at least one machine that can craft it has been unlocked.
	-- TODO add more checks here
	return success
end

if Config.runProgressionChecks then
	if runFullDebug() then
		log("Legendary Space Age: full progression debug passed.")
	else
		log("Legendary Space Age ERROR: one or more progression debug checks failed.")
	end
end

-- TODO maybe check that all recipes unlocked after advanced parts use advanced parts, not machine parts.