--[[ This file adjusts numbers and recipes for assemblers and furnaces.
Aims:
* Simplify speeds.
	* For assemblers 1-2-3, simplify the speeds to 0.5 -- 1 -- 2.
	* For furnaces, stone furnace 0.5, other furnaces 1. (Vanilla has stone 1, steel 2, electric 2.)
* Rewrite recipes to use factors.
* Change properties to have good tradeoffs:
	* Assemblers 1-2-3:
		* Electricity per product is roughly the same for all of them, though lower for tier 1 if not using beacons.
		* Pollution is the same for all of them, so pollution per product is lower for higher tiers.
		* Tier 3 has prod and quality bonuses. Quality bonus also means you have to design your production lines to handle quality items.
		* Since speeds double each tier, each tier needs half as much space and belts etc.
		* Tier 3 has high drain, so best suited for lines that are always running.
		* Tier 1 has no drain, so it could actually be best to use tier 1 sometimes even in the late game, eg when using a lot of beacons, or on rarely-used production lines.

Re furnace energy consumption:
	In vanilla, stone furnace was 90kW, and produced one plate in 3.2s. I'm changing it so it produces 1 ingot = 5 plates in 10s, then assembler makes that 5 plates in 5s (basic assembler), so 3s total. So, changing stone furnace to 100kW.
	In vanilla, steel furnace was 90kW, electric furnace 180kW. Changing those to 100kW and 200kW.
	Actually, vanilla furnaces use very little fuel. I've never felt fuel was the limiting factor for my furnace stacks. So rather roughly doubling all of the above.
]]


-- TODO fill out missing fields here
-- TODO add health field
-- TODO edit healths for all entities.
-- TODO add stack size
-- TODO add mandatory perRocket field.
-- TODO check all of these have all of these fields.

---@alias CrafterMachineVals {kind: string, speed: number, drainKW: number, activeKW: number, pollution: number, spores: number?, effects: table?, forbid_quality: boolean?, forbid_productivity: boolean?, clearDescription: boolean?}
---@alias CrafterRecipeVals {ingredients: table, time: number, category: string?}
---@alias CrafterItemVals {perRocket: number, stackSize: number}
---@type table<string, {machine: CrafterMachineVals, recipe: CrafterRecipeVals, item:CrafterItemVals}>
local CRAFTER_VALS = {
	["assembling-machine-1"] = {
		machine = {
			kind = "assembling-machine",
			speed = 0.5,
			drainKW = 0,
			activeKW = 100, -- Vanilla was 75kW.
			pollution = 5, -- Vanilla was 4.
			effects = {
				quality = -0.5, -- Seems to be "perdec" (0-10) rather than percent (0-100) or fraction (0-1).
			},
		},
		recipe = {
			ingredients = {
				{"frame", 1},
				{"panel", 5},
				{"mechanism", 2},
				{"sensor", 1},
			},
			time = 5,
		},
	},
	["assembling-machine-2"] = {
		machine = {
			kind = "assembling-machine",
			speed = 1,
			drainKW = 50,
			activeKW = 250, -- Vanilla was 150.
			pollution = 5, -- Vanilla was 3.
			effects = {
				-- None. Could give it a +5% quality, but it would be annoying to do everywhere, seems better to put it in assembler 3 only. So assembler 3 is for when you can handle the non-normal-quality stuff and the high drain, and then it gives you the extra prod bonus.
			},
		},
		recipe = {
			ingredients = {
				{"frame", 5},
				{"panel", 5},
				{"mechanism", 5},
				{"sensor", 5},
			},
			time = 10,
		},
	},
	["assembling-machine-3"] = {
		-- Vanilla was speed 1.25, 375kW, 2 pollution.
		machine = {
			kind = "assembling-machine",
			speed = 2,
			drainKW = 200,
			activeKW = 500,
			pollution = 5,
			effects = {
				productivity = 0.1, -- It's a fraction 0-1.
				quality = 0.2, -- +2%
			},
		},
		recipe = {
			ingredients = {
				{"frame", 5},
				{"panel", 5},
				{"electric-engine-unit", 20},
				{"sensor", 20},
			},
			time = 20,
		},
	},

	------------------------------------------------------------------------
	--- Furnaces.
	
	["stone-furnace"] = {
		machine = {
			kind = "furnace",
			speed = 0.5,
			drainKW = 0,
			activeKW = 200,
			health = 50, -- Reduced from 200 to 50. To encourage building walls. For comparison, walls have health 350.
		},
		recipe = {
			ingredients = {"structure"},
			time = 2,
		},
	},
	["steel-furnace"] = {
		-- Steel furnaces have similar fuel usage to stone furnaces, but double speed and pollution, and much greater initial infra cost.
		machine = {
			kind = "furnace",
			speed = 1,
			drainKW = 0,
			activeKW = 200,
		},
		recipe = {
			ingredients = {
				{"frame", 5},
				{"structure", 5},
				{"shielding", 5},
			},
			time = 5,
		},
	},
	["gas-furnace"] = {
		machine = {
			kind = "furnace",
			speed = 1,
			drainKW = 0,
			activeKW = 250, -- Slightly more energy than steel furnaces, to compensate for not having to put fuel in barrels/canisters.
		},
		recipe = {
			ingredients = {
				{"frame", 5},
				{"structure", 5},
				{"shielding", 5},
				{"fluid-fitting", 5},
			},
			time = 5,
		},
	},
	["electric-furnace"] = {
		-- Electric furnaces: same speed as steel furnaces, lower pollution (though electricity gen generates pollution).
		-- But make them have high drain so they're bad when not needed.
		-- Giving them the same overall energy consumption, since energy gen from steam engines/turbines is only 50% efficient in this modpack, so that's effectively double the energy consumption unless you use nuclear or solar or lava heating etc.
		machine = {
			kind = "furnace",
			speed = 1,
			drainKW = 50,
			activeKW = 200,
		},
		recipe = {
			ingredients = {
				{"frame", 5},
				{"structure", 10},
				{"shielding", 10},
				{"electronic-components", 10},
			},
			time = 10,
		},
	},
	
	

	------------------------------------------------------------------------
	--- Assembling-machines that aren't called assemblers.

	["char-furnace"] = { -- Technically an assembling machine.
		machine = {
			kind = "assembling-machine",
			-- TODO more vals
			forbid_consumption = true,
			forbid_productivity = true,
		},
		recipe = {
			ingredients = {"structure"},
			time = 2,
		},
	},
	["filtration-plant"] = {
		machine = {
			kind = "furnace",
		},
		-- Needs to be built early, to get steam power, so it should be fairly cheap.
		recipe = {
			time = 10,
			ingredients = {
				{"frame", 10},
				{"fluid-fitting", 20},
				{"mechanism", 10},
			},
		},
	},
	["chemical-plant"] = {
		machine = {
			kind = "assembling-machine",
		},
		recipe = {
			time = 5,
			ingredients = {
				{"frame", 5},
				{"fluid-fitting", 10},
				{"sensor", 5},
				{"mechanism", 5},
			},
			category = "crafting",
		},
	},
	["oil-refinery"] = {
		machine = {
			kind = "assembling-machine",
		},
		recipe = {
			time = 20,
			ingredients = {
				{"frame", 10},
				{"fluid-fitting", 20},
				{"structure", 10},
				{"panel", 20},
			},
		},
	},
	["foundry"] = {
		machine = {
			kind = "assembling-machine",
			-- Originally consumed 2.5MW, and I'm making each one produce like 5x faster though with no prod bonus. But also, I added arc furnaces which consume more.
			activeKW = 2500,
			drainKW = 500,
		},
		-- Originally 50 tungsten carbide + 50 steel plate + 30 green circuit + 20 refined concrete + 20 lubricant.
		-- I'm changing it to not need tungsten carbide, so you can make it on any planet without importing from Vulcanus.
		recipe = {
			time = 10,
			ingredients = {
				{"fluid-fitting", 10},
				{"shielding", 20},
				{"mechanism", 10},
			},
			category = "crafting", -- Don't allow crafting foundries in foundry.
		},
	},
	["arc-furnace"] = {
		machine = {
			kind = "assembling-machine",
			activeKW = 5000,
			drainKW = 1000,
		},
		recipe = {
			time = 10,
			ingredients = {
				{"shielding", 50},
				{"fluid-fitting", 10},
				{"structure", 10},
			},
			category = "crafting",
			clearSurfaceConditions = true,
		},
	},
	["biochamber"] = {
		machine = {
			kind = "assembling-machine",
		},
		-- Biochamber: Originally 20 iron plate + 1 landfill + 5 green circuit + 5 nutrients + 1 pentapod egg.
		-- TODO ensure that you can obtain the nutrients without a biochamber, since the main route is going to be sugar-to-nutrients fermentation.
		recipe = {
			time = 5,
			ingredients = {
				{"fluid-fitting", 10},
				{"sensor", 2},
				{"mechanism", 2},
				{"nutrients", 10},
				--{"slime", 20}, -- No fluid, rather make it hand-craftable.
			},
			category = "organic-or-assembling",
		},
	},
	["cryogenic-plant"] = {
		-- Cryo plant: now moved to early game.
		machine = {
			kind = "assembling-machine",
			speed = 1,
			activeKW = 1000,
			drainKW = 0,
			pollution = 5,
		},
		recipe = {
			time = 10,
			ingredients = {
				{"frame", 10},
				{"fluid-fitting", 20},
				{"sensor", 20},
				{"shielding", 10},
			},
			category = "crafting", -- Not in cryo plant.
		},
		item = {
			perRocket = 20,
		},
	},
	["electromagnetic-plant"] = {
		machine = {
			kind = "assembling-machine",
			speed = 2,
			effects = {
				productivity = 0.5,
			},
			-- Increase power consumption to make Fulgora harder. Originally 2MW.
			activeKW = 5000,
			drainKW = 0,
			clearDescription = true,
		},
		recipe = { -- Originally 50 steel plate + 50 refined concrete + 50 blue circuit + 150 holmium plate.
			ingredients = {
				{"frame", 20},
				{"fluid-fitting", 5},
				{"electric-engine-unit", 20},
				--{"holmium-plate", 10},
					-- Adding this would mean you need to have Fulgora imports to get these. Kinda don't want that, eg if you go Fulgora first you should have EM plants on other planets before exporting science.
			},
			time = 10,
		},
		item = {
		},
	},
	["recycler"] = { -- Technically a furnace, not assembling machine. TODO merge furnaces file with this one.
		machine = {
			kind = "furnace",
			-- Increase power consumption to make Fulgora harder. Originally 180kW.
			activeKW = 250,
			drainKW = 0,
			forbid_quality = true, -- Disabling it to discourage loops for quality, rather encourage quality along the entire production line.
			forbid_productivity = true, -- It's disabled in base Space Age, since it would allow cheese loops.
		},
		recipe = { -- Originally 40 gear + 20 steel plate + 20 concrete + 6 blue circuit.
			ingredients = {
				{"mechanism", 10},
				{"frame", 5},
				{"fluid-fitting", 1},
			},
			time = 5,
		},
	},
	["captive-biter-spawner"] = {
		machine = {
			kind = "assembling-machine",
		},
		-- TODO
	},
	["centrifuge"] = {
		-- TODO recipe etc.
		machine = {
			kind = "assembling-machine",
			clearDescription = true,
		},
	},
}

for name, vals in pairs(CRAFTER_VALS) do
	if vals.recipe then
		local recipeArgs = vals.recipe ---@type table
		recipeArgs.recipe = name
		Recipe.edit(recipeArgs)
	end

	if vals.machine then
		assert(vals.machine.kind == "assembling-machine" or vals.machine.kind == "furnace", "Invalid machine kind: " .. (vals.machine.kind or "nil") .. " for " .. name)
		local ent = RAW[vals.machine.kind][name]
		assert(ent ~= nil, "RAW[" .. vals.machine.kind .. "][" .. name .. "] not found")
		if vals.machine.speed then ent.crafting_speed = vals.machine.speed end
		if vals.machine.drainKW then ent.energy_source.drain = vals.machine.drainKW .. "kW" end
		if vals.machine.activeKW then ent.energy_usage = (vals.machine.activeKW - vals.machine.drainKW) .. "kW" end
		if vals.machine.pollution or vals.machine.spores then
			if ent.energy_source.emissions_per_minute == nil then
				ent.energy_source.emissions_per_minute = {}
			end
			if vals.machine.pollution then ent.energy_source.emissions_per_minute.pollution = vals.machine.pollution end
			if vals.machine.spores then ent.energy_source.emissions_per_minute.spores = vals.machine.spores end
		end

		-- All assemblers can get all beacon and module effects. No module slots. But ban some effects.
		ent.effect_receiver = {
			uses_beacon_effects = true,
			uses_module_effects = true,
			uses_surface_effects = true,
			base_effect = vals.machine.effects,
		}
		allowed_effects = {}
		for _, effect in pairs{"speed", "productivity", "consumption", "pollution", "quality"} do
			if vals.machine["forbid_" .. effect] ~= true then
				table.insert(allowed_effects, effect)
			end
		end
		ent.allowed_effects = allowed_effects
		ent.allowed_module_categories = nil -- Allows all by default.
		if vals.machine.clearDescription then
			ent.localised_description = {"entity-description.no-description"}
		end
	end

	if vals.item then
		if vals.item.perRocket then Item.perRocket(name, vals.item.perRocket) end
	end
end