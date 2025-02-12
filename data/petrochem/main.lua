require("data.petrochem.gas-furnace")
require("data.petrochem.gas-boiler")
require("data.petrochem.fluids-items")
require("data.petrochem.recipes")
require("data.petrochem.gasifier")
require("data.petrochem.natural-gas-wells")
require("data.petrochem.coking-tech")
require("data.petrochem.resin-tech")
require("data.petrochem.diesel")

-- TODO check that there's no ability to create infinite loops using syngas to make petrochems using only steam/water input. Probably make automated checks by assigning a carbon content to every fluid and item and then checking all recipes. Including productivity if enabled for that recipe.