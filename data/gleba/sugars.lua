--[[ This file creates the "sugars" item, similar to nutrients.
TODO: I'm still trying to figure out what sugars are for, their role in this modpack. Maybe a simpler, less efficient precursor to nutrients? TODO.
]]

local item = copy(ITEM["nutrients"])
item.name = "sugars"
local sugarDir = "__LegendarySpaceAge__/graphics/gleba/sugars/"
item.icon = sugarDir .. "1.png"
local sugarPics = {}
for i = 1, 3 do
	table.insert(sugarPics, {
		filename = sugarDir .. i .. ".png",
		size = 64,
		scale = 0.5,
		-- draw_as_glow = true,
	})
end
item.pictures = sugarPics
data:extend{item}
