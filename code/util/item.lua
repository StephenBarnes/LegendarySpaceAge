local Item = {}

Item.multiplySpoilTime = function(itemName, multiplier)
	local item = data.raw.item[itemName]
	if item == nil then
		log("ERROR: Couldn't find item "..itemName.." to multiply spoil time of.")
		return
	end
	if item.spoil_ticks == nil then
		log("ERROR: Item "..itemName.." has no spoil time.")
		return
	end
	item.spoil_ticks = item.spoil_ticks * multiplier
end

Item.multiplyWeight = function(itemName, multiplier, typeName)
	typeName = typeName or "item"
	local item = data.raw[typeName][itemName]
	if item == nil then
		log("ERROR: Couldn't find item "..itemName.." to multiply weight of.")
		return
	end
	item.weight = item.weight * multiplier
end

return Item