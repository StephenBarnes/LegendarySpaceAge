-- This file handles fuel values, emissions multipliers, and vehicle stats for all solid and fluid fuels in the game. Mostly petrochem stuff but also some other fuels.

local Table = require("code.util.table")
local Tech = require("code.util.tech")

--[[ Add fuel values, pollution multipliers, and vehicle stats. The fuel values were chosen so that the relative numbers are realistic, meaning things that are better for burning in the real world should have higher fuel value, so that the player is encouraged to use fuels that are realistic (e.g. "rich gas" / propane over crude oil).
]]
local fluidFuelValues = { -- Maps name to fuel value and emissions multiplier.
	["crude-oil"] = {"400kJ", 2},
	["heavy-oil"] = {"500kJ", 2.5},
	["light-oil"] = {"700kJ", 1.5},
	["petroleum-gas"] = {"900kJ", 0.9},
	["dry-gas"] = {"800kJ", 0.7},
	["natural-gas"] = {"800kJ", 1.2},
	["syngas"] = {"400kJ", 1.5},
	["tar"] = {"200kJ", 3},
	-- Not going to give hydrogen a fuel value, since we can't give fuel categories to fluid fuels, so I couldn't prevent it being used in a fluid-fuelled gasifier etc.
}
local itemFuelValues = { -- Maps item name to fuel value, emissions multiplier, vehicle speed mult, vehicle top-speed mult, category.
	["sulfur"] = {"4MJ", 8, 0.5, 0.5, "non-carbon"},
	["solid-fuel"] = {"12MJ", 2, 0.7, 0.7, "chemical"},
	["pitch"] = {"3MJ", 2.5, 0.5, 0.5, "chemical"},
	["resin"] = {"4MJ", 2, 0.5, 0.5, "chemical"},
	["rocket-fuel"] = {"20MJ", 0.8, 1.8, 1.15, "chemical"}, -- Each one is 25 light oil, 12 rich gas, so that suggests 30MJ. Vanilla is 100MJ.
	["carbon"] = {"2MJ", 0.8, 0.5, 0.5, "chemical"},
	["wood"] = {"2MJ", 1.2, 0.5, 0.5, "chemical"},
	["coal"] = {"4MJ", 1.4, 0.5, 0.5, "chemical"},
	-- TODO really we should do all the other fuels in the game, eg seeds, so they also have bad vehicle stats.
}
for fluidName, fuelValues in pairs(fluidFuelValues) do
	data.raw.fluid[fluidName].fuel_value = fuelValues[1]
	data.raw.fluid[fluidName].emissions_multiplier = fuelValues[2]
end
for itemName, fuelValues in pairs(itemFuelValues) do
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

-- Create fuel category for non-carbon fuels like sulfur, which can't be used in some places where carbon is needed (eg furnaces need carbon as reducing agent).
-- Mostly this is to prevent using sulfur to make syngas in a gasifier, since that would create carbon out of nothing, which breaks Vulcanus.
local nonCarbonFuelCategory = Table.copyAndEdit(data.raw["fuel-category"]["chemical"], {
	name = "non-carbon",
})
data:extend{nonCarbonFuelCategory}

-- Set fuel categories for some entities to allow sulfur as fuel.
for _, typeAndName in pairs{
	{"reactor", "heating-tower"},
	{"boiler", "boiler"},
	{"inserter", "burner-inserter"},
	{"car", "car"},
	{"car", "tank"},
	{"locomotive", "locomotive"},
	{"mining-drill", "burner-mining-drill"},
} do
	data.raw[typeAndName[1]][typeAndName[2]].energy_source.fuel_categories = {"chemical", "non-carbon"}
end

-- Delete nuclear fuel, I don't like it, doesn't make sense. Even considering vehicles can use coal etc as fuel, so they have a heat engine rather than an ICE, they still wouldn't be able to run off a barely-critical lump of U-235 without radiation shielding, control rods, etc. which is basically a miniature nuclear reactor. I'd rather add a tech for nuclear tanks/cars/trains that only accept uranium fuel cells and are crafted using personal nuclear reactors.
data.raw.item["nuclear-fuel"].hidden = true
data.raw.recipe["nuclear-fuel"].hidden = true
Tech.removeRecipeFromTech("nuclear-fuel", "kovarex-enrichment-process")