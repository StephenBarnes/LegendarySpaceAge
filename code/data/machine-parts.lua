-- This modpack renames "iron gear wheels" to "machine parts"; this file changes sprites to match that.
-- Then this file also creates "advanced parts", which are made from like hot steel + rubber + plastic + bit of lubricant, and will generally replace steel plates in recipes for infra.
-- TODO

-- Update icons for iron parts.
data.raw.item["iron-gear-wheel"].icon = nil
data.raw.item["iron-gear-wheel"].icons = {
	{icon = "__LegendarySpaceAge__/graphics/parts-basic/plain/gear-2.png", icon_size = 64, scale=0.4, mipmap_count=4, shift={-3, 3}},
	{icon = "__LegendarySpaceAge__/graphics/parts-basic/plain/spring-2.png", icon_size = 64, scale=0.4, mipmap_count=4, shift={3, -4}},
}
data.raw.item["iron-gear-wheel"].pictures = {
	{filename = "__LegendarySpaceAge__/graphics/parts-basic/plain/gear-1.png", size = 64, scale = 0.5, mipmap_count = 4},
	{filename = "__LegendarySpaceAge__/graphics/parts-basic/plain/gear-2.png", size = 64, scale = 0.5, mipmap_count = 4},
	{filename = "__LegendarySpaceAge__/graphics/parts-basic/plain/gear-3.png", size = 64, scale = 0.5, mipmap_count = 4},
	{filename = "__LegendarySpaceAge__/graphics/parts-basic/plain/spring-1.png", size = 64, scale = 0.5, mipmap_count = 4},
	{filename = "__LegendarySpaceAge__/graphics/parts-basic/plain/spring-2.png", size = 64, scale = 0.5, mipmap_count = 4},
}
data.raw.item["iron-gear-wheel"].has_random_tint = true
data.raw.item["iron-gear-wheel"].random_tint_color = data.raw.item["iron-plate"].random_tint_color

-- Update icon for casting recipe.
data.raw.recipe["casting-iron-gear-wheel"].icon = nil
data.raw.recipe["casting-iron-gear-wheel"].icons = {
	{icon = "__LegendarySpaceAge__/graphics/parts-basic/plain/gear-2.png", icon_size = 64, scale=0.5, mipmap_count=4, shift={-5, 5}},
	{icon = "__space-age__/graphics/icons/fluid/molten-iron.png", icon_size = 64, scale=0.5, mipmap_count=4, shift={5, -5}},
}

-- Update icons for rusted iron parts.
data.raw.item["rocs-rusting-iron-iron-gear-wheel-rusty"].icon = nil
--[[data.raw.item["rocs-rusting-iron-iron-gear-wheel-rusty"].icons = {
	{icon = "__LegendarySpaceAge__/graphics/parts-basic/rusty/gear-2.png", icon_size = 64, scale=0.4, mipmap_count=4, shift={-4, 4}},
	{icon = "__LegendarySpaceAge__/graphics/parts-basic/rusty/spring-2.png", icon_size = 64, scale=0.4, mipmap_count=4, shift={4, -5}},
}]]
data.raw.item["rocs-rusting-iron-iron-gear-wheel-rusty"].icons = {{icon = "__LegendarySpaceAge__/graphics/parts-basic/rusty/gear-2.png", icon_size = 64, scale=0.5, mipmap_count=4}}
data.raw.item["rocs-rusting-iron-iron-gear-wheel-rusty"].pictures = {
	{filename = "__LegendarySpaceAge__/graphics/parts-basic/rusty/gear-1.png", size = 64, scale = 0.5, mipmap_count = 4},
	{filename = "__LegendarySpaceAge__/graphics/parts-basic/rusty/gear-2.png", size = 64, scale = 0.5, mipmap_count = 4},
	{filename = "__LegendarySpaceAge__/graphics/parts-basic/rusty/gear-3.png", size = 64, scale = 0.5, mipmap_count = 4},
	{filename = "__LegendarySpaceAge__/graphics/parts-basic/rusty/spring-1.png", size = 64, scale = 0.5, mipmap_count = 4},
	{filename = "__LegendarySpaceAge__/graphics/parts-basic/rusty/spring-2.png", size = 64, scale = 0.5, mipmap_count = 4},
}

-- While I'm at it, set random tint colors for all rusty items.
for _, itemName in pairs{"rocs-rusting-iron-iron-gear-wheel-rusty", "rocs-rusting-iron-iron-plate-rusty", "rocs-rusting-iron-iron-stick-rusty", "ingot-iron-rusted"} do
	data.raw.item[itemName].has_random_tint = true
	data.raw.item[itemName].random_tint_color = {.592, .463, .322}
end

-- Update icon for iron part derusting.
data.raw.recipe["rocs-rusting-iron-iron-gear-wheel-derusting"].icon = nil
data.raw.recipe["rocs-rusting-iron-iron-gear-wheel-derusting"].icons = {{icon = "__LegendarySpaceAge__/graphics/parts-basic/derusting.png", icon_size = 64, scale=0.5, mipmap_count=4}}

-- Create advanced parts item.
-- TODO

-- Create recipe for advanced parts.
-- TODO

-- Add advanced parts recipe to steel tech.
-- TODO