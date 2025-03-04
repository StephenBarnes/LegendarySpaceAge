--[[ This file edits minable results of some entities that spawn on Vulcanus, like the rocks and trees.
Goal: make it easier to get early carbon and early tungsten.
]]

---@type table<string, {[1]:string, [2]:number}[]>
local vulcanusMinableSimpleEnts = {
	["vulcanus-chimney"] = { -- Originally 9-15 stone + 0-5 sulfur.
		{"stone", 10},
		{"sulfur", 10},
		{"carbon", 5},
	},
	["vulcanus-chimney-faded"] = { -- Originally 9-15 stone + 0-5 sulfur.
		{"stone", 10},
		{"sulfur", 10},
		{"carbon", 5},
	},
	["vulcanus-chimney-cold"] = { -- Originally 9-15 stone + 0-5 sulfur.
		{"stone", 10},
		{"sulfur", 10},
		{"carbon", 5},
	},
	["vulcanus-chimney-short"] = { -- Originally 9-15 stone.
		{"stone", 10},
		{"carbon", 5},
	},
	["vulcanus-chimney-truncated"] = { -- Originally 9-15 stone.
		{"stone", 10},
		{"carbon", 5},
	},
	["huge-volcanic-rock"] = { -- Originally 6-18 stone + 9-27 iron + 6-18 copper + 3-15 tungsten.
		{"stone", 50},
		{"iron-ore", 50},
		{"copper-ore", 25},
		{"tungsten-ore", 25},
		{"carbon", 20},
	},
	["big-volcanic-rock"] = { -- Originally 2-12 stone + 5-9 iron + 3-7 copper + 2-8 tungsten.
		{"stone", 25},
		{"iron-ore", 25},
		{"copper-ore", 20},
		{"tungsten-ore", 20},
		{"carbon", 10},
	},
}
for name, newResultsShort in pairs(vulcanusMinableSimpleEnts) do
	local ent = RAW["simple-entity"][name]
	assert(ent ~= nil, "Minable "..name.." not found.")
	assert(ent.minable.results ~= nil, "Minable "..name.." has no results.")
	local newMinableResult = {}
	for _, newResult in pairs(newResultsShort) do
		table.insert(newMinableResult, {type = "item", name = newResult[1], amount = newResult[2]})
	end
	ent.minable.results = newMinableResult
end

local vulcanusMinableTrees = {
	["ashland-lichen-tree"] = { -- Originally 2 carbon.
		{"carbon", 10},
		{"resin", 5},
	},
	["ashland-lichen-tree-flaming"] = { -- Originally 2 carbon.
		{"carbon", 10},
		{"resin", 5},
	},
}
for name, newResultsShort in pairs(vulcanusMinableTrees) do
	local ent = RAW["tree"][name]
	assert(ent ~= nil, "Minable "..name.." not found.")
	assert(ent.minable.results ~= nil, "Minable "..name.." has no results.")
	local newMinableResult = {}
	for _, newResult in pairs(newResultsShort) do
		table.insert(newMinableResult, {type = "item", name = newResult[1], amount = newResult[2]})
	end
	ent.minable.results = newMinableResult
end