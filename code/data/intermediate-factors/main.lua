--[[ This file adds items+recipes for "intermediate factors". These are intermediate items that have multiple alternative recipes, which are used in various recipes.
Explanation for why these exist:
	I wanted to give alternative routes to creating buildings - Why can an assembler only be made of iron? Why do medium poles have to be made of steel? Why are all pipes made of iron? Etc.
	There exist mods that add e.g. pipes made from copper, and electric poles made from iron, etc.
	But I don't want to give each building 10 alternative recipes for every possible configuration of ingredients.
	So this mod/modpack creates "intermediate factors" that have alternative recipes, and then those intermediate factors are used to make various kinds of infrastructure.
	These intermediate factors "factor out" the alternative recipes (hence the name), effectively allowing multiple ways to make each end product, without needing 5 recipes for assemblers or whatever.
	An intermediate factor is defined by its FUNCTION or PROPERTIES, rather than by its COMPOSITION.
		For example, a "rigid structure" is a thing that is rigid enough to make buildings. It doesn't matter if it's made of wood, iron, or stone. But there's no recipe for making it from rubber, because rubber is not rigid.
	Note that the base game's "low-density structure" is named after its function/properties (low density). We hijack it as an intermediate factor, moving it to the early game.
]]

require("code.data.intermediate-factors.rigid-structure")
require("code.data.intermediate-factors.lightweight-structure")
require("code.data.intermediate-factors.fluid-fitting")
require("code.data.intermediate-factors.thermal-casing")
require("code.data.intermediate-factors.sensor")