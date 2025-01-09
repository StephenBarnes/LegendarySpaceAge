local Tech = require("code.util.tech")

require("code.data.petrochem.gas-furnace")
require("code.data.petrochem.gas-boiler")
require("code.data.petrochem.fluids-items")
require("code.data.petrochem.recipes")
require("code.data.petrochem.gasifier")
require("code.data.petrochem.fluid-boxes")
require("code.data.petrochem.wellhead")
require("code.data.petrochem.natural-gas-wells")

-- Move rocket-fuel (vehicle fuel) earlier in progression
Tech.setPrereqs("rocket-fuel", {"oil-processing"})
data.raw.technology["rocket-fuel"].unit = data.raw.technology["flammables"].unit

-- TODO check that there's no ability to create infinite loops using syngas to make petrochems using only steam/water input. Probably make automated checks by assigning a carbon content to every fluid and item and then checking all recipes. Including productivity if enabled for that recipe.