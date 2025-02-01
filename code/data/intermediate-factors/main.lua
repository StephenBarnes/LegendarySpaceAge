--[[ This file adds items+recipes for "intermediate factors". These are intermediate items that have multiple alternative recipes, which are used in various recipes.

Explanation for why these exist:
	I wanted to give alternative routes to creating buildings - Why can an assembler only be made of iron? Why do medium poles have to be made of steel? Why are all pipes made of iron? Etc.
	There exist mods that add e.g. pipes made from copper, and electric poles made from iron, etc.
	But I don't want to give each building 10 alternative recipes for every possible configuration of ingredients.
	So this mod/modpack creates "intermediate factors" that have alternative recipes, and then those intermediate factors are used to make various kinds of infrastructure.
	These intermediate factors "factor out" the alternative recipes (hence the name), effectively allowing multiple ways to make each end product, without needing 5 recipes for assemblers or whatever.
	An intermediate factor is defined by its FUNCTION or PROPERTIES, rather than by its COMPOSITION.
		For example, a "frame" is a framework that is rigid enough to make buildings. It doesn't matter if it's made of wood, iron, or steel. But there's no recipe for making it from rubber, because rubber is not rigid.

Factor intermediates and their meaning:
	Frame - rigid hollow frame, made from wood+resin, iron rods, steel plates, or later from bio-lattice.
	Panel - flat panel, not meant to be very strong, made from iron/copper/steel plates.
	Structure - strong non-hollow building material, made from stone bricks + cement, or later from concrete, etc.
	Fluid fitting - a pipe or fitting for carrying liquids/gases, made from copper+resin or plastic+rubber.
	Shielding - heavy plate that protects against heat (in furnaces) or enemies (in turrets) or radiation (in reactors), made from steel plates or later tungsten plates.
	Lightweight panel - basically we're stealing the "low-density structure" from the base game. Made from iron+copper+plastic, or maybe plastic+rubber+carbon fiber or sth.
	Mechanism - made from machine parts plus frame, or later advanced parts, or with Gleba mineral-water nonsense.
	Sensor - made from green/red/blue circuits, glass, etc.

Other intermediate factors considered but decided against:
	Thermal/refractory casing separet from armor plating.
	Compute, and advanced compute - decided to rather just use sensors and circuits as ingredients. Circuits have matryoshka recipes so players will have all of them available anyway.
]]

require("code.data.intermediate-factors.wiring")
require("code.data.intermediate-factors.frame")
require("code.data.intermediate-factors.panel")
require("code.data.intermediate-factors.structure")
require("code.data.intermediate-factors.fluid-fitting")
require("code.data.intermediate-factors.shielding")
require("code.data.intermediate-factors.lightweight-structure")
require("code.data.intermediate-factors.mechanism")
require("code.data.intermediate-factors.sensor")