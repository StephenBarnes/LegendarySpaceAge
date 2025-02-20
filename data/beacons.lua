--[[ This file creates a lower-tier beacon (with tech and recipe) and edits the other higher-tier beacon.
Aims:
* Make beaconed designs more interesting by using the BeaconPrototype.profile field introduced in Factorio 2.0. And by adding a 2nd type of beacon.
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
		Let p(n) be profile values indexed by n. So p(n) is the multiplier on power of all beacons, if there's n beacons. Total effect of the n beacons is then n*p(n).
		We could let p(n) = n^(-k) for some power k.
			If k = 1, then p(n) = n^(-1) = 1/n (so 1, .5, .33, .25) then total effect is n*1/n = 1, so 1 beacon is just as good as any other number, so zero marginal returns.
			If k = 0, then p(n) = n^(0) = 1, then total effect is n*1 = n, so constant marginal returns.
			For values of k between 0 and 1, each beacon has diminishing but still positive marginal returns.
			Default is k = 0.5, so p(n) = n^(-0.5) = 1/sqrt(n) which is the middle of the k=0 and k=1 curves on a log-scale. Total effect is n*1/sqrt(n) = sqrt(n).
				Marginal benefit is p(n) - p(n-1) = 1/sqrt(n) - 1/sqrt(n-1).
				Marginal benefit approaches 0 but is always positive. I think that's desired. If marginal benefit was ever negative, rather just make it zero.
			I kind of want marginal benefit to drop faster. Could move k closer to 1, eg p(n) = n^(-0.666).
		Suppose that instead of this power law p(n) = n^(-k), we want to asymptotically approach a total effect of T.
			We could start at 1, then remove fraction f (say 0.5) the distance to T with each beacon.
			So: p(1) = 1, and then subsequent values are p(n) = ((n-1)p(n-1) + (T - f(n-1)p(n-1)))/n.
			Solving this recurrence relation produces: p(n) = (T + (1-T)((1-f)^(n-1)))/n.
			For example maybe T = 3, f = 1/2, we get total values 1, 2, 2.5, 2.75, 2.875, etc.
	You can actually use negative values in the profile, though it breaks the graph in Factoriopedia. Eg {1, 0.7, 0, -0.1}.
		And it actually works. Including eg inverting speed modules to produce a quality bonus and reduced energy consumption.
	You can specify beacon_counter = "same_type" or "total". So could make basic beacon and advanced beacon not figure into each other's profiles.
		Then advanced beacon could even have the same performance stats and it would still be useful.
	If we have basic and advanced beacons, and use asymptotic profile, what should the actual asymptotes be?
		In 1.1 there were often 8 or 12 beacons per machine for 8x or 12x effect. (Each beacon held 2 modules, but 50% effectivity.)
		In 2.0, with 8 or 12 beacons, that's 8.5 or 10.5 effect, due to diminishing returns curve.
			This is counting 1 beacon as 3 effect, since it's 1.5 effectivity times 2 module slots.
		So maybe:
			For simplicity, give basic/advanced beacons 1 and 2 module slots respectively, with 100% effectivity, so effectively it's 1x and 2x effects.
			You can fit at most around 10 advanced and 10 basic around a machine.
			Total benefit should be around 13x with maximum beacons, so maybe 1*5 = 5 from basic, and 2*4 = 8 from advanced.
			So maybe T = 5, f = 1/4 for basic beacons, and T = 4, f = 1/3 for advanced beacons.
				Those f values mean diminishing returns only kick in with 3rd beacon of that type.

Might have been interesting to make one of the beacon types require lubricant or something. But seems BeaconPrototype only supports electric and void energy sources.
]]

-- Create the basic beacon. Most of this code copied from Beacon Rebalance.
local advancedEnt = RAW.beacon.beacon
local basicEnt = copy(advancedEnt)
basicEnt.name = "basic-beacon"
local graphicsScale = 0.333 -- Beacon rebalance uses 0.5. I'm reducing it to make them 2x2.
local animationSpeed = 0.25 -- Beacon rebalance uses 0.5.
basicEnt.graphics_set = {
	module_icons_suppressed = false,
	random_animation_offset = true,
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
						shift = util.by_pixel(22*graphicsScale, 3*graphicsScale),
						scale = graphicsScale,
                    },
                    { -- Shadow
                        filename = "__LegendarySpaceAge__/graphics/beacons/beacon-base-shadow.png",
						width = 232,
						height = 186,
						shift = util.by_pixel(22*graphicsScale, 3*graphicsScale),
						draw_as_shadow = true,
						scale = graphicsScale,
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
						animation_speed = animationSpeed,
						shift = util.by_pixel(-2*graphicsScale, -110*graphicsScale),
						scale = graphicsScale,
                    },
                    { -- Shadow
                        filename = "__LegendarySpaceAge__/graphics/beacons/beacon-antenna-shadow.png",
						width = 126,
						height = 98,
						line_length = 8,
						frame_count = 32,
						animation_speed = animationSpeed,
						shift = util.by_pixel(201*graphicsScale, 31*graphicsScale),
						draw_as_shadow = true,
						scale = graphicsScale,
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
        scale = 10 * graphicsScale,
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
basicEnt.fast_replaceable_group = nil
extend{basicEnt}

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
basicEnt.module_slots = 1
basicEnt.distribution_effectivity = 1
basicEnt.distribution_effectivity_bonus_per_quality_level = 0.25
basicEnt.collision_box = {{-0.95, -0.95}, {0.95, 0.95}}
basicEnt.selection_box = {{-1, -1}, {1, 1}}
basicEnt.supply_area_distance = 2
basicEnt.energy_usage = "200kW"
basicEnt.allowed_effects = {"consumption", "speed", "productivity", "pollution", "quality"} -- Allow all modules! Including prod and quality.
basicEnt.max_health = 100
basicEnt.heating_energy = "200kW" -- vs 400kW for advanced.
basicEnt.corpse = "medium-remnants"

--[[Could use asymptotic profile above, or n^(-k) profile below.
local advancedProfile = {1}
for i = 2, 50 do
	advancedProfile[i] = Gen.round(i ^ (-0.6), 4)
end
advancedEnt.profile = advancedProfile]]
--advancedEnt.profile = copy(basicEnt.profile)
advancedEnt.profile = makeAsymptoticProfile(4, 1/3)
advancedEnt.module_slots = 2
advancedEnt.distribution_effectivity = 1
advancedEnt.distribution_effectivity_bonus_per_quality_level = 0.25
advancedEnt.collision_box = {{-1.45, -1.45}, {1.45, 1.45}} -- Make collision box closer to boundaries, since supply area must be whole-number.
advancedEnt.supply_area_distance = 3
--[[advancedEnt.icons_positioning = {{ -- Adjusting beacon icon positioning - for back when I gave them 8 module slots, now no longer needed.
	---@diagnostic disable-next-line: assign-type-mismatch
	inventory_index = defines.inventory.beacon_modules,
	max_icons_per_row = 2,
	shift = {0, 0.5}, -- Seems default is 0, 0.7.
}}]]
advancedEnt.energy_usage = "250kW"
advancedEnt.allowed_effects = basicEnt.allowed_effects
advancedEnt.graphics_set.no_modules_tint = {1, 1, 0} -- Not red, since that's now for productivity.

-- Give beacon-wave colors to the prod and quality modules, since they're now allowed in beacons.
-- Also show the graphics of the modules "plugged in" on beacons.
-- Primary color is used for the body of the module. Secondary is used for lights on the module, and tint of the light wave moving on beacon.
-- Actually I'll change beacons to instead use tertiary color for the light wave.
for _, suffix in pairs{"", "-2", "-3"} do
	local prodMod = RAW.module["productivity-module"..suffix]
	prodMod.beacon_tint = {
		primary = {.894, .42, .282},
		secondary = {.988, .796, .078},
	}
	prodMod.beacon_tint.tertiary = prodMod.beacon_tint.primary
	prodMod.art_style = "vanilla" -- To show graphics of it "plugged in" on beacons.
	local qualMod = RAW.module["quality-module"..suffix]
	qualMod.beacon_tint = {
		primary = {.796, .784, .761},
		secondary = {.961, .2, .184},
	}
	qualMod.beacon_tint.tertiary = qualMod.beacon_tint.primary
	qualMod.art_style = "vanilla"

	-- For efficiency and speed modules, copy secondary color to tertiary, for use as light-wave in beacon.
	local effMod = RAW.module["efficiency-module"..suffix]
	effMod.beacon_tint.tertiary = effMod.beacon_tint.secondary
	local speedMod = RAW.module["speed-module"..suffix]
	speedMod.beacon_tint.tertiary = speedMod.beacon_tint.secondary
end

-- Make beacon use module's tertiary color for the light wave.
RAW.beacon.beacon.graphics_set.apply_module_tint = "tertiary"

-- Create item.
local basicItem = copy(ITEM.beacon)
basicItem.name = "basic-beacon"
basicItem.icon = "__LegendarySpaceAge__/graphics/beacons/icon.png"
basicItem.place_result = "basic-beacon"
extend{basicItem}

-- Create recipe. Will set the details in infra/ file.
local basicRecipe = Recipe.make{
	copy = "beacon",
	recipe = "basic-beacon",
	resultCount = 1,
}

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
advancedTech.prerequisites = {"basic-beacons", "processing-unit"}
advancedTech.unit.ingredients = {
	{"automation-science-pack", 1},
	{"logistic-science-pack", 1},
	{"chemical-science-pack", 1},
}