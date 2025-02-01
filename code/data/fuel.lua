-- This file handles fuel values, emissions multipliers, and vehicle stats for all solid and fluid fuels in the game. Mostly petrochem stuff but also some other fuels.
-- Fuel values for barrels and tanks are set in barrelling-dff.lua instead.

local Table = require("code.util.table")
local Tech = require("code.util.tech")

local Const = require("code.util.constants")

-- Set fuel values for fluids (for fluid-fuelled vehicles, gasifiers, heating towers, boilers)
for fluidName, fuelValues in pairs(Const.fluidFuelValues) do
	data.raw.fluid[fluidName].fuel_value = fuelValues[1]
	data.raw.fluid[fluidName].emissions_multiplier = fuelValues[2]
end
for itemName, fuelValues in pairs(Const.itemFuelValues) do
	data.raw.item[itemName].fuel_value = fuelValues[1]
	data.raw.item[itemName].fuel_emissions_multiplier = fuelValues[2]
	data.raw.item[itemName].fuel_acceleration_multiplier = fuelValues[3]
	data.raw.item[itemName].fuel_top_speed_multiplier = fuelValues[4]
	data.raw.item[itemName].fuel_category = fuelValues[5]
	if data.raw.item[itemName].fuel_glow_color == nil then
		data.raw.item[itemName].fuel_glow_color = data.raw.item["coal"].fuel_glow_color
	end
end
data.raw.item["sulfur"].fuel_glow_color = {r=.3, g=.3, b=1, a=.2} -- Sulfur burns blue in real life.

-- Create fuel category for non-carbon fuels like soldReplicationRecipeulfur, which can't be used in some places where carbon is needed (eg furnaces need carbon as reducing agent).
-- Mostly this is to prevent using sulfur to make syngas in a gasifier, since that would create carbon out of nothing, which breaks Vulcanus.
local nonCarbonFuelCategory = table.deepcopy(data.raw["fuel-category"]["chemical"])
nonCarbonFuelCategory.name = "non-carbon"
data:extend{nonCarbonFuelCategory}

-- Set fuel categories for some entities to allow non-carbon-based fuels (sulfur, hydrogen).
local expandedFuelCategories = {"chemical", "non-carbon"}
for _, typeAndName in pairs{
	{"reactor", "heating-tower"},
	{"boiler", "boiler"},
	{"inserter", "burner-inserter"},
	{"mining-drill", "burner-mining-drill"},
} do
	data.raw[typeAndName[1]][typeAndName[2]].energy_source.fuel_categories = table.deepcopy(expandedFuelCategories)
end
for _, typeAll in pairs{ -- Handle all cars (including tanks, boats) and locomotives (including big cargo ships)
	"car",
	"locomotive"
} do
	for ent in pairs(data.raw[typeAll]) do
		if ent.burner then
			ent.burner.fuel_categories = table.deepcopy(expandedFuelCategories)
		end
	end
end
data.raw["generator-equipment"]["personal-burner-generator"].burner.fuel_categories = table.deepcopy(expandedFuelCategories)

-- Since pentapod eggs and biter eggs are now in a different fuel category, but should count as carbon-based, we need to make them burnable in heating towers etc.
local function addEggFuelsToBurner(burner)
	if burner.fuel_categories ~= nil and Table.hasEntry("chemical", burner.fuel_categories) then
		table.insert(burner.fuel_categories, "activated-pentapod-egg")
		table.insert(burner.fuel_categories, "biter-egg")
	end
end
local function addEggFuelsToEnt(ent)
	if ent.energy_source ~= nil and ent.energy_source.type == "burner" then
		addEggFuelsToBurner(ent.energy_source)
	elseif ent.burner ~= nil then
		addEggFuelsToBurner(ent.burner)
	end
end
for _, ents in pairs(data.raw) do
	for _, ent in pairs(ents) do
		addEggFuelsToEnt(ent)
	end
end

-- Delete nuclear fuel, I don't like it, doesn't make sense. Even considering vehicles can use coal etc as fuel, so they have a heat engine rather than an ICE, they still wouldn't be able to run off a barely-critical lump of U-235 without radiation shielding, control rods, etc. which is basically a miniature nuclear reactor. I'd rather add a tech for nuclear tanks/cars/trains that only accept uranium fuel cells and are crafted using personal nuclear reactors.
data.raw.item["nuclear-fuel"].hidden = true
data.raw.recipe["nuclear-fuel"].hidden = true
Tech.removeRecipeFromTech("nuclear-fuel", "kovarex-enrichment-process")

-- Add spent fuel slots to everything.
for _, type in pairs{"car", "locomotive", "inserter", "furnace", "assembling-machine", "boiler", "reactor"} do
	for _, burner in pairs(data.raw[type]) do
		if burner.energy_source and burner.energy_source.type == "burner" then
			if burner.energy_source.fuel_inventory_size < 2 then
				burner.energy_source.fuel_inventory_size = 2
			end
			if (burner.energy_source.burnt_inventory_size or 0) < 2 then
				burner.energy_source.burnt_inventory_size = 2
			end
		end
	end
end