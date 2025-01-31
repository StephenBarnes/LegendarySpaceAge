--[[ This file adds items+recipes for "intermediate factors". These are intermediate items that have multiple alternative recipes, which are used in various recipes.
Explanation for why these exist:
	I wanted to give alternative routes to creating buildings - Why can an assembler only be made of iron? Why do medium poles have to be made of steel? Why are all pipes made of iron? Etc.
	There exist mods that add e.g. pipes made from copper, and electric poles made from iron, etc.
	But I don't want to give each building 10 alternative recipes for every possible configuration of ingredients.
	So this mod/modpack creates "intermediate factors" that have alternative recipes, and then those intermediate factors are used to make various kinds of infrastructure.
	These intermediate factors "factor out" the alternative recipes (hence the name), effectively allowing multiple ways to make each end product, without needing 5 recipes for assemblers or whatever.
	An intermediate factor is defined by its FUNCTION or PROPERTIES, rather than by its COMPOSITION.
		For example, a "frame" is a framework that is rigid enough to make buildings. It doesn't matter if it's made of wood, iron, or steel. But there's no recipe for making it from rubber, because rubber is not rigid.
Other intermediate factors considered but decided against:
	Thermal casing, for furnaces etc; and armor-plating for turrets etc. - decided to rather just use one "cladding" item that represents both refractory / heat-resistant building material, and armor plating, and general plating eg for making barrels.
	Low-density structure - could hijack this, add alternate recipes, make it an early-game item. But there's not many uses for it, so rather just leaving it as-is.
	Flexible material - eg rubber and carbon fiber. Not enough uses; could use it for fluid stuff, but that's what the fluid fitting is for.
	Mechanical parts - already have the machine-parts item (which is simple, just iron) and advanced-parts (which requires pulling together steel+rubber+plastic+lubricant), not really much room for alternate recipes.
	Compute, and advanced compute - decided to rather just have sensors as ingredients, or the most advanced circuit available when a given item is available.
]]

require("code.data.intermediate-factors.frame")
require("code.data.intermediate-factors.cladding")
require("code.data.intermediate-factors.fluid-fitting")
require("code.data.intermediate-factors.sensor")