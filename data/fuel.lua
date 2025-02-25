-- This file handles fuel values, emissions multipliers, and vehicle stats for all solid and fluid fuels in the game. Mostly petrochem stuff but also some other fuels.
-- Fuel values for barrels and tanks are set in barrelling-dff.lua instead.

-- Set fuel values for fluids (for fluid-fuelled vehicles, gasifiers, heating towers, boilers)
for fluidName, fuelValues in pairs(Const.fluidFuelValues) do
	FLUID[fluidName].fuel_value = fuelValues[1]
	FLUID[fluidName].emissions_multiplier = fuelValues[2]
end
-- Set fuel values for items.
for itemName, fuelValues in pairs(Const.itemFuelValues) do
	local t = fuelValues[7]
	local item = RAW[t][itemName]
	item.fuel_value = fuelValues[1]
	item.fuel_emissions_multiplier = fuelValues[2]
	item.fuel_acceleration_multiplier = fuelValues[3]
	item.fuel_top_speed_multiplier = fuelValues[4]
	item.fuel_category = fuelValues[5]
	if fuelValues[6] then
		item.burnt_result = "ash"
	end
	if item.fuel_glow_color == nil then
		item.fuel_glow_color = ITEM["coal"].fuel_glow_color
	end
end
ITEM["sulfur"].fuel_glow_color = {r=.3, g=.3, b=1, a=.2} -- Sulfur burns blue in real life.

-- Create fuel category for non-carbon fuels like soldReplicationRecipeulfur, which can't be used in some places where carbon is needed (eg furnaces need carbon as reducing agent).
-- Mostly this is to prevent using sulfur to make syngas in a gasifier, since that would create carbon out of nothing, which breaks Vulcanus.
local nonCarbonFuelCategory = copy(RAW["fuel-category"]["chemical"])
nonCarbonFuelCategory.name = "non-carbon"
extend{nonCarbonFuelCategory}

-- Create fuel category for pure carbon. Because we want to allow char furnaces to use all carbon-based fuels except actual carbon.
local pureCarbonFuelCategory = copy(RAW["fuel-category"]["chemical"])
pureCarbonFuelCategory.name = "pure-carbon"
extend{pureCarbonFuelCategory}

-- Set fuel categories for some entities to allow non-carbon-based fuels (sulfur, hydrogen).
local expandedFuelCategories = {"chemical", "non-carbon"}
for _, typeAndName in pairs{
	{"reactor", "heating-tower"},
	{"boiler", "boiler"},
	{"inserter", "burner-inserter"},
	{"mining-drill", "burner-mining-drill"},
} do
	RAW[typeAndName[1]][typeAndName[2]].energy_source.fuel_categories = copy(expandedFuelCategories)
end
for _, typeAll in pairs{ -- Handle all cars (including tanks, boats) and locomotives (including big cargo ships)
	"car",
	"locomotive"
} do
	for ent in pairs(RAW[typeAll]) do
		if ent.burner then
			ent.burner.fuel_categories = copy(expandedFuelCategories)
		end
	end
end
RAW["generator-equipment"]["personal-burner-generator"].burner.fuel_categories = copy(expandedFuelCategories)

-- Since pentapod eggs and biter eggs and carbon are now in different fuel categories, but should count as carbon-based, we need to make them burnable in heating towers etc.
local otherCarbonicFuels = {"activated-pentapod-egg", "biter-egg", "pure-carbon"}
local function addOtherCarbonicFuelsToBurner(burner)
	if burner.fuel_categories ~= nil and Table.hasEntry("chemical", burner.fuel_categories) then
		for _, fuel in pairs(otherCarbonicFuels) do
			table.insert(burner.fuel_categories, fuel)
		end
	end
end
local function addOtherCarbonicFuelsToEnt(ent)
	if ent.energy_source ~= nil and ent.energy_source.type == "burner" then
		addOtherCarbonicFuelsToBurner(ent.energy_source)
	elseif ent.burner ~= nil then
		addOtherCarbonicFuelsToBurner(ent.burner)
	end
end
for kind, ents in pairs(data.raw) do
	if kind ~= "utility-constants" then
		for _, ent in pairs(ents) do
			addOtherCarbonicFuelsToEnt(ent)
		end
	end
end

-- But, char furnace should only accept carbonic fuels except pure carbon.
local charFurnace = ASSEMBLER["char-furnace"]
charFurnace.energy_source.fuel_categories = {"chemical"}
for _, fuel in pairs(otherCarbonicFuels) do
	if fuel ~= "pure-carbon" then
		table.insert(charFurnace.energy_source.fuel_categories, fuel)
	end
end

-- Delete nuclear fuel, I don't like it, doesn't make sense. Even considering vehicles can use coal etc as fuel, so they have a heat engine rather than an ICE, they still wouldn't be able to run off a barely-critical lump of U-235 without radiation shielding, control rods, etc. which is basically a miniature nuclear reactor. I'd rather add a tech for nuclear tanks/cars/trains that only accept uranium fuel cells and are crafted using personal nuclear reactors.
ITEM["nuclear-fuel"].hidden = true
RECIPE["nuclear-fuel"].hidden = true
Tech.removeRecipeFromTech("nuclear-fuel", "kovarex-enrichment-process")

-- Add spent fuel slots to everything.
for _, type in pairs{"car", "locomotive", "inserter", "furnace", "assembling-machine", "boiler", "reactor"} do
	for _, burner in pairs(RAW[type]) do
		if burner.energy_source and burner.energy_source.type == "burner" then
			if (burner.energy_source.fuel_inventory_size or 1) < 2 then
				burner.energy_source.fuel_inventory_size = 2
			end
			if (burner.energy_source.burnt_inventory_size or 0) < 2 then
				burner.energy_source.burnt_inventory_size = 2
			end
		end
	end
end

-- Boost stack sizes of some fuels.
ITEM["carbon"].stack_size = 100
ITEM["solid-fuel"].stack_size = 100
ITEM["rocket-fuel"].stack_size = 100