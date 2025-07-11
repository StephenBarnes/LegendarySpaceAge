--[[ This file makes arc furnaces get an increasing speed and prod bonus as they continue to run, which then drops off when they're idle.
Almost all the code here is copied from Apprentice Assembler mod by Quezler: https://mods.factorio.com/mod/apprentice-assembler
I decided to copy code here and edit it because I wanted it to apply to existing foundry (instead of a new assembler) and then later changed my mind to rather apply it to a different new building (arc furnace), and I want to customize the numbers for bonuses.
Explanation of how it works:
	The beacon-interface mod (dependency) has beacons with adjustable bonuses. This is implemented by giving it like 400 module slots then using modules with power-of-two benefits. For example to get +50% prod (110010 in binary), the beacon gets 3 modules with +32% prod, +16% prod, +2% prod.
	This mod (apprentice-assembler) creates one of those adjustable beacons inside the apprentice assembler (now arc furnace), and sets bonuses based on how many products have been finished.
	To count when products are finished or machine is idle, the assembler (arc furnace) has circuit connections to inserters on a hidden surface. Inserters get enabled/disabled using circuit conditions looking at the assembler's working state.
	When the inserters are enabled, they pick up wood "offering" items on the hidden surface, which causes the item-on-ground entity to die, which triggers a callback in this mod to update products-finished count.
]]

-- ADDED
local INTERFACE_BEACON_NAME = "beacon-interface--beacon-tile"
local SURFACE_NAME = "apprentice-arc-furnace"
local APPLIES_TO_ENT = "arc-furnace"
local function get_bonuses(products) -- Percent bonuses given number of products finished.
	return {
		speed = products,
		productivity = products,
		consumption = 0,
		pollution = 0,
		quality = 0,
	}
end
local LOSSES_PER_SECOND = 10
	-- Number of consecutive-products lost for each second of inactivity.
	-- Note that when arc furnace is inactive it looks like all bonuses were lost instantly. It gets shown accurately when arc furnace starts working again.
local MAX_PRODUCTS = 100 -- Maximum number of products finished in a row before we stop counting.
------------------------------------------------------------------------


local Inserters = {}
function Inserters.create_for_struct(struct)
	local entity_cb = struct.entity.get_or_create_control_behavior() --[[@as LuaAssemblingMachineControlBehavior]]
	entity_cb.circuit_read_recipe_finished = true
	entity_cb.circuit_recipe_finished_signal = { type = "virtual", name = "signal-F" }
	entity_cb.circuit_read_working = true
	entity_cb.circuit_working_signal = { type = "virtual", name = "signal-W" }

	struct.inserter_1 = storage.surface.create_entity {
		name = "inserter",
		force = "neutral",
		position = { 0.5 + struct.index, -1.5 },
		---@diagnostic disable-next-line: assign-type-mismatch
		direction = SOUTH,
	}
	assert(struct.inserter_1)
	inserter_1_cb = struct.inserter_1.get_or_create_control_behavior() --[[@as LuaInserterControlBehavior]]
	inserter_1_cb.circuit_enable_disable = true
	-- SAB: The docs and my dev tooling say this should be {circuit={..}} but that breaks the mod. So docs are probably wrong.
	---@diagnostic disable-next-line: missing-fields
	inserter_1_cb.circuit_condition = {
		comparator = ">",
		constant = 0,
		first_signal = {
			name = "signal-F",
			type = "virtual"
		},
		fulfilled = false
	}

	do
		local green_out = struct.entity.get_wire_connector(defines.wire_connector_id.circuit_green, false) --[[@as LuaWireConnector]]
		local green_in = struct.inserter_1.get_wire_connector(defines.wire_connector_id.circuit_green, false) --[[@as LuaWireConnector]]
		assert(green_out.connect_to(green_in, false, defines.wire_origin.script))
	end

	struct.inserter_2 = storage.surface.create_entity {
		name = "inserter",
		force = "neutral",
		position = { 0.5 + struct.index, -4.5 },
		---@diagnostic disable-next-line: assign-type-mismatch
		direction = SOUTH,
	}
	assert(struct.inserter_2)
	inserter_2_cb = struct.inserter_2.get_or_create_control_behavior() --[[@as LuaInserterControlBehavior]]
	inserter_2_cb.circuit_enable_disable = true
	---@diagnostic disable-next-line: missing-fields
	inserter_2_cb.circuit_condition = {
		comparator = "=",
		constant = 0,
		first_signal = {
			name = "signal-W",
			type = "virtual"
		},
		fulfilled = false
	}

	do
		local green_out = struct.entity.get_wire_connector(defines.wire_connector_id.circuit_green, false) --[[@as LuaWireConnector]]
		local green_in = struct.inserter_2.get_wire_connector(defines.wire_connector_id.circuit_green, false) --[[@as LuaWireConnector]]
		assert(green_out.connect_to(green_in, false, defines.wire_origin.script))
	end
end

local function new_struct(table, struct)
	assert(struct.id, serpent.block(struct))
	assert(table[struct.id] == nil)
	table[struct.id] = struct
	return struct
end

local function reset_offering_1(struct)
	struct.inserter_1.held_stack.clear()
	struct.inserter_1_offering = storage.surface.create_entity {
		name = "item-on-ground",
		force = "neutral",
		position = { 0.5 + struct.index, -0.5 },
		stack = { name = "wood" },
	}
	storage.deathrattles[script.register_on_object_destroyed(struct.inserter_1_offering)] = { "offering_1", struct.id }
end

local function reset_offering_2(struct)
	struct.inserter_2.held_stack.clear()
	struct.inserter_2_offering = storage.surface.create_entity {
		name = "item-on-ground",
		force = "neutral",
		position = { 0.5 + struct.index, -3.5 },
		stack = { name = "wood" },
	}
	storage.deathrattles[script.register_on_object_destroyed(struct.inserter_2_offering)] = { "offering_2", struct.id }
end

local Handler = {}

Handler.on_init = function()
	storage.surface = game.planets[SURFACE_NAME].create_surface()
	storage.surface.generate_with_lab_tiles = true

	storage.surface.create_global_electric_network()
	storage.surface.create_entity {
		name = "electric-energy-interface",
		force = "neutral",
		position = { -1, -1 },
	}

	storage.index = 0
	storage.structs = {}
	storage.deathrattles = {}
end

Handler.on_configuration_changed = function()
	if storage.structs == nil then
		storage.structs = {}
	end
	for _, struct in pairs(storage.structs) do
		struct.products_finished = struct.products_finished or 0
		struct.last_idle_at = struct.last_idle_at or 0
	end
end

function Handler.on_created_entity(event)
	-- SAB adding this check. This shouldn't happen, but it did, maybe bc I only added this script after creating the game?
	if storage.index == nil then
		Handler.on_init()
	end

	local entity = event.entity or event.destination
	if not entity.valid then return end -- SAB added, seems to be needed because I'm adding air-separator-exclusion stuff.
	if entity.name ~= APPLIES_TO_ENT then return end

	local struct = new_struct(storage.structs, {
		id = entity.unit_number,
		index = storage.index,
		entity = entity,

		products_finished = 0,
		last_idle_at = event.tick,

		inserter_1 = nil, -- F > 0
		inserter_1_offering = nil,
		inserter_2 = nil, -- W = 0
		inserter_2_offering = nil,
		beacon_interface = nil,

		working = false,
	})
	storage.index = storage.index + 1

	storage.deathrattles[script.register_on_object_destroyed(entity)] = { "crafter", struct.id }

	struct.beacon_interface = entity.surface.create_entity {
		name = INTERFACE_BEACON_NAME,
		force = entity.force,
		position = entity.position,
		raise_built = true,
	}
	struct.beacon_interface.destructible = false

	Inserters.create_for_struct(struct)
	reset_offering_1(struct)
	reset_offering_2(struct)
end

---@return number
local function get_recipe_ticks(struct)
	---@type LuaEntity
	local ent = struct.entity
	if ent == nil or not ent.valid then
		log("Error: ent is nil or invalid")
		return 0
	end
	---@type LuaRecipe?
	local last_recipe = ent.get_recipe()
	if last_recipe == nil then
		log("Error: last recipe is nil")
		return 0
	end
	return 60 * last_recipe.energy / ent.crafting_speed
end

local function finished_crafting(struct)
	local updateBeacon = false

	if struct.working == false then
		struct.working = true
		reset_offering_2(struct)
		-- struct.last_idle_at is when it stopped working, and game.tick is when latest craft finished. So latest craft STARTED some time before game.tick.
		-- To get how long it was idle, we need last_idle_at minus the tick it started this craft.
		-- To get the time it started this craft, we need to subtract recipe time from game.tick.
		local recipe_ticks = get_recipe_ticks(struct)
		local idle_ticks = math.max(0, (game.tick - recipe_ticks) - struct.last_idle_at)
		local idle_seconds = math.ceil(idle_ticks / 60)
		struct.products_finished = math.max(0, struct.products_finished - idle_seconds * LOSSES_PER_SECOND)
		updateBeacon = true
	end

	if struct.products_finished < MAX_PRODUCTS then
		struct.products_finished = struct.products_finished + 1
		reset_offering_1(struct)
		updateBeacon = true
	end

	if updateBeacon then
		remote.call("beacon-interface", "set_effects", struct.beacon_interface.unit_number, get_bonuses(struct.products_finished))
	end
end

local function stopped_working(struct)
	struct.working = false
	struct.last_idle_at = game.tick
	reset_offering_1(struct)
end

Handler.on_object_destroyed = function(event)
	local deathrattle = storage.deathrattles[event.registration_number]
	if deathrattle then
		storage.deathrattles[event.registration_number] = nil

		if deathrattle[1] == "offering_1" then
			local struct = storage.structs[deathrattle[2]]
			if struct then
				-- game.print(string.format("#%d finished crafting @ %d", struct.id, event.tick))
				finished_crafting(struct)
			end
		elseif deathrattle[1] == "offering_2" then
			local struct = storage.structs[deathrattle[2]]
			if struct then
				-- game.print(string.format("#%d stopped working @ %d", struct.id, event.tick))
				stopped_working(struct)
			end
		elseif deathrattle[1] == "crafter" then
			local struct = storage.structs[deathrattle[2]]
			struct.inserter_1.destroy()
			struct.inserter_1_offering.destroy()
			struct.inserter_2.destroy()
			struct.inserter_2_offering.destroy()
			struct.beacon_interface.destroy()
			storage.structs[struct.id] = nil
		else
			error(serpent.block(deathrattle))
		end
	end
end

return Handler