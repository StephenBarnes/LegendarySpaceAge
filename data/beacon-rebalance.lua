-- This file adjusts beacons. Note this mod uses the Beacon Rebalance mod, so these changes are on top of that mod's changes.

-- Set image for the beacon 2 tech to use the newer beacons. Beacon 1 tech is fine, it uses the old beacons.
TECH["effect-transmission-2"].icon = "__base__/graphics/technology/effect-transmission.png"
TECH["effect-transmission-2"].icon_size = 256

-- Set beacon 1 item icons (wret "classic" beacon), removing the "I".
ITEM["beacon"].icons = nil
ITEM["beacon"].icon = "__wret-beacon-rebalance-mod__/classic_beacon_graphics/icon/beacon.png"
ITEM["beacon"].icon_size = 64

-- Set beacon 2 item icons (newer vanilla).
ITEM["wr-beacon-2"].icons = nil
ITEM["wr-beacon-2"].icon = "__base__/graphics/icons/beacon.png"
ITEM["wr-beacon-2"].icon_size = 64

-- Set entity images for beacon 2.
RAW.beacon["wr-beacon-2"].graphics_set = require("__base__.prototypes.entity.beacon-animations")

-- Set params for the beacon mk1.
local beacon1ent = RAW.beacon["beacon"]
beacon1ent.distribution_effectivity = 0.5
beacon1ent.energy_usage = "100kW"
beacon1ent.module_slots = 4
beacon1ent.collision_box = {{-1.48, -1.48}, {1.48, 1.48}} -- Close to 1.5, so supply area doesn't look like it's a fraction of a tile.
beacon1ent.selection_box = {{-1.5, -1.5}, {1.5, 1.5}}
beacon1ent.supply_area_distance = 2 -- It's a 3x3 building, supply 2 tiles outwards so supply area 7x7.

-- Set params for the beacon mk2.
local beacon2ent = RAW.beacon["wr-beacon-2"]
beacon2ent.distribution_effectivity = 1
beacon2ent.energy_usage = "1MW"
beacon2ent.module_slots = 4
beacon2ent.collision_box = {{-1.48, -1.48}, {1.48, 1.48}}
beacon2ent.selection_box = {{-1.5, -1.5}, {1.5, 1.5}}
beacon2ent.supply_area_distance = 5 -- It's a 3x3 building, supply 5 tiles outwards so supply area 13x13.

-- Beacons 2 tech name and description
TECH["effect-transmission-2"].localised_name = {"technology-name.effect-transmission-2"}
TECH["effect-transmission-2"].localised_description = {"technology-description.effect-transmission-2"}

-- Move beacon 1 tech to soon after modules.
local beacon1tech = TECH["effect-transmission"]
beacon1tech.prerequisites = {"modules"}
beacon1tech.unit = copy(TECH["modules"].unit)
beacon1tech.unit.count = 200

-- Beacon 2 should be after Fulgora and after beacon 1 tech. So, edit science packs.
local beacon2tech = TECH["effect-transmission-2"]
beacon2tech.unit.ingredients = {
	{"automation-science-pack", 1},
	{"logistic-science-pack", 1},
	{"chemical-science-pack", 1},
	{"space-science-pack", 1},
	{"electromagnetic-science-pack", 1},
}

-- TODO maybe move modules tech earlier, and remove red circuits as ingredient.
-- TODO consider using the other mod with the exclusion areas, might lead to more interesting designs.