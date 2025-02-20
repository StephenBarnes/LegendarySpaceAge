--[[ This file creates the "sugar" item, similar to nutrients.
TODO: I'm still trying to figure out what sugar is for, what recipes to add. Maybe a simpler, less efficient precursor to nutrients? Maybe you bake mash or jelly to produce sugar, then either directly use that or process it (in biochamber) into nutrients, which have higher nutrition value.
]]

local item = copy(ITEM["nutrients"])
item.name = "sugar"
Icon.set(item, "LSA/gleba/sugar/1")
Icon.variants(item, "LSA/gleba/sugar/%", 3)
extend{item}
