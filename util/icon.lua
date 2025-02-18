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

Icon.getIconInfo = function(pathCode, proto)
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
		return {path = path .. rest .. ".png"}
	else
		for _, t in pairs{"item", "fluid", "recipe", "capsule"} do
			if RAW[t][rest] ~= nil and (RAW[t][rest].icon ~= nil or RAW[t][rest].icons ~= nil) then
				if RAW[t][rest].icon ~= nil then
					---@diagnostic disable-next-line: return-type-mismatch
					return {path = RAW[t][rest].icon}
				else
					assert(#RAW[t][rest].icons == 1, "Multi-icon must have exactly 1 icon")
					local sourceIcon = RAW[t][rest].icons[1]
					---@diagnostic disable-next-line: return-type-mismatch
					return {path = sourceIcon.icon, tint = sourceIcon.tint}
				end
			end
		end
	end
	assert(false, "No icon found for " .. pathCode)
end

-- Table that specifies the layout of multi-icons, by arrangement and number of icons.
local multiIconVals = {
	default = { -- Default: 1st is product, 2nd is ingredient in top-left, 3rd is ingredient in top-right.
		[2] = {
			{scale = 0.46, shift = {5, 5}},
			{scale = 0.3, shift = {-5, -4}},
		},
		[3] = {
			{scale = 0.4, shift = {0, 4}},
			{scale = 0.25, shift = {-8, -8}},
			{scale = 0.25, shift = {8, -8}},
		},
		[4] = {
			{scale = 0.33, shift = {0, 4.5}},
			{scale = 0.18, shift = {-8, -3.5}},
			{scale = 0.18, shift = {8, -3.5}},
			{scale = 0.22, shift = {0, -6}},
		},
	},
	decomposition = { -- Used for recipes where one item is decomposed into multiple items, eg oil cracking. 1st is ingredient, other 2-3 are products. If only one product, repeat it.
		[3] = {
			{scale = 0.3, shift = {0, -4}},
			{scale = 0.2, shift = {-7, 4}},
			{scale = 0.2, shift = {7, 4}},
		},
		[4] = {
			{scale = 0.3, shift = {0, -4.5}},
			{scale = 0.18, shift = {-8, 3.5}},
			{scale = 0.18, shift = {8, 3.5}},
			{scale = 0.22, shift = {0, 6}},
		},
	},
	casting = { -- Used for foundry casting recipes. 1st is product, 2nd is casting-bucket icon.
		[2] = {
			{scale = 0.5, shift = {-4, 4}},
			{scale = 0.5, shift = {4, -4}},
		},
	},
}
local function getMultiIconBase(count, arrangement)
	if arrangement == nil then
		return multiIconVals.default[count]
	else
		assert(multiIconVals[arrangement] ~= nil, "Invalid arrangement: " .. arrangement)
		return multiIconVals[arrangement][count]
	end
end
local function getMultiIcon(iconInfo, proto, arrangement)
	assert(#iconInfo > 1, "Multi-icon must have at least 2 icons")
	local newIcons = {}
	local size = Icon.iconSize(proto)
	local vals = getMultiIconBase(#iconInfo, arrangement)
	assert(vals ~= nil, "No multi-icon values found for " .. #iconInfo .. " icons with arrangement " .. (arrangement or "nil"))
	for i, pathCode in ipairs(iconInfo) do
		local iconInfo = Icon.getIconInfo(pathCode, proto)
		local val = copy(vals[i])
		val.icon = iconInfo.path
		val.icon_size = size
		val.icon_mipmaps = 4
		val.tint = iconInfo.tint
		newIcons[#newIcons + 1] = val
	end
	return newIcons
end

Icon.set = function(thing, iconInfo, arrangement)
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
		assert(arrangement == nil, "Cannot specify arrangement for single icon")
		local iconInfo = Icon.getIconInfo(iconInfo, proto)
		newIcon = iconInfo.path
		assert(iconInfo.tint == nil, "Tint not supported for single icon; could add support by setting it as .icons rather than .icon.")
	else
		newIcons = getMultiIcon(iconInfo, proto, arrangement)
	end

	proto.icons = newIcons
	proto.icon = newIcon
	if newIcon ~= nil then
		proto.icon_size = Icon.iconSize(proto)
		proto.icon_mipmaps = 4
		proto.scale = 0.5
	end
end

---@param protoOrName data.ItemPrototype | data.RecipePrototype | data.FluidPrototype | data.TechnologyPrototype | string
---@param dirCode string
---@param count number
---@param additional table<string, any>?
Icon.variants = function(protoOrName, dirCode, count, additional)
	assert(count <= 16, "Cannot have more than 16 variants")
	local proto ---@type data.ItemPrototype | data.RecipePrototype | data.FluidPrototype | data.TechnologyPrototype
	if type(protoOrName) == "string" then
		proto = ITEM[protoOrName]
	else
		proto = protoOrName
	end

	local variants = {}
	local iconInfo = Icon.getIconInfo(dirCode, proto)
	assert(iconInfo.path ~= nil, "No path found for " .. dirCode)
	for i = 1, count do
		local variant = {
			filename = iconInfo.path:gsub("%%.png", i .. ".png"),
			size = 64,
			scale = 0.5,
			mipmap_count = 4,
			tint = iconInfo.tint,
		}
		variants[i] = variant
	end
	if additional ~= nil then
		for _, variant in pairs(variants) do
			for k, v in pairs(additional) do
				variant[k] = v
			end
		end
	end
	proto.pictures = variants
end

Icon.clear = function(proto)
	proto.icons = nil
	proto.icon = nil
end

return Icon