--[[ This file makes items, recipes, etc. for processing ores. ]]

local crushingData = {
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

-- Add items for crushed ores.
for oreName, data in pairs(crushingData) do
	local item = copy(ITEM[oreName])
	item.name = "crushed-" .. oreName
	Icon.set(item, data.iconPath .. "1")
	Icon.variants(item, data.iconPath .. "%", 2)
	extend{item}
end

-- Add recipes for crushed ores.
for oreName, data in pairs(crushingData) do
	Recipe.make{
		recipe = "crushed-" .. oreName,
		copy = "stone-brick",
		category = "crushing",
		ingredients = {{oreName, 2}},
		results = {
			{"stone", 1},
			{"crushed-" .. oreName, 2},
		},
		main_product = "crushed-" .. oreName,
		time = 1,
		enabled = true, -- TODO make techs.
		-- TODO recipe tint
	}
end