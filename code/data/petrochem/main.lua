require("code.data.petrochem.gas-furnace")
require("code.data.petrochem.gas-boiler")
require("code.data.petrochem.fluids-items")
require("code.data.petrochem.recipes")
require("code.data.petrochem.gasifier")
require("code.data.petrochem.natural-gas-wells")
require("code.data.petrochem.coking-tech")
require("code.data.petrochem.resin-tech")
require("code.data.petrochem.diesel")

-- TODO check that there's no ability to create infinite loops using syngas to make petrochems using only steam/water input. Probably make automated checks by assigning a carbon content to every fluid and item and then checking all recipes. Including productivity if enabled for that recipe.