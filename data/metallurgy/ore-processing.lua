--[[ This file makes items, recipes, etc. for processing ores. ]]

local crushedOreData = {
	["iron-ore"] = {
		iconPath = "LSA/crushed/iron-ore/",
	},
	["copper-ore"] = {
		iconPath = "LSA/crushed/copper-ore/",
	},
	["tungsten-ore"] = {
		iconPath = "LSA/crushed/tungsten-ore/",
	},
}
local slagData = {
	iron = {
		iconPath = "LSA/slag/iron/",
	},
	copper = {
		iconPath = "LSA/slag/copper/",
	},
}

-- Crushed ores
for oreName, data in pairs(crushedOreData) do
	-- Create crushed ore item.
	local item = copy(ITEM[oreName])
	item.name = "crushed-" .. oreName
	Icon.set(item, data.iconPath .. "1")
	Icon.variants(item, data.iconPath .. "%", 2)
	extend{item}

	-- Recipe for crushing ore.
	Recipe.make{
		recipe = "crushed-" .. oreName,
		copy = "stone-brick",
		category = "crushing",
		ingredients = {{oreName, 2}},
		results = {
			{"stone", 1},
			{item.name, 2},
		},
		main_product = item.name,
		time = 1,
		enabled = true, -- TODO make techs.
		-- TODO recipe tint
	}
end

-- Slag
for metal, data in pairs(slagData) do
	-- Create slag item.
	local oreName = metal .. "-ore"
	local item = copy(ITEM[oreName])
	item.name = metal .. "-slag"
	Icon.set(item, data.iconPath .. "1")
	Icon.variants(item, data.iconPath .. "%", 4)
	extend{item}
end
