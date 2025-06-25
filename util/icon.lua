local Icon = {}

Icon.iconSize = function(proto)
	if proto.type == "technology" then
		return 256
	else
		return 64
	end
end

-- Table of allowed prefixes for path codes.
local dirCodeToPath = {
	LSA = "__LegendarySpaceAge__/graphics/",
	base = "__base__/graphics/",
	core = "__core__/graphics/",
	SA = "__space-age__/graphics/",
	SE = "__space-exploration-graphics__/graphics/",
	SE2 = "__space-exploration-graphics-2__/graphics/",
	SE3 = "__space-exploration-graphics-3__/graphics/",
	SE4 = "__space-exploration-graphics-4__/graphics/",
	SE5 = "__space-exploration-graphics-5__/graphics/",
}

-- Table of special path codes.
local specialPathCodes = {
	exo = "__LegendarySpaceAge__/graphics/heat-shuttles/exo.png",
	endo = "__LegendarySpaceAge__/graphics/heat-shuttles/endo.png",
	crush = "__LegendarySpaceAge__/graphics/crushers/recipe-overlay.png",
	blank = "__LegendarySpaceAge__/graphics/misc/almost-blank.png",
		-- It's an image with very faint color, used to create recipe shadows. (Otherwise the shadow only gets created over the first icon in .icons.)
}

---@param pathCode string | table
---@param proto data.ItemPrototype | data.RecipePrototype | data.FluidPrototype | data.TechnologyPrototype
---@return {path: string, tint: table?, scale: number?, shift?: {[1]: number, [2]: number}, draw_background?: boolean}[]
Icon.getIconsInfo = function(pathCode, proto)
	local tint, scale, shift = nil, 1, {0, 0}
	if type(pathCode) == "table" then
		tint = pathCode.tint
		scale = pathCode.scale or 1
		shift = pathCode.shift or {0, 0}
		draw_background = pathCode.draw_background or nil
		pathCode = pathCode[1]
	end

	if specialPathCodes[pathCode] ~= nil then
		return {{path = specialPathCodes[pathCode], tint = tint, scale = scale, shift = shift, draw_background = draw_background}}
	end

	local dirCode, rest = pathCode:match "^([^/]+)/(.+)" -- Split path by first '/' into 2 segments.
	if dirCode == nil then -- If no '/' found, then check items and fluids.
		rest = pathCode
	end

	if dirCode == "planet" then
		if rest == "apollo" then return {path = "__LegendarySpaceAge__/graphics/apollo/icon.png"} end
		local planetIcon = RAW.planet[rest].icon
		assert(planetIcon ~= nil, "No icon found for planet "..rest)
		return {{path = planetIcon, scale = scale, shift = shift, tint = tint, draw_background = draw_background}}
	elseif dirCode ~= nil and dirCodeToPath[dirCode] ~= nil then
		local path = dirCodeToPath[dirCode]
		if dirCode ~= "LSA" then
			if proto ~= nil and proto.type == "technology" then
				path = path .. "technology/"
			else
				path = path .. "icons/"
			end
		end
		return {{path = path .. rest .. ".png", tint = tint, scale = scale, shift = shift, draw_background = draw_background}}
	else
		for _, t in pairs{"item", "fluid", "recipe", "capsule", "resource"} do
			local raw = RAW[t][rest]
			if raw ~= nil and (raw.icon ~= nil or raw.icons ~= nil) then
				if raw.icon ~= nil then
					---@diagnostic disable-next-line: return-type-mismatch
					return {{path = raw.icon, tint = tint, scale = scale, shift = shift, draw_background = draw_background}}
				else
					local icons = {}
					for _, icon in ipairs(raw.icons) do
						local thisScale = scale * (icon.scale or 0.5) * 2 -- Multiply by 2 because most icons are scale 0.5.
						table.insert(icons, {path = icon.icon, tint = tint or icon.tint, scale = thisScale, shift = shift or icon.shift, draw_background = draw_background})
					end
					return icons
				end
			end
		end
	end
	---@diagnostic disable-next-line: missing-return
	assert(false, "No icon found for " .. pathCode)
end

-- Table that specifies the layout of multi-icons, by arrangement code and number of icons. Also specifies additional icon layers that should be added, e.g. to get the recipe shadow right.
---@type table<string, table<number, string|{scale: number, shift: {[1]: number, [2]: number}, draw_background?: boolean, extraPrefix?: string[]|{[1]: string, scale: number, shift: {[1]: number, [2]: number}}[], extraSuffix?: string[]|{[1]: string, scale: number, shift: {[1]: number, [2]: number}}[]}>>
local multiIconVals = {
	default = { -- Default: 1st is product, 2nd is ingredient in top-left, 3rd is ingredient in top-right.
		[1] = {
			{scale = 0.5, shift = {0, 0}},
		},
		[2] = {
			extraPrefix = {"blank"},
			{scale = 0.46, shift = {3, 3}, draw_background = true},
			{scale = 0.3, shift = {-7, -6}},
		},
		[3] = {
			extraPrefix = {"blank"},
			{scale = 0.4, shift = {0, 6}, draw_background = true},
			{scale = 0.25, shift = {-8, -6}},
			{scale = 0.25, shift = {8, -6}},
		},
		[4] = {
			extraPrefix = {"blank"},
			{scale = 0.33, shift = {0, 4.5}, draw_background = true},
			{scale = 0.18, shift = {-8, -3.5}},
			{scale = 0.18, shift = {8, -3.5}},
			{scale = 0.22, shift = {0, -6}},
		},
	},
	decomposition = { -- Used for recipes where one item is decomposed into multiple items, eg oil cracking. 1st is ingredient, other 2-3 are products. If only one product, repeat it.
		[3] = {
			extraPrefix = {"blank"},
			{scale = 0.3, shift = {0, -3}, draw_background = true},
			{scale = 0.2, shift = {-7, 5.5}},
			{scale = 0.2, shift = {7, 5.5}},
		},
		[4] = {
			extraPrefix = {"blank"},
			{scale = 0.3, shift = {0, -4.5}, draw_background = true},
			{scale = 0.18, shift = {-8, 3.5}},
			{scale = 0.18, shift = {8, 3.5}},
			{scale = 0.22, shift = {0, 6}},
		},
	},
	casting = { -- Used for foundry casting recipes. 1st is product, 2nd is casting-bucket icon, 3rd is optional second casting-bucket icon in front of the 2nd one.
		[2] = {
			extraPrefix = {"blank"},
			{scale = 0.5, shift = {-4, 4}, draw_background = true},
			{scale = 0.5, shift = {4, -4}},
		},
		[3] = {
			extraPrefix = {"blank"},
			{scale = 0.5, shift = {-4, 4}, draw_background = true},
			{scale = 0.3, shift = {6, -6}},
			{scale = 0.33, shift = {-3, -4}},
		},
	},
	planetFixed = { -- For recipes that are fixed per-planet, eg air collecting and general borehole mining.
		[2] = {
			extraPrefix = {"blank"},
			{scale = 0.37, shift = {3, 3}, draw_background = true},
			{scale = 0.2, shift={-8,-8}},
		},
	},
	overlay = { -- Just overlays all icons.
		[2] = {
			{scale = 0.5, shift = {0, 0}},
			{scale = 0.5, shift = {0, 0}},
		},
		[3] = {
			{scale = 0.5, shift = {0, 0}},
			{scale = 0.5, shift = {0, 0}},
			{scale = 0.5, shift = {0, 0}},
		},
		[4] = {
			{scale = 0.5, shift = {0, 0}},
			{scale = 0.5, shift = {0, 0}},
			{scale = 0.5, shift = {0, 0}},
			{scale = 0.5, shift = {0, 0}},
		},
	},
	exo = { -- Recipes with exo backdrop.
		[2] = {
			extraPrefix = {"exo"},
			{scale = 0.3, shift = {-5, -4}},
			{scale = 0.46, shift = {5, 5}},
		},
		[3] = {
			extraPrefix = {"exo"},
			{scale = 0.25, shift = {-8, -8}},
			{scale = 0.25, shift = {8, -8}},
			{scale = 0.4, shift = {0, 4}},
		},
		[4] = {
			extraPrefix = {"exo"},
			{scale = 0.22, shift = {-7, -7}},
			{scale = 0.20, shift = {7, -7}},
			{scale = 0.20, shift = {-7, 7}},
			{scale = 0.22, shift = {7, 7}},
		},
	},
	exoDoubleProduct = { -- Recipes with exo/endo backdrop, and 2 products.
		[3] = {
			extraPrefix = {"exo"},
			{scale = 0.4, shift = {0, -4}},
			{scale = 0.25, shift = {-8, 8}},
			{scale = 0.25, shift = {8, 8}},
		},
	},
	crossNeutralization = { -- Recipes for acid-base neutralization - exo backdrop plus 2 ingredients (acid and base).
		[2] = {
			extraPrefix = {"exo"},
			{scale = 0.4, shift = {-9, 0}},
			{scale = 0.4, shift = {9, 0}},
		},
	},
	crushing = { -- Recipes for crushing - last icon is crusher overlay, other icons are as in default.
		[1] = {
			{scale = 0.36, shift = {0, -7}, draw_background = true},
			extraSuffix = {{"crush", scale = 0.8, shift = {0, -4}}},
		},
		[2] = { -- Line downward, with product at bottom, ingredient at top, and crusher overlay in the middle.
			extraPrefix = {"blank"}, -- Black background to create shadow.
			{scale = 0.3, shift = {0, 7}, draw_background = true}, -- Product, at the bottom.
			{scale = 0.3, shift = {0, -8}, draw_background = true}, -- Ingredient, at the top.
			extraSuffix = {{"crush", scale = 0.8, shift = {0, -6.5}}}, -- Crush wheels overlay on top.
		},
	},
}
-- Create "endo" arrangement, same as exo but with endo backdrop.
multiIconVals.endo = copy(multiIconVals.exo)
for _, val in pairs(multiIconVals.endo) do
	val.extraPrefix = {"endo"}
end


local function getMultiIconBase(count, arrangement)
	if arrangement == nil then
		return multiIconVals.default[count]
	else
		assert(multiIconVals[arrangement] ~= nil, "Invalid arrangement: " .. arrangement)
		return multiIconVals[arrangement][count]
	end
end
---@param thisVals {scale: number, shift: {[1]: number, [2]: number}, draw_background?: boolean, icon?: string, icon_size?: number, icon_mipmaps?: number, tint?: table?}
local function addToMultiIcon(thisVals, pathCode, newIcons, proto, size)
	local thisIconsInfo = Icon.getIconsInfo(pathCode, proto)
	for _, thisIconInfo in ipairs(thisIconsInfo) do
		local val = copy(thisVals)
		val.icon = thisIconInfo.path
		val.icon_size = size
		val.icon_mipmaps = 4
		val.tint = thisIconInfo.tint
		if thisIconInfo.scale ~= nil then
			val.scale = val.scale * thisIconInfo.scale
		end
		if thisIconInfo.shift ~= nil then
			val.shift = {val.shift[1] + thisIconInfo.shift[1], val.shift[2] + thisIconInfo.shift[2]}
		end
		if thisIconInfo.draw_background ~= nil then
			val.draw_background = thisIconInfo.draw_background
		end
		table.insert(newIcons, val)
	end
end
local function getMultiIcon(iconInfo, proto, arrangement)
	-- Note we can have a "multi-icon" with only 1 icon, eg because we want to tint it.
	local newIcons = {}
	local size = Icon.iconSize(proto)
	local vals = getMultiIconBase(#iconInfo, arrangement)
	assert(vals ~= nil, "No multi-icon values found for " .. #iconInfo .. " icons with arrangement " .. (arrangement or "nil"))
	if vals.extraPrefix ~= nil then
		for _, pathCode in ipairs(vals.extraPrefix) do
			addToMultiIcon({scale = 0.5, shift = {0, 0}}, pathCode, newIcons, proto, size)
		end
	end
	for i, pathCode in ipairs(iconInfo) do
		if type(i) == "number" then -- Ignore special fields like "extraPrefix".
			addToMultiIcon(vals[i], pathCode, newIcons, proto, size)
		end
	end
	if vals.extraSuffix ~= nil then
		for _, pathCode in ipairs(vals.extraSuffix) do
			addToMultiIcon({scale = 0.5, shift = {0, 0}}, pathCode, newIcons, proto, size)
		end
	end
	return newIcons
end

---@param arrangement string?
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
		if iconInfo.tint ~= nil then iconInfo = {iconInfo} end
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

------------------------------------------------------------------------
--- Barrelling stuff copied from vanilla __base__'s data-updates.lua, and modified.

local barrel_side_alpha = 0.75
local barrel_top_hoop_alpha = 0.75
local fluid_icon_shift_barrelling = {-8, -8}
local fluid_icon_shift_emptying = {7, 8}

-- Item icon masks
local empty_barrel_icon = ITEM.barrel.icon
local barrel_side_mask = "__base__/graphics/icons/fluid/barreling/barrel-side-mask.png"
local barrel_hoop_top_mask = "__base__/graphics/icons/fluid/barreling/barrel-hoop-top-mask.png"
local barrel_side_mask_bottom = "__LegendarySpaceAge__/graphics/barreling/barrel-side-mask-bottom.png"
local barrel_side_mask_top = "__LegendarySpaceAge__/graphics/barreling/barrel-side-mask-top.png"

-- Recipe icon masks
local barrel_fill_icon = "__base__/graphics/icons/fluid/barreling/barrel-fill.png"
local barrel_fill_side_mask = "__base__/graphics/icons/fluid/barreling/barrel-fill-side-mask.png"
local barrel_fill_top_mask = "__base__/graphics/icons/fluid/barreling/barrel-fill-top-mask.png"
local barrel_empty_icon = "__base__/graphics/icons/fluid/barreling/barrel-empty.png"
local barrel_empty_side_mask = "__base__/graphics/icons/fluid/barreling/barrel-empty-side-mask.png"
local barrel_empty_top_mask = "__base__/graphics/icons/fluid/barreling/barrel-empty-top-mask.png"
local barrel_empty_side_mask_bottom = "__LegendarySpaceAge__/graphics/barreling/barrel-empty-side-mask-bottom.png"
local barrel_empty_side_mask_top = "__LegendarySpaceAge__/graphics/barreling/barrel-empty-side-mask-top.png"

local function generate_barrel_icons(base_icon, masksAndColors)
	local icons = {
		{
			icon = base_icon.icon or base_icon,
			icon_size = base_icon.icon_size or defines.default_icon_size,
		},
	}
	for _, maskAndColor in pairs(masksAndColors) do
		table.insert(icons, {
			icon = maskAndColor[1],
			icon_size = 64,
			tint = maskAndColor[2],
		})
	end
	return icons
end

local function generate_barrel_recipe_icons(fluid, base_icon, masksAndColors, fluid_icon_shift)
	local icons = generate_barrel_icons(base_icon, masksAndColors)
	if fluid.icon then
		table.insert(icons,
			{
				icon = fluid.icon,
				icon_size = (fluid.icon_size or defines.default_icon_size),
				scale = 16.0 / (fluid.icon_size or defines.default_icon_size), -- scale = 0.5 * 32 / icon_size simplified
				shift = fluid_icon_shift
			}
		)
	elseif fluid.icons then
		icons = util.combine_icons(icons, fluid.icons, { scale = 0.5, shift = fluid_icon_shift }, fluid.icon_size)
	end
	return icons
end

------------------------------------------------------------------------
--- Functions to set barrel icons

---@param proto data.ItemPrototype
---@param sideColor data.Color
---@param topColor data.Color?
---@param sideAlpha double?
---@param topAlpha double?
---@param setRecipesForFluid data.FluidPrototype?
-- Creates barrel icon similar to vanilla - one color on side (fluid.base_color for vanilla) and optionally one on top (fluid.flow_color for vanilla).
Icon.set2ColorBarrel = function(proto, sideColor, topColor, sideAlpha, topAlpha, setRecipesForFluid)
	local sideColorA = util.get_color_with_alpha(sideColor, sideAlpha or barrel_side_alpha)
	local topColorA = nil
	if topColor ~= nil then
		topColorA = util.get_color_with_alpha(topColor, topAlpha or barrel_top_hoop_alpha)
	end
	local masksAndColors = {
		{barrel_side_mask, sideColorA}
	}
	if topColorA ~= nil then
		table.insert(masksAndColors, {barrel_hoop_top_mask, topColorA})
	end
	proto.icons = generate_barrel_icons(empty_barrel_icon, masksAndColors)
	proto.icon = nil

	if setRecipesForFluid ~= nil then
		assert(setRecipesForFluid ~= nil, serpent.block(setRecipesForFluid))

		-- Edit icons for barrel-filling recipe.
		local fillRecipe = RECIPE[proto.name]
		assert(fillRecipe ~= nil, proto.name)
		local fillMasksAndColors = {
			{barrel_fill_side_mask, sideColorA}
		}
		if topColorA ~= nil then
			table.insert(fillMasksAndColors, {barrel_fill_top_mask, topColorA})
		end
		fillRecipe.icon = nil
		fillRecipe.icons = generate_barrel_recipe_icons(setRecipesForFluid, barrel_fill_icon, fillMasksAndColors, fluid_icon_shift_barrelling)

		-- Edit icons for barrel-emptying recipe.
		local emptyRecipe = RECIPE["empty-"..proto.name]
		assert(emptyRecipe ~= nil, proto.name)
		local emptyMasksAndColors = {
			{barrel_empty_side_mask, sideColorA}
		}
		if topColorA ~= nil then
			table.insert(emptyMasksAndColors, {barrel_empty_top_mask, topColorA})
		end
		emptyRecipe.icon = nil
		emptyRecipe.icons = generate_barrel_recipe_icons(setRecipesForFluid, barrel_empty_icon, emptyMasksAndColors, fluid_icon_shift_barrelling)
	end
end

---@param proto data.ItemPrototype
---@param sideColor1 data.Color Color of top band.
---@param sideColor2 data.Color Color of bottom band.
---@param topColor data.Color?
---@param sideAlpha1 double?
---@param sideAlpha2 double?
---@param topAlpha double?
---@param setRecipesForFluid data.FluidPrototype?
-- Creates barrel icon but with 2 colors on the sides, and optionally one on top.
Icon.set3ColorBarrel = function(proto, sideColor1, sideColor2, topColor, sideAlpha1, sideAlpha2, topAlpha, setRecipesForFluid)
	local sideColor1A = util.get_color_with_alpha(sideColor1, sideAlpha1 or barrel_side_alpha)
	local sideColor2A = util.get_color_with_alpha(sideColor2, sideAlpha2 or barrel_side_alpha)
	local topColorA = topColor
	if topColor ~= nil then
		topColorA = util.get_color_with_alpha(topColor, topAlpha or barrel_top_hoop_alpha)
	end

	local masksAndColors = {
		{barrel_side_mask_top, sideColor1A},
		{barrel_side_mask_bottom, sideColor2A},
	}
	if topColorA ~= nil then
		table.insert(masksAndColors, {barrel_hoop_top_mask, topColorA})
	end
	proto.icons = generate_barrel_icons(empty_barrel_icon, masksAndColors)
	proto.icon = nil

	if setRecipesForFluid ~= nil then
		assert(setRecipesForFluid ~= nil, serpent.block(setRecipesForFluid))

		-- Edit icons for barrel-filling recipe.
		local fillRecipe = RECIPE[proto.name]
		assert(fillRecipe ~= nil, proto.name)
		local fillMasksAndColors = {
			{barrel_side_mask_top, sideColor1A},
			{barrel_side_mask_bottom, sideColor2A},
		}
		if topColorA ~= nil then
			table.insert(fillMasksAndColors, {barrel_fill_top_mask, topColorA})
		end
		fillRecipe.icon = nil
		fillRecipe.icons = generate_barrel_recipe_icons(setRecipesForFluid, barrel_fill_icon, fillMasksAndColors, fluid_icon_shift_barrelling)

		-- Edit icons for barrel-emptying recipe.
		local emptyRecipe = RECIPE["empty-"..proto.name]
		assert(emptyRecipe ~= nil, proto.name)
		local emptyMasksAndColors = {
			{barrel_empty_side_mask_top, sideColor1A},
			{barrel_empty_side_mask_bottom, sideColor2A},
		}
		if topColorA ~= nil then
			table.insert(emptyMasksAndColors, {barrel_empty_top_mask, topColorA})
		end
		emptyRecipe.icon = nil
		emptyRecipe.icons = generate_barrel_recipe_icons(setRecipesForFluid, barrel_empty_icon, emptyMasksAndColors, fluid_icon_shift_emptying)
	end
end

-- Creates barrel icon with 1 color on side (fluid.base_color for vanilla) and no top color.
Icon.set1ColorBarrel = function(proto, sideColor, sideAlpha, setRecipeForFluid)
	Icon.set2ColorBarrel(proto, sideColor, nil, sideAlpha, setRecipeForFluid)
end

return Icon