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

Item.copySoundsTo = function(a, b)
	if type(a) == "string" then
		a = data.raw.item[a]
	end
	if type(b) == "string" then
		b = data.raw.item[b]
	end
	if a == nil then
		log("ERROR: Couldn't find item a to copy sounds from.")
		return
	end
	if b == nil then
		log("ERROR: Couldn't find item b to copy sounds to.")
		return
	end
	b.open_sound = a.open_sound
	b.close_sound = a.close_sound
	b.pick_sound = a.pick_sound
	b.drop_sound = a.drop_sound
	b.inventory_move_sound = a.inventory_move_sound
end

return Item