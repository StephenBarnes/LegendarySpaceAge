--[[ This file creates items/fluids/recipes for the phenox system.
"Phenox" is a made-up name for cumene hydroperoxide.
Phenox is only in barrels, which spoil to phenol-acetone barrels.
Phenol-acetone barrels are separated to get acetone barrels + phenol (item).
Phenol-acetone barrels spoil to petrochem sludge barrels.
]]

local phenolColor = {0.875, 0.718, 0.278}
local acetoneColor = {0.149, 0.529, 0.502}
local acetoneFlowColor = {0.249, 0.729, 0.702} -- TODO decide on a flow color, this is temporary

-- Create phenox barrel item.
-- TODO
-- TODO figure out how the icon should look different from phenol-acetone barrel. Maybe striped vertically, or triangle pattern

-- Create phenol-acetone barrel item.
local phenolAcetoneBarrel = copy(ITEM.barrel)
phenolAcetoneBarrel.name = "phenol-acetone-barrel"
Icon.set3ColorBarrel(phenolAcetoneBarrel, acetoneColor, phenolColor, nil, 1, 1)
extend{phenolAcetoneBarrel}

-- Create acetone barrel item.
local acetoneBarrel = copy(phenolAcetoneBarrel)
acetoneBarrel.name = "acetone-barrel"
Icon.set2ColorBarrel(acetoneBarrel, acetoneColor, acetoneFlowColor, 0.82)
extend{acetoneBarrel}
