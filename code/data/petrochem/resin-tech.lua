-- This file creates the tech for petroleum resin. It's like an optional addon after basic petrochemistry. Wood resin is generally cheaper on Nauvis, but this is needed for Vulcanus and Fulgora.

local resinTech = table.deepcopy(data.raw.technology["lubricant"])
resinTech.name = "petroleum-resin"
resinTech.icons = {{icon = "__LegendarySpaceAge__/graphics/petrochem/coking-tech.png", icon_size = 256}}
	-- TODO icon
resinTech.effects = {
	{type = "unlock-recipe", recipe = "pitch-resin"},
	{type = "unlock-recipe", recipe = "rich-gas-resin"},
}
data:extend{resinTech}

-- TODO this should be required for Fulgora and Vulcanus, I guess.