-- This file creates item groups for intermediate factors.

extend{
	-- Create a new tab for intermediate factors.
	{
		type = "item-group",
		name = "intermediate-factors",
		order = "c2",
		icon = "__LegendarySpaceAge__/graphics/intermediate-factors/factors-tab.png",
		icon_size = 256,
	},
}

-- Create subgroup for each intermediate factor.
for i, factor in pairs{
	"resin",
	"wiring",
	"circuit-board",
	"panel",
	"frame",
	"structure",
	"fluid-fitting",
	"shielding",
	"lightweight-structure",
	"mechanism",
	"sensor",
	"actuator",
} do
	extend{
		{
			type = "item-subgroup",
			name = factor,
			group = "intermediate-factors",
			order = string.format("%02d", i),
		},
	}
end