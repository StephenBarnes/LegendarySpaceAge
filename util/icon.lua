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

---@param pathCode string | table
---@param proto data.ItemPrototype | data.RecipePrototype | data.FluidPrototype | data.TechnologyPrototype
---@return {path: string, tint: table?}[]
Icon.getIconsInfo = function(pathCode, proto)
	local tint = nil
	if type(pathCode) == "table" then
		tint = pathCode.tint
		pathCode = pathCode[1]
	end

	local dirCode, rest = pathCode:match "^([^/]+)/(.+)" -- Split path by first '/' into 2 segments.
	if dirCode == nil then -- If no '/' found, then check items and fluids.
		rest = pathCode
	end

	if dirCode == "planet" then
		if rest == "apollo" then return {path = "__LegendarySpaceAge__/graphics/apollo/icon.png"} end
		local planetIcon = RAW.planet[rest].icon
		assert(planetIcon ~= nil, "No icon found for planet "..rest)
		return {{path = planetIcon}}
	elseif dirCode ~= nil and dirCodeToPath[dirCode] ~= nil then
		local path = dirCodeToPath[dirCode]
		if dirCode ~= "LSA" then
			if proto ~= nil and proto.type == "technology" then
				path = path .. "technology/"
			else
				path = path .. "icons/"
			end
		end
		return {{path = path .. rest .. ".png", tint = tint}}
	else
		for _, t in pairs{"item", "fluid", "recipe", "capsule", "resource"} do
			if RAW[t][rest] ~= nil and (RAW[t][rest].icon ~= nil or RAW[t][rest].icons ~= nil) then
				if RAW[t][rest].icon ~= nil then
					---@diagnostic disable-next-line: return-type-mismatch
					return {{path = RAW[t][rest].icon, tint = tint}}
				else
					if #RAW[t][rest].icons ~= 1 then
						log("Warning: Multi-icon must have exactly 1 icon, but " .. #RAW[t][rest].icons .. " found for " .. serpent.block(RAW[t][rest]) .. " (" .. t .. " " .. rest .. ")")
					end
					local icons = {}
					for _, icon in ipairs(RAW[t][rest].icons) do
						table.insert(icons, {path = icon.icon, tint = tint or icon.tint})
					end
					return icons
				end
			end
		end
	end
	---@diagnostic disable-next-line: missing-return
	assert(false, "No icon found for " .. pathCode)
end

-- Table that specifies the layout of multi-icons, by arrangement and number of icons.
local multiIconVals = {
	default = { -- Default: 1st is product, 2nd is ingredient in top-left, 3rd is ingredient in top-right.
		[1] = {
			{scale = 0.5, shift = {0, 0}},
		},
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
	casting = { -- Used for foundry casting recipes. 1st is product, 2nd is casting-bucket icon, 3rd is optional second casting-bucket icon in front of the 2nd one.
		[2] = {
			{scale = 0.5, shift = {-4, 4}},
			{scale = 0.5, shift = {4, -4}},
		},
		[3] = {
			{scale = 0.5, shift = {-4, 4}},
			{scale = 0.3, shift = {6, -6}},
			{scale = 0.33, shift = {-3, -4}},
		},
	},
	planetFixed = {
		[2] = {
			{scale = 0.37, shift = {3, 3}},
			{scale = 0.2, shift={-8,-8}},
		},
	},
	heat = {
		[2] = {
			{scale = 0.5, shift = {0, 0}},
			{scale = 0.5, shift = {0, 0}},
		},
	},
	overlay = {
		[2] = {
			{scale = 0.5, shift = {0, 0}},
			{scale = 0.5, shift = {0, 0}},
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
	-- Note we can have a "multi-icon" with only 1 icon, eg because we want to tint it.
	local newIcons = {}
	local size = Icon.iconSize(proto)
	local vals = getMultiIconBase(#iconInfo, arrangement)
	assert(vals ~= nil, "No multi-icon values found for " .. #iconInfo .. " icons with arrangement " .. (arrangement or "nil"))
	for i, pathCode in ipairs(iconInfo) do
		local thisIconsInfo = Icon.getIconsInfo(pathCode, proto)
		for _, thisIconInfo in ipairs(thisIconsInfo) do
			local val = copy(vals[i])
			val.icon = thisIconInfo.path
			val.icon_size = size
			val.icon_mipmaps = 4
			val.tint = thisIconInfo.tint
			table.insert(newIcons, val)
		end
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
	if type(iconInfo) == "string" then
		assert(arrangement == nil, "Cannot specify arrangement for single icon")
		local thisIconsInfo = Icon.getIconsInfo(iconInfo, proto)
		newIcons = {}
		for _, thisIconInfo in ipairs(thisIconsInfo) do
			table.insert(newIcons, {path = thisIconInfo.path, tint = thisIconInfo.tint})
		end
	else
		newIcons = getMultiIcon(iconInfo, proto, arrangement)
	end

	if #newIcons == 1 and newIcons[1].tint == nil then
		proto.icons = nil
		proto.icon = newIcons[1].path or newIcons[1].icon
		proto.icon_size = Icon.iconSize(proto)
		proto.icon_mipmaps = 4
		proto.scale = 0.5
	else
		proto.icons = newIcons
		proto.icon = nil
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
	local iconsInfo = Icon.getIconsInfo(dirCode, proto)
	if #iconsInfo ~= 1 then
		log("Icon.variants expects 1 icon, but " .. #iconsInfo .. " found for " .. dirCode)
	end
	local iconInfo = iconsInfo[1]
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