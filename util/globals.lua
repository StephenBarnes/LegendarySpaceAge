-- Global shortcuts for indexing data.raw.
RAW = data.raw
RECIPE = RAW.recipe
ITEM = RAW.item
FLUID = RAW.fluid
TECH = RAW.technology
ASSEMBLER = RAW["assembling-machine"]
FURNACE = RAW.furnace

-- Global aliases
copy = table.deepcopy
extend = function(x) data:extend(x) end