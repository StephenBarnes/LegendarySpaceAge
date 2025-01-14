-- Change charged battery recycling recipes to just discharge the batteries.
if data.raw.recipe["charged-battery-recycling"] then
	data.raw.recipe["charged-battery-recycling"].results = {{type = "item", name = "battery", amount = 1}}
end
if data.raw.recipe["charged-holmium-battery-recycling"] then
	data.raw.recipe["charged-holmium-battery-recycling"].results = {{type = "item", name = "holmium-battery", amount = 1}}
end
