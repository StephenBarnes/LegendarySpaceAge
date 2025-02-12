-- Change charged battery recycling recipes to just discharge the batteries.
if RECIPE["charged-battery-recycling"] then
	RECIPE["charged-battery-recycling"].results = {{type = "item", name = "battery", amount = 1}}
end
if RECIPE["charged-holmium-battery-recycling"] then
	RECIPE["charged-holmium-battery-recycling"].results = {{type = "item", name = "holmium-battery", amount = 1}}
end
