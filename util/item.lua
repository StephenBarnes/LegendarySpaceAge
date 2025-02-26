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

---@param func fun(item: data.ItemPrototype, itemType: string)
-- Function to run a loop through all items, including subtypes.
Item.forAllIncludingSubtypes = function(func)
	for itemType, _ in pairs(defines.prototypes.item) do
		if RAW[itemType] ~= nil then
			for _, item in pairs(RAW[itemType]) do
				---@type data.ItemPrototype
				---@diagnostic disable-next-line: assign-type-mismatch
				item = item
				if not item.parameter then
					func(item, itemType)
				end
			end
		end
	end
end

---@param itemName string
---@return data.ItemPrototype
Item.getIncludingSubtypes = function(itemName)
	if ITEM[itemName] ~= nil then
		return ITEM[itemName]
	end
	for itemType, _ in pairs(defines.prototypes.item) do
		if itemType ~= "item" and RAW[itemType] ~= nil then
			if RAW[itemType][itemName] ~= nil then
				---@diagnostic disable-next-line: return-type-mismatch
				return RAW[itemType][itemName]
			end
		end
	end
	error("Couldn't find item "..itemName.." including subtypes.")
end

---@param itemName string
---@return number
Item.getJoules = function(itemName, allowZero)
	local item = Item.getIncludingSubtypes(itemName)
	assert(item ~= nil, "Item "..itemName.." not found.")
	if not allowZero then
		assert(item.fuel_value ~= nil, "Item "..itemName.." has no fuel value.")
	else
		if item == nil or item.fuel_value == nil then
			return 0
		end
	end
	return Gen.toJoules(item.fuel_value)
end

---@param fluidName string
---@return number
Item.fluidGetJoules = function(fluidName, allowZero)
	local fluid = FLUID[fluidName]
	assert(fluid ~= nil, "Fluid "..fluidName.." not found.")
	if not allowZero then
		assert(fluid.fuel_value ~= nil, "Fluid "..fluidName.." has no fuel value.")
	else
		if fluid == nil or fluid.fuel_value == nil then
			return 0
		end
	end
	return Gen.toJoules(fluid.fuel_value)
end

return Item