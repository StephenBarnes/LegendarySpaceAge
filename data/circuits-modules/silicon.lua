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

local silicaTint = {.533, .604, .569}
local crudeSiliconTint = {.349, .51, .431}
local polysiliconTint = {.302, .455, .373}
local siliconGasTint = polysiliconTint
local siliconGasFlowTint = {.207, .311, .255}
local siliconWasteGasTint = {.557, .569, .345}
local siliconWasteGasFlowTint = {.462, .472, .286}

-- TODO create silica item (probably in stone processing file)

-- Create crude silicon item.
local crudeSiliconItem = copy(RAW.item["iron-plate"])
crudeSiliconItem.name = "crude-silicon"
Icon.set(crudeSiliconItem, "LSA/silicon/crude/1")
Icon.variants(crudeSiliconItem, "LSA/silicon/crude/%", 3)
crudeSiliconItem.random_tint_color = crudeSiliconTint
crudeSiliconItem.has_random_tint = true
crudeSiliconItem.localised_name = nil
crudeSiliconItem.localised_description = nil
crudeSiliconItem.hidden = false
crudeSiliconItem.hidden_in_factoriopedia = false
crudeSiliconItem.spoil_ticks = nil
crudeSiliconItem.spoil_result = nil
extend{crudeSiliconItem}

-- Create silica item.
local silicaItem = copy(crudeSiliconItem)
silicaItem.name = "silica"
Icon.set(silicaItem, "LSA/silicon/silica")
silicaItem.random_tint_color = silicaTint
silicaItem.has_random_tint = true
extend{silicaItem}

-- Create polysilicon item.
local polysiliconItem = copy(crudeSiliconItem)
polysiliconItem.name = "polysilicon"
Icon.set(polysiliconItem, "LSA/silicon/poly/1")
Icon.variants(polysiliconItem, "LSA/silicon/poly/%", 2)
polysiliconItem.random_tint_color = polysiliconTint
polysiliconItem.has_random_tint = true
extend{polysiliconItem}

-- Create silicon gas fluid.
local siliconGasFluid = copy(RAW.fluid.steam)
siliconGasFluid.name = "silicon-gas"
Icon.set(siliconGasFluid, {{"LSA/fluids/gas-2", tint = siliconGasTint}})
Fluid.setSimpleTemp(siliconGasFluid, 1000)
siliconGasFluid.base_color = siliconGasTint
siliconGasFluid.visualization_color = siliconGasTint
siliconGasFluid.flow_color = siliconGasFlowTint
siliconGasFluid.auto_barrel = false
extend{siliconGasFluid}

-- Create silicon waste gas fluid.
local siliconWasteGasFluid = copy(RAW.fluid.steam)
siliconWasteGasFluid.name = "silicon-waste-gas"
Icon.set(siliconWasteGasFluid, {{"LSA/fluids/gas-2", tint = siliconWasteGasTint}})
Fluid.setSimpleTemp(siliconWasteGasFluid, 1000)
siliconWasteGasFluid.base_color = siliconWasteGasTint
siliconWasteGasFluid.visualization_color = siliconWasteGasTint
siliconWasteGasFluid.flow_color = siliconWasteGasFlowTint
siliconWasteGasFluid.auto_barrel = false
extend{siliconWasteGasFluid}

-- TODO create silicon crystal ingot.
-- TODO create silicon seed crystal.
-- TODO create silicon wafer.
-- TODO create recipes.
-- TODO create tech/s.