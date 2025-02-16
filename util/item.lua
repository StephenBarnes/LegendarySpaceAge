local Item = {}

Item.multiplySpoilTime = function(itemName, multiplier)
	local item = ITEM[itemName]
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
	local item = RAW[typeName][itemName]
	if item == nil then
		log("ERROR: Couldn't find item "..itemName.." to multiply weight of.")
		return
	end
	item.weight = item.weight * multiplier
end

Item.copySoundsTo = function(a, b)
	if type(a) == "string" then
		a = ITEM[a]
	end
	if type(b) == "string" then
		b = ITEM[b]
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

Item.clearFuel = function(item)
	item.fuel_value = nil
	item.fuel_acceleration_multiplier = nil
	item.fuel_emissions_multiplier = nil
	item.fuel_category = nil
	item.fuel_top_speed_multiplier = nil
	item.fuel_emissions_multiplier = nil
	item.fuel_glow_color = nil
end

Item.hide = function(itemName)
	local item = ITEM[itemName]
	if item == nil then
		log("ERROR: Couldn't find item "..itemName.." to hide.")
		return
	end
	item.hidden = true
	item.hidden_in_factoriopedia = true
end

-- Check whether an item exists, checking all item subtypes.
Item.exists = function(itemName)
	for itemType, _ in pairs(defines.prototypes.item) do
		if RAW[itemType] ~= nil and RAW[itemType][itemName] ~= nil then
			return true
		end
	end
	return false
end

return Item