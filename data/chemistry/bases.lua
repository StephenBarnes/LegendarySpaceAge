--[[ This file creates items/fluids for bases (as in the opposite of acids), plus recipes for them.

Note that this mod deliberately conflates sodium and potassium in many chemicals, because they have almost the same sources and uses, and conflating them reduces the number of items/recipes we need.

Namely:
	"Alkali ash" represents soda and and potash, ie sodium/potassium carbonate.
	"Lye" is sodium/potassium hydroxide in water. It's always a fluid. It's more efficient in some recipes, to balance against the extra logistical burden of using fluids instead of items.
	"Quicklime" (calcium oxide) is a solid that you make by heating calcite.
	"Slaked lime" (calcium hydroxide) is a solid that you can make by mixing quicklime with water.
		Quicklime + water + canister produces a hot canister of slaked lime, which can be used as a heat provider for endo plants etc. Then when it's cold you can empty out the slaked lime from the canister and refill it for reuse.
]]

-- Create alkali ash item.
local alkaliAsh = copy(ITEM["stone"])
alkaliAsh.name = "alkali-ash"
Icon.set(alkaliAsh, "LSA/bases/alkali-ash/1")
Icon.variants(alkaliAsh, "LSA/bases/alkali-ash/%", 3)
alkaliAsh.stack_size = 100 -- Increase 50->100 vs stone and ores.
extend{alkaliAsh}

-- Create slaked lime item.
local slakedLime = copy(alkaliAsh)
slakedLime.name = "slaked-lime"
Icon.set(slakedLime, "LSA/bases/slaked-lime/item")
Icon.variants(slakedLime, "LSA/bases/slaked-lime/%", 3)
slakedLime.stack_size = 100
extend{slakedLime}

-- Create quicklime item.
local quicklime = copy(alkaliAsh)
quicklime.name = "quicklime"
Icon.set(quicklime, "LSA/bases/quicklime/3") -- It's recolored calcite icons, so using different variant from calcite's main variant.
Icon.variants(quicklime, "LSA/bases/quicklime/%", 4)
quicklime.stack_size = 100
extend{quicklime}

-- Create lye fluid.
local lye = copy(FLUID.electrolyte)
lye.name = "lye"
Icon.set(lye, "LSA/bases/lye")
local lyeColor = {0.518, 0.196, 0.459}
lye.base_color = lyeColor
lye.flow_color = {1, 1, 1}
lye.visualization_color = lyeColor
extend{lye}