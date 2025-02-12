local Icon = {}

Icon.iconSize = function(proto)
	if proto.type == "technology" then
		return 256
	else
		return 64
	end
end

local dirCodeToPath = {
	LSA = "__LegendarySpaceAge__/graphics/",
	base = "__base__/graphics/",
	core = "__core__/graphics/",
	SA = "__space-age__/graphics/",
}

---@return string?
Icon.expandPath = function(pathCode, proto)
	local dirCode, rest = pathCode:match "^([^/]+)/(.+)" -- Split path by first '/' into 2 segments.
	if dirCode == nil then -- If no '/' found, then check items and fluids.
		rest = pathCode
	end

	if dirCode ~= nil and dirCodeToPath[dirCode] ~= nil then
		local path = dirCodeToPath[dirCode]
		if dirCode ~= "LSA" then
			if proto ~= nil and proto.type == "technology" then
				path = path .. "technology/"
			else
				path = path .. "icons/"
			end
		end
		return path .. rest .. ".png"
	else
		for _, t in pairs{"item", "fluid", "recipe", "capsule"} do
			if RAW[t][rest] ~= nil and (RAW[t][rest].icon ~= nil or RAW[t][rest].icons ~= nil) then
				if RAW[t][rest].icon ~= nil then
					---@diagnostic disable-next-line: return-type-mismatch
					return RAW[t][rest].icon
				else
					assert(#RAW[t][rest].icons == 1, "Multi-icon must have exactly 1 icon")
					---@diagnostic disable-next-line: return-type-mismatch
					return RAW[t][rest].icons[1].icon
				end
			end
		end
	end
	assert(false, "No icon found for " .. pathCode)
end

local multiIconVals = {
	[2] = {
		{scale = 0.46, shift = {5, 5}},
		{scale = 0.3, shift = {-5, -4}},
	},
}

local function getMultiIcon(iconInfo, proto)
	assert(#iconInfo > 1, "Multi-icon must have at least 2 icons")
	local newIcons = {}
	local size = Icon.iconSize(proto)
	local vals = multiIconVals[#iconInfo]
	assert(vals ~= nil, "No multi-icon values found for " .. #iconInfo .. " icons")
	for i, pathCode in ipairs(iconInfo) do
		local path = Icon.expandPath(pathCode, proto)
		local val = copy(vals[i])
		val.icon = path
		val.icon_size = size
		val.icon_mipmaps = 4
		newIcons[#newIcons + 1] = val
	end
	return newIcons
end

Icon.set = function(thing, iconInfo)
	---@type data.ItemPrototype | data.RecipePrototype | data.FluidPrototype | data.TechnologyPrototype
	local proto
	if type(thing) == "table" then
		proto = thing
	elseif type(thing) == "string" then
		proto = ITEM[thing] or RECIPE[thing] or FLUID[thing] or TECH[thing]
	end

	local newIcons = nil
	local newIcon = nil
	if type(iconInfo) == "string" then
		newIcon = Icon.expandPath(iconInfo, proto)
	else
		newIcons = getMultiIcon(iconInfo, proto)
	end

	proto.icons = newIcons
	proto.icon = newIcon
	if newIcon ~= nil then
		proto.icon_size = Icon.iconSize(proto)
		proto.icon_mipmaps = 4
		proto.scale = 0.5
	end
end

Icon.variants = function(proto, dirCode, count, additional)
	assert(count <= 16, "Cannot have more than 16 variants")
	local variants = {}
	local path = Icon.expandPath(dirCode, proto)
	assert(path ~= nil, "No path found for " .. dirCode)
	for i = 1, count do
		local variant = {
			filename = path:gsub("%%.png", i .. ".png"),
			size = 64,
			scale = 0.5,
			mipmap_count = 4,
		}
		if additional ~= nil then
			for _, val in pairs(additional) do
				table.insert(variant, val)
			end
		end
		variants[i] = variant
	end
	proto.pictures = variants
end

return Icon