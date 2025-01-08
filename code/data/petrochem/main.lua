local Table = require("code.util.table")

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