--[[ This file checks that recipes and machines have beacons and module effects enabled.
Generally we want beacons and all module effects to be allowed for basically everything, except a handful of special cases.
]]

local Util = require("data.autodebug.util")

-- Table of recipes that should have prod/quality disabled or modified. Maps from type to max prod (0 for disabled) and whether quality is enabled.
local expectedRecipes = {
	-- All priming and superclocking recipes have prod and quality disabled, since the result decays back into the ingredient quickly.
	["electronic-circuit-primed"] = {0, false},
	["electronic-circuit-superclocked"] = {0, false},
	["advanced-circuit-primed"] = {0, false},
	["advanced-circuit-superclocked"] = {0, false},
	["processing-unit-primed"] = {0, false},
	["processing-unit-superclocked"] = {0, false},
	["white-circuit-primed"] = {0, false},
	["white-circuit-superclocked"] = {0, false},

	["tungsten-heating"] = {0, false}, -- Just changes temperature, so no prod.
	["lava-water-heating"] = {0, false}, -- Water + lava -> stone + steam. No prod so water is conserved.

	["explosive-desynchronization"] = {0, false}, -- This turns 10 into 5 * 1.5 = 7.5, which could easily tip over to >10, so no prod bonuses. It's intended to use resynchronization to get more; allowing prod here would remove that challenge.
	["cyclosome-resynchronization"] = {3, true}, -- This should allow quality since it's the only way to make cyclosomes. Also allowing prod.

	-- Fertilized seeds decay back into normal seeds, so can't allow prod or quality.
	["fertilized-yumako-seed"] = {0, false},
	["fertilized-jellynut-seed"] = {0, false},

	-- Oil cracking shouldn't allow prod because it would allow you to amplify amount of oil at each step, then do syngas liquefaction for positive-sum loop.
	-- But allowing quality for the sulfur and carbon byproducts.
	["heavy-oil-cracking"] = {0, true},
	["light-oil-cracking"] = {0, true},
	["rich-gas-cracking"] = {0, false}, -- No solid byproducts, so no quality.

	-- You can't get crude or natgas back, so enabling prod doesn't cause problems. Also enabling quality for the sulfur and carbon byproducts.
	["oil-fractionation"] = {3, true},
	["gas-fractionation"] = {3, true},

	["pentapod-egg"] = {3, true}, -- This is the recipe for turning activated eggs into multiple dormant ones. Allowing prod and quality.
	["activated-pentapod-egg"] = {3, true}, -- This is the recipe for activating dormant eggs with mash. Allowing prod and quality.

	-- Filtration recipes should allow prod and quality, since you can't get the input back.
	["filter-lake-water"] = {3, true},
	["filter-slime"] = {3, true},
	["filter-fulgoran-sludge"] = {3, true},

	["clean-filter"] = {0, false}, -- Clean filter can be easily turned into spent filter, so can't enable prod or quality.

	["coal-coking"] = {3, true}, -- Can't get coal back, so no issue enabling prod.
	["heavy-oil-coking"] = {1, true}, -- Max prod +100% for carbon conservation.
	["tar-distillation"] = {1, true}, -- Max prod +100% for carbon conservation.
	["pitch-processing"] = {0, true}, -- Ban prod to conserve carbon.
	["pitch-resin"] = {2, true}, -- Max prod +200% for carbon conservation.

	["syngas-liquefaction"] = {0, false}, -- Banning prod to conserve carbon.
	["syngas"] = {0, true}, -- Banning prod to conserve carbon.

	["make-diesel"] = {0, false}, -- Ban prod to conserve carbon and fuel-potential.
	["solid-fuel"] = {0, true}, -- Ban prod to conserve carbon.

	-- Water phase conversions should conserve total water.
	["ice-melting"] = {0, false},
	["steam-condensation"] = {0, false},

	["petrophage-cultivation"] = {0.5, true}, -- Cap prod to conserve carbon.
	["refresh-petrophages"] = {2, true}, -- Cap prod to conserve carbon.

	-- TODO more.
}

-- Table of machines that should have prod/quality/beacons disabled or modified.
local expectedMachines = {
	["assembling-machine"] = {
	},
	["furnace"] = {
		-- TODO gas vent and waste pump should block prod and quality.
	},
	["rocket-silo"] = {
	},
	["lab"] = {
	},
	["mining-drill"] = {
	},
}

---@param recipe data.RecipePrototype
---@return number, boolean, boolean
---Returns expected prod, expected quality, and success (can be false if recipe is configured wrong).
local function getRecipeExpected(recipe)
	if (recipe.category == "gas-venting" or recipe.category == "waste-pump") then
		return 0, false, true
	end

	local success = true
	local expectedVals = expectedRecipes[recipe.name]
	local expectedProd, expectedQuality
	if expectedVals == nil then
		expectedProd = 3
		expectedQuality = true
	else
		expectedProd = expectedVals[1]
		expectedQuality = expectedVals[2]
	end

	-- If it's a barrelling recipe, it should have prod and quality disabled.
	if Recipe.isBarrellingRecipe(recipe) then
		assert(expectedVals == nil, "Recipe "..recipe.name.." is a barrelling recipe, so should not have expected values.")
		expectedProd = 0
		expectedQuality = false
	end

	-- If recipe produces only fluids, quality should be disabled by default.
	if Recipe.hasOnlyFluidOutputs(recipe) then
		if expectedRecipes[recipe.name] == nil then -- If not specified, assume quality should be disabled.
			expectedQuality = false
		else
			if expectedQuality ~= false then
				log("Recipe "..recipe.name.." is specified to have quality enabled, but produces only fluids.")
				success = false
			end
			expectedQuality = false
		end
	end

	return expectedProd, expectedQuality, success
end

---@param recipe data.RecipePrototype
---@return number, boolean
---Returns a recipe's max prod and whether quality is enabled.
local function getRecipeActual(recipe)
	local recipeProd
	if (recipe.allow_productivity == false or recipe.allow_productivity == nil) then
		recipeProd = 0
	elseif recipe.maximum_productivity ~= nil then
		recipeProd = recipe.maximum_productivity
	else
		recipeProd = 3 -- This is default for recipes.
	end
	assert(recipeProd ~= nil)
	local recipeQuality = ((recipe.allow_quality == true) or (recipe.allow_quality == nil))
	return recipeProd, recipeQuality
end

---@param recipe data.RecipePrototype
---Check that recipe has correct prod and quality.
local function checkRecipe(recipe)
	if Util.shouldIgnoreRecipe(recipe) then return true end
	local expectedProd, expectedQuality, success = getRecipeExpected(recipe)
	local recipeProd, recipeQuality = getRecipeActual(recipe)
	if recipeProd ~= expectedProd then
		log("Recipe "..recipe.name.." has incorrect maximum productivity: "..recipeProd.." (expected "..expectedProd..")")
		success = false
	end
	if recipeQuality ~= expectedQuality then
		log("Recipe "..recipe.name.." has incorrect quality: "..tostring(recipeQuality).." (expected "..tostring(expectedQuality)..")")
		success = false
	end
	return success
end

local function checkMachine(machine)
	local success = true
	-- TODO check prod
	-- TODO check quality
	return success
end

local function checkModulesBeaconsEnabled()
	local success = true
	for _, recipe in pairs(RECIPE) do
		success = checkRecipe(recipe) and success
	end
	for _, kind in pairs{"assembling-machine", "furnace", "rocket-silo", "lab", "mining-drill"} do
		for _, proto in pairs(RAW[kind]) do
			success = checkMachine(proto) and success
		end
	end
	-- TODO check that all recipes with water/steam/ice in both input and output have prod disabled.
	return success
end

return checkModulesBeaconsEnabled


-- TODO also disable quality for some recipes, and check that. Eg battery charging.
-- TODO allow beacons and quality and prod for (almost) all machines, eg furnaces.