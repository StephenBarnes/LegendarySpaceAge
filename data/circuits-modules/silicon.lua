--[[ This file creates silicon and related recipes.

Stone processing produces silica.
Silica is made into crude silicon, in arc furnace: silica + carbon + heat -> crude silicon + carbon monoxide + (rarely) silicon seed crystal

Crude silicon is used to make "silicon gas" (trichlorosilane) plus "silicon waste gas" (silicon tetrachloride).
Silicon gas production: crude silicon + hydrochloric acid + copper dust (minor, represents catalyst) + heat -> silicon gas + silicon waste gas + hydrogen + copper salt (spent catalyst)
Silicon waste gas can be vented (creating pollution and wasting silicon and chlorine), or processed via 2 recipes with different tradeoffs.
Silicon waste gas handling 1: silicon waste gas + crude silicon + hydrogen + heat -> silicon gas
Silicon waste gas handling 2: silicon waste gas + water -> silica + hydrochloric acid
Polysilicon production: silicon gas + hydrogen -> polysilicon + hydrochloric acid

Silicon crystal growth including doping: polysilicon + white phosphorus + acetone barrel + silicon seed crystal + heat -> silicon crystal ingot + crude silicon + empty barrel
The initial silicon seed crystal is obtained from the silica recipe above, but it's too rare to rely on, so once ingots are grown, they can be cut for more seed crystals, or for wafers.
Cutting into wafers or seeds: silicon crystal ingot + carborundum -> (silicon seed crystals or silicon wafers) + crude silicon (dust)
]]

-- Create crude silicon item.
local crudeSiliconItem = copy(RAW.item["iron-plate"])
crudeSiliconItem.name = "crude-silicon"
Icon.set(crudeSiliconItem, "LSA/silicon/crude/1")
Icon.variants(crudeSiliconItem, "LSA/silicon/crude/%", 3)
crudeSiliconItem.localised_name = nil
crudeSiliconItem.localised_description = nil
crudeSiliconItem.hidden = false
crudeSiliconItem.hidden_in_factoriopedia = false
crudeSiliconItem.spoil_ticks = nil
crudeSiliconItem.spoil_result = nil
extend{crudeSiliconItem}

-- TODO create silica item (probably in stone processing file)

-- TODO create silicon gas.
-- TODO create silicon waste gas.
-- TODO create polysilicon.
-- TODO create silicon crystal ingot.
-- TODO create silicon seed crystal.
-- TODO create silicon wafer.
-- TODO create recipes.