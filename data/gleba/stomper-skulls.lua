--[[ This file adds autoplaces for stomper head shells, and changes their minable results.
	So that the player can manually mine them for initial calcite, marrow, eggs, without needing to actually kill stompers.
]]

-- Setting minable results. Originally they were 1-10 stone, 1-10 spoilage, 0-1 half-spoiled eggs. Same for all sizes.
for size, multiplier in pairs{
	small = 1,
	medium = 2,
	big = 3,
	behemoth = 4,
} do
	local shell = data.raw["simple-entity"][size.."-stomper-shell"]
	shell.minable.results = {
		{type = "item", name = "chitin-fragments", amount_min = 0, amount_max = 20 * multiplier},
		{type = "item", name = "marrow", amount_min = 0, amount_max = 5 * multiplier},
		{type = "item", name = "appendage", amount_min = 0, amount_max = 5, percent_spoiled = 0.5},
		{type = "item", name = "spoilage", amount_min = 0, amount_max = 20 * multiplier},
		{type = "item", name = "pentapod-egg", amount_min = 0, amount_max = 1, percent_spoiled = 0.5},
	}
end

--[[ SETTING AUTOPLACES FOR SMALL AND MEDIUM SKULLS.
There's data.raw.corpse[prefix.."stomper-corpse"] (for prefix "small-", "medium-", "big-"). These are just decoratives.
There's also data.raw["simple-entity"][prefix.."stomper-shell"] which is the created shell.
We want to autoplace all of them, basically just scattering small amounts everywhere in the lowlands, just roughly-uniformly distributed. Similar to stromatolites.
But, currently when placed they also create the corpse. So we create no-corpse versions of them to autoplace.

Copying autoplaces from stromatolites, but modifying them.
Gleba-select params: input, from, to, slope, min, max.
Iron stromatolite:   probability_expression = "gleba_select(gleba_iron_stromatolite   - clamp(gleba_decorative_knockout, 0, 1), 1.3, 2, 0.2, 0, 1)"
	gleba_iron_stromatolite is   gleba_select(gleba_aux, 0.6, 2.0, 0.1, -10, 1) - 1
Copper stromatolite: probability_expression = "gleba_select(gleba_copper_stromatolite - clamp(gleba_decorative_knockout, 0, 1), 1.3, 2, 0.2, 0, 1)"
	gleba_copper_stromatolite is gleba_select(gleba_aux,-1.0, 0.4, 0.1, -10, 1) - 1
Looks like the middle part of that (0.4 to 0.6) is the highland. -1 to 0.4 is green lowland, 0.6 to 2 is purple lowland.
So, we use the same autoplace, but max those segments.
That still doesn't really match stromatolite distribution - stromatolites are always in water, seems to be due to collision_mask.layers.ground_tile.
	Tried adding that. Also have to 100x the probability multiplier or they become very rare.
	On the whole, decided against it. Rather have stromatolites in the water, skulls on land.
]]

local smallShellNoCorpse = copy(data.raw["simple-entity"]["small-stomper-shell"])
smallShellNoCorpse.name = "small-stomper-shell-no-corpse"
smallShellNoCorpse.localised_name = {"entity-name.small-stomper-shell"}
smallShellNoCorpse.created_effect = nil -- Don't create a corpse.
smallShellNoCorpse.autoplace = {
	order = "a1",
	probability_expression = "multiplier * gleba_select(gleba_stomper_shell - clamp(gleba_decorative_knockout, 0, 1), 1.3, 2, 0.2, 0, 1)",
	local_expressions = {
		multiplier = 0.009,
		gleba_stomper_shell = "max(gleba_iron_stromatolite, gleba_copper_stromatolite)",
	}
}
-- Default: map_color = {129, 105, 78} - looks like cliffs.
smallShellNoCorpse.map_color = {174, 156, 136}
smallShellNoCorpse.hidden = true
smallShellNoCorpse.hidden_in_factoriopedia = true
smallShellNoCorpse.factoriopedia_alternative = "small-stomper-shell"
data:extend{smallShellNoCorpse}
data.raw.planet.gleba.map_gen_settings.autoplace_settings.entity.settings["small-stomper-shell-no-corpse"] = {}

local mediumShellNoCorpse = copy(data.raw["simple-entity"]["medium-stomper-shell"])
mediumShellNoCorpse.name = "medium-stomper-shell-no-corpse"
mediumShellNoCorpse.localised_name = {"entity-name.medium-stomper-shell"}
mediumShellNoCorpse.created_effect = nil -- Don't create a corpse.
mediumShellNoCorpse.autoplace = copy(smallShellNoCorpse.autoplace)
mediumShellNoCorpse.autoplace.order = "a2"
mediumShellNoCorpse.autoplace.local_expressions.multiplier = 0.004
mediumShellNoCorpse.map_color = {174, 156, 136}
mediumShellNoCorpse.hidden = true
mediumShellNoCorpse.hidden_in_factoriopedia = true
mediumShellNoCorpse.factoriopedia_alternative = "medium-stomper-shell"
data:extend{mediumShellNoCorpse}
data.raw.planet.gleba.map_gen_settings.autoplace_settings.entity.settings["medium-stomper-shell-no-corpse"] = {}