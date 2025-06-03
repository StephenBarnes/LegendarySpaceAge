-- Change fish spoil timer to a more sane number. No fun allowed.
RAW.capsule["raw-fish"].spoil_ticks = 2 * HOURS

-- Add photograph item.
---@type data.ItemPrototype
local photographItem = {
	type = "item",
	name = "photograph",
	icon = "__LegendarySpaceAge__/graphics/misc/photo.png",
	icon_size = 64,
	stack_size = 100,
	weight = ROCKET / 1000,
	auto_recycle = false,
}
-- Considered making it usable in equipment grids, but it's not possible in a clean way. Eg inventory-bonus-equipment will display the bonus even if it's 0, and movement-bonus-equipment requires nonzero electricity consumption.
extend{photographItem}