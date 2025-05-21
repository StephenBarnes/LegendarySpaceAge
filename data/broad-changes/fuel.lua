--[[ This file handles fuel values, emissions multipliers, and vehicle stats for all solid and fluid fuels in the game. Mostly petrochem stuff but also some other fuels.
Fuel values for barrels and tanks are set in barrelling-dff.lua instead.
Heat shuttle "fuels" are handled in heat-shuttles.lua instead.

Previously I had sulfur as a non-carbon fuel, and had separate categories for carbon fuel, non-carbon fuel, and pure-carbon fuel (so it can't be used to fuel char furnaces).
	But, I removed all of that, rather just making sulfur not a fuel, so all fuels for furnaces etc are carbon-based, and removing char-furnace, moving recipe to regular furnaces.
]]

local Const = require "const.fuel-const"

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

-- Since pentapod eggs and biter eggs are now in different fuel categories, but should count as burnable (carbon-based) fuel, we need to make them burnable in heating towers etc.
local otherCarbonicFuels = {"activated-pentapod-egg", "biter-egg"}
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

-- Delete nuclear fuel, I don't like it, doesn't make sense. Even considering vehicles can use coal etc as fuel, so they have a heat engine rather than an ICE, they still wouldn't be able to run off a barely-critical lump of U-235 without radiation shielding, control rods, etc. which is basically a miniature nuclear reactor. I'd rather add a tech for nuclear tanks/cars/trains that only accept uranium fuel cells and are crafted using personal nuclear reactors.
ITEM["nuclear-fuel"].hidden = true
RECIPE["nuclear-fuel"].hidden = true
Tech.removeRecipeFromTech("nuclear-fuel", "kovarex-enrichment-process")

-- Add spent fuel slots to everything.
for _, type in pairs{"car", "locomotive", "inserter", "furnace", "assembling-machine", "boiler", "reactor", "mining-drill"} do
	for _, burner in pairs(RAW[type]) do
		local energySource = burner.energy_source
		if energySource and energySource.type == "burner" then
			if (energySource.fuel_inventory_size or 1) < 2 then
				energySource.fuel_inventory_size = 2
			end
			if (energySource.burnt_inventory_size or 0) < 2 then
				energySource.burnt_inventory_size = 2
			end
		end
	end
end

-- Boost stack sizes of some fuels.
ITEM["carbon"].stack_size = 200
ITEM["solid-fuel"].stack_size = 100
ITEM["rocket-fuel"].stack_size = 100