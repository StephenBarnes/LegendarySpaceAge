-- Change holmium solution recipe to require sulfuric acid instead of water.
RECIPE["holmium-solution"].ingredients = {
	{type = "fluid", name = "sulfuric-acid", amount = 10},
	{type = "item", name = "holmium-ore", amount = 2},
}

-- Change electrolyte solution - previously stone, heavy oil, holmium solution.
RECIPE["electrolyte"].ingredients = {
	{type = "item", name = "sand", amount = 1},
	{type = "fluid", name = "holmium-solution", amount = 10},
	{type = "fluid", name = "water", amount = 10},
}

-- Remove temperature stats from fluids (electrolyte and holmium-solution).
FLUID["holmium-solution"].max_temperature = nil
FLUID["holmium-solution"].heat_capacity = nil
FLUID["electrolyte"].max_temperature = nil
FLUID["electrolyte"].heat_capacity = nil

-- Adjust the ruins to just yield scrap. No need to yield stuff like cables, steel plate. And also yield electrophages.
for _, vals in pairs{
	{
		name = "fulgoran-ruin-small",
		scrapCount = 4,
		electrophages = nil,
	},
	{
		name = "fulgoran-ruin-medium",
		scrapCount = 10,
		electrophages = nil,
	},
	{
		name = "fulgoran-ruin-stonehenge",
		scrapCount = 20,
		electrophages = {0, 0, .2},
	},
	{
		name = "fulgoran-ruin-big",
		scrapCount = 20,
		electrophages = {0, 0, .3},
	},
	{
		name = "fulgoran-ruin-huge",
		scrapCount = 40,
		electrophages = {0, 0, .5},
	},
	{
		name = "fulgoran-ruin-colossal",
		scrapCount = 60,
		electrophages = {0, 0, .8},
	},
	{
		name = "fulgoran-ruin-vault",
		scrapCount = 200,
		electrophages = {2, 10, nil},
	},
	{
		name = "fulgoran-ruin-attractor",
		type = "lightning-attractor",
		scrapCount = 4,
		electrophages = {6, 12, nil},
	},
} do
	local ruin = RAW[vals.type or "simple-entity"][vals.name]
	assert(ruin ~= nil, "Fulgoran ruin " .. vals.name .. " not found")
	local scrapHalf = math.floor(vals.scrapCount / 2)
	local scrapMin = vals.scrapCount - scrapHalf
	local scrapMax = vals.scrapCount + scrapHalf
	assert(ruin.minable ~= nil, "Fulgoran ruin " .. vals.name .. " has no minable")
	ruin.minable.results = {{
		type = "item",
		name = "scrap",
		amount_min = scrapMin,
		amount_max = scrapMax,
	}}
	if vals.electrophages then
		table.insert(ruin.minable.results, {
			type = "item",
			name = "electrophage",
			amount_min = vals.electrophages[1],
			amount_max = vals.electrophages[2],
			extra_count_fraction = vals.electrophages[3],
		})
	end
end

-- Edit recipes.
Recipe.edit{
	recipe = "supercapacitor",
	ingredients = { -- Originallyy 4 green circuit + 1 battery + 2 holmium plate + 2 superconductor + 10 electrolyte.
		{"holmium-plate", 2},
		{"superconductor", 2},
		{"electrolyte", 10},
	},
	time = 10,
}
Recipe.edit{
	recipe = "superconductor",
	ingredients = { -- Originally 1 copper plate + 1 plastic bar + 1 holmium plate + 5 light oil -> 2 superconductor.
		{"copper-plate", 1},
		{"plastic-bar", 1},
		{"holmium-plate", 1},
		{"fulgoran-sludge", 5, type = "fluid"},
	},
	time = 5,
}
RECIPE["electromagnetic-science-pack"].surface_conditions = nil
	-- Allow it anywhere - you'd still need to ship electrolyte, but I think it's good to give people the choice to maybe ship that instead of the science packs.
Recipe.edit{
	recipe = "electromagnetic-science-pack",
	ingredients = { -- Originally 1 accumulator + 1 supercapacitor + 25 electrolyte + 25 holmium solution.
		{"white-circuit-superclocked", 2},
		{"electrolyte", 10},
	},
	time = 10,
}