-- This file makes stingfronds a farmable crop, and creates recipes and items for them.
-- Some of the code here was copied from "Fluroflux: Stingfrond Agriculture" mod by LordMiguel: https://mods.factorio.com/mod/fluroflux

------------------------------------------------------------------------
--- Change stingfrond from type "tree" to type "plant", so it's farmable.

---@type data.PlantPrototype
---@diagnostic disable-next-line: assign-type-mismatch
local stingfrondPlant = table.deepcopy(data.raw.tree.stingfrond)
stingfrondPlant.type = "plant"

stingfrondPlant.growth_ticks = 60 * 60 * 8 -- 8 minutes; compare to yumako/jellystem at 5 minutes.
stingfrondPlant.placeable_by = {item = "nettles", count = 1}
-- Wube's code defines the autoplace stuff twice. Second time overwrites the tile restriction. But we need a tile restriction so it's growable on some tiles. Maybe just midland turquoise, like Fluroflux. By default it spawns in other midland/highland tiles too.
stingfrondPlant.autoplace.tile_restriction = {
	"midland-turquoise-bark",
	"midland-turquoise-bark-2",
	--"midland-cracked-lichen-dark",
	--"midland-cracked-lichen-dull",
	--"highland-dark-rock-2",
}
-- Make them visible on map.
stingfrondPlant.map_color = {102, 198, 207}
-- Edit color shown in ag tower.
stingfrondPlant.agricultural_tower_tint = {
	primary = {r = 0.47, g = 0.90, b = 0.94, a = 1},
	secondary = {r = 0.40, g = 0.77, b = 0.81, a = 1},
}

-- Delete old stingfrond tree, add new stingfrond plant.
data.raw.tree.stingfrond = nil
data:extend({stingfrondPlant})

------------------------------------------------------------------------
--- Create items for products of stingfrond farming.

-- Create nettles
-- TODO
local nettleItem = table.deepcopy(data.raw.item["tree-seed"])
nettleItem.name = "nettles"
nettleItem.localised_name = nil
nettleItem.plant_result = "stingfrond"
data:extend{nettleItem}
