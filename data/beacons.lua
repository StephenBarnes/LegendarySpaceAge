--[[ This file creates a lower-tier beacon (with tech and recipe) and edits the other higher-tier beacon.
Aims:
* Make beaconed designs more interesting by using the BeaconPrototype.profile field introduced in Factorio 2.0 to make beacons have rapidly diminishing returns.
* Introduce beacons a lot earlier.

Using graphics and some code from Beacon Rebalance https://mods.factorio.com/mod/wret-beacon-rebalance-mod by wretlaw120 with some spritework by Sir-Lags-A-Lot. Originally had that mod as dependency and adjusted it, but I wanted to rather experiment with using the new profile field.

Stats from base code:
    distribution_effectivity = 1.5,
    distribution_effectivity_bonus_per_quality_level = 0.2,
    profile = {1,0.7071,0.5773,etc}, -- 100 entries.
    beacon_counter = "same_type",
    module_slots = 2,

For profiles:
	See post for explanation: https://factorio.com/blog/post/fff-409
		Given profile with value p(n) being the profile (strength mult of each beacon), total effect is n*p(n).
		If p(n) = n^(-1) = 1/n (so 1, .5, .33, .25) then total effect is n*1/n = 1, so 1 beacon is just as good as any other number.
		If p(n) = n^(0) = 1, then total effect is n*1 = n.
		Between those extremes, each beacon has diminishing but still positive returns.
		Default is p(n) = n^(-0.5) = 1/sqrt(n) which is in the middle between the extremes on a log-scale. Total effect is n*1/sqrt(n) = sqrt(n).
			Marginal benefit is p(n) - p(n-1) = 1/sqrt(n) - 1/sqrt(n-1).
			Marginal benefit approaches 0 but is always positive. I think that's desired. If marginal benefit was ever negative, rather just make it zero.
		I kind of want marginal benefit to drop faster. Could move exponent closer to -1, eg p(n) = n^(-0.666).
		Suppose we want to asymptotically approach a total effect of T. We could start at 1, then remove fraction f (say 0.5) the distance to T with each beacon.
			This would be p(1) = 1, and p(n) = ((n-1)p(n-1) + (T - f(n-1)p(n-1)))/n.
			Solving this recurrence relation, we get p(n) = (T + (1-T)((1-f)^(n-1)))/n.
			For example maybe T = 4, f = 1/3, we get total values 1, 2, 2.7, 3.1, 3.4, 3.6, 3.7, 3.8, 3.9.
	You can actually use negative values here, though it breaks the graph in Factoriopedia. Eg {1, 0.7, 0, -0.1}.
		And it actually works. Including eg inverting speed modules to produce a quality bonus and reduced energy consumption.
	You can specify beacon_counter = "same_type" or "total". So could make basic beacon and advanced beacon not figure into each other's profiles.
		Then advanced beacon could even have the same performance stats and it would still be useful.
	If we have basic and advanced beacons, and use asymptotic profile, what should the actual asymptotes be?
		In 1.1 there were often 8 or 12 beacons per machine for 8x or 12x effect.
		In 2.0, with 8 or 12 beacons, that's 8.5 or 10.5 effect.
			This is counting 1 beacon as 3 effect, since it's 1.5 effectivity times 2 module slots.
		Note I'm making beacon ranges lower, so maybe should be easier to reach asymptote. Maybe around 4 advanced beacons, 2 basic beacons.
		(Also I'm giving them 4 or 8 module slots with 50% effectivity, so effectively it's 2x and 4x effects.)
		So maybe:
			Both types of beacons at T = 5, f = 1/4.
			Then at most you could fit like 5 basic and 5 advanced. Total benefit is 2*187% + 4*187% = 11.22.

Might have been interesting to make one of the beacon types require lubricant or something. But seems BeaconPrototype only supports electric and void.
]]

-- Create the basic beacon. Most of this code copied from Beacon Rebalance.
local advancedEnt = RAW.beacon.beacon
local basicEnt = copy(advancedEnt)
basicEnt.name = "basic-beacon"
basicEnt.graphics_set = {
	module_icons_suppressed = false,
	animation_list = {
		{ -- Beacon base
            render_layer = "lower-object-above-shadow",
            always_draw = true,
            animation = {
                layers = {
                    { -- Base
                        filename = "__LegendarySpaceAge__/graphics/beacons/beacon-base.png",
						width = 232,
						height = 186,
						shift = util.by_pixel(11, 1.5),
						scale = 0.5,
                    },
                    { -- Shadow
                        filename = "__LegendarySpaceAge__/graphics/beacons/beacon-base-shadow.png",
						width = 232,
						height = 186,
						shift = util.by_pixel(11, 1.5),
						draw_as_shadow = true,
						scale = 0.5,
                    }
                }
            }
        },
        { -- Beacon Antenna
            render_layer = "object",
            always_draw = true,
            animation = {
                layers = {
                    { -- Base
                        filename = "__LegendarySpaceAge__/graphics/beacons/beacon-antenna.png",
						width = 108,
						height = 100,
						line_length = 8,
						frame_count = 32,
						animation_speed = 0.5,
						shift = util.by_pixel(-1, -55),
						scale = 0.5,
                    },
                    { -- Shadow
                        filename = "__LegendarySpaceAge__/graphics/beacons/beacon-antenna-shadow.png",
						width = 126,
						height = 98,
						line_length = 8,
						frame_count = 32,
						animation_speed = 0.5,
						shift = util.by_pixel(100.5, 15.5),
						draw_as_shadow = true,
						scale = 0.5,
                    },
                },
            },
        },
	},
}
basicEnt.water_reflection = {
    pictures = {
        filename = "__LegendarySpaceAge__/graphics/beacons/beacon-reflection.png",
        priority = "extra-high",
        width = 24,
        height = 28,
        shift = util.by_pixel(0, 55),
        variation_count = 1,
        scale = 5,
    },
    rotate = false,
    orientation_to_variation = false
}
basicEnt.icon = "__LegendarySpaceAge__/graphics/beacons/icon.png"
basicEnt.minable.result = "basic-beacon"
basicEnt.placeable_by = {
    item = "basic-beacon",
    count = 1
}
extend{basicEnt}

-- Create item.
local basicItem = copy(ITEM.beacon)
basicItem.name = "basic-beacon"
basicItem.icon = "__LegendarySpaceAge__/graphics/beacons/icon.png"
basicItem.place_result = "basic-beacon"
extend{basicItem}

-- Create recipe.
local basicRecipe = Recipe.make{
	copy = "beacon",
	recipe = "basic-beacon",
	resultCount = 1,
}

local function asymptoticProfileEntry(n, T, f)
	-- Returns effect of nth beacon, if we want to asymptotically approach T times the power of first beacon, with rate of approach f.
	-- For example, T = 4, f = 1/4, the first beacon has effect 1, next one has f =(1/4) times the remaining distance to T which is 3, so 0.75.
	local val = (T + (1-T)*((1-f)^(n-1)))/n
	return Gen.round(val, 4)
end
local function makeAsymptoticProfile(T, f)
	local profile = {1}
	for i = 2, 50 do
		profile[i] = asymptoticProfileEntry(i, T, f)
	end
	return profile
end
basicEnt.profile = makeAsymptoticProfile(5, 1/4)
basicEnt.module_slots = 4
basicEnt.distribution_effectivity = 0.5
basicEnt.distribution_effectivity_bonus_per_quality_level = 0.25
basicEnt.collision_box = {{-1.45, -1.45}, {1.45, 1.45}} -- Make collision box closer to boundaries, since supply area must be whole-number.
basicEnt.supply_area_distance = 1
basicEnt.energy_usage = "100kW"

--[[Could use asymptotic profile above, or n^(-k) profile below.
local advancedProfile = {1}
for i = 2, 50 do
	advancedProfile[i] = Gen.round(i ^ (-0.6), 4)
end
advancedEnt.profile = advancedProfile]]
--advancedEnt.profile = makeAsymptoticProfile(7, 1/6)
advancedEnt.profile = copy(basicEnt.profile)
advancedEnt.module_slots = 8
advancedEnt.distribution_effectivity = 0.5
advancedEnt.distribution_effectivity_bonus_per_quality_level = 0.25
advancedEnt.collision_box = {{-1.45, -1.45}, {1.45, 1.45}}
advancedEnt.supply_area_distance = 3
advancedEnt.icons_positioning = {{ 
	---@diagnostic disable-next-line: assign-type-mismatch
	inventory_index = defines.inventory.beacon_modules,
	max_icons_per_row = 4,
	shift = {0, 0.3}, -- Seems default is 0, 0.7.
}}
advancedEnt.energy_usage = "1MW"

-- Create tech for basic beacons, and edit module tech and advanced beacon tech.
local advancedTech = TECH["effect-transmission"]
local basicTech = copy(advancedTech)
basicTech.name = "basic-beacons"
basicTech.effects = {
	{
		type = "unlock-recipe",
		recipe = "basic-beacon",
	},
}
Icon.set(basicTech, "LSA/beacons/tech")
basicTech.prerequisites = {"modules"}
basicTech.unit = copy(TECH["modules"].unit)
basicTech.unit.count = 2 * basicTech.unit.count
extend{basicTech}
Tech.setPrereqs("modules", {"logistic-science-pack"})
advancedTech.prerequisites = {"basic-beacons", "electromagnetic-science-pack"}
advancedTech.unit.ingredients = {
	{"automation-science-pack", 1},
	{"logistic-science-pack", 1},
	{"chemical-science-pack", 1},
	{"space-science-pack", 1},
	{"electromagnetic-science-pack", 1},
}