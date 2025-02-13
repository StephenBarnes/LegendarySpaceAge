--[[ This file creates the "sugar" item, similar to nutrients.
TODO: I'm still trying to figure out what sugar are for, their role in this modpack. Maybe a simpler, less efficient precursor to nutrients? TODO.
]]

local item = copy(ITEM["nutrients"])
item.name = "sugar"
Icon.set(item, "LSA/gleba/sugar/1")
Icon.variants(item, "LSA/gleba/sugar/%", 3)
extend{item}
