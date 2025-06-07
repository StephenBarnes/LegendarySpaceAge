--[[ This file creates recipes for processing stone into other materials, and creates those items.
TODO add gypsum, gravel, many others.
]]

local gypsum = copy(ITEM.stone)
gypsum.name = "gypsum"
extend{gypsum}
-- TODO this is a placeholder for now.