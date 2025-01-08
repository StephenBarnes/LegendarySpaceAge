local Tech = require("code.util.tech")

require("code.data.petrochem.gas-furnace")
require("code.data.petrochem.gas-boiler")
require("code.data.petrochem.fluids-items")
require("code.data.petrochem.recipes")
require("code.data.petrochem.gasifier")
require("code.data.petrochem.fluid-boxes")

-- TODO for recipes, define which fluid connections to use - shouldn't use these additional fluid connections if not necessary.

-- TODO figure out what to put in the 2nd oil tech.
-- TODO figure out what to do with the sulfur tech.
-- TODO move syngas liquefaction tech since it's needed on Vulcanus.

-- Move rocket-fuel (vehicle fuel) earlier in progression
Tech.setPrereqs("rocket-fuel", {"oil-processing"})
data.raw.technology["rocket-fuel"].unit = data.raw.technology["flammables"].unit

-- TODO check that there's no ability to create infinite loops using syngas to make petrochems using only steam/water input. Probably make automated checks by assigning a carbon content to every fluid and item and then checking all recipes. Including productivity if enabled for that recipe.