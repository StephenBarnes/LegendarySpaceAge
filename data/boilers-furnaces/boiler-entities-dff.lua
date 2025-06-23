local fluidBoxes = require("const.boiler-const-data").fluidBoxes

-- Create alternate version of the burner boiler for planets with air. (This shouldn't be necessary because we use the same fluid input for air and oxygen. But we still need it, because otherwise it won't assign air input to the right fluidbox on planets without air, for some reason.)
local burnerBoilerAir = copy(ASSEMBLER["burner-boiler"])
burnerBoilerAir.name = "burner-boiler-air"
burnerBoilerAir.localised_name = {"entity-name.burner-boiler-air"} -- TODO give it a different icon, so we can tell them apart in signal GUI etc.
burnerBoilerAir.localised_description = {"entity-description.burner-boiler-air"}
Entity.hide(burnerBoilerAir, nil, "burner-boiler")
burnerBoilerAir.deconstruction_alternative = "burner-boiler"
--burnerBoilerAir.minable.result = "burner-boiler"
burnerBoilerAir.fluid_boxes_off_when_no_fluid_recipe = false
burnerBoilerAir.fluid_boxes = {
	fluidBoxes.x5x3.input.water,
	fluidBoxes.x5x3.input.air,
	fluidBoxes.x5x3.input.airLinked,
	fluidBoxes.x5x3.output.steam,
	fluidBoxes.x5x3.output.flue,
	fluidBoxes.x5x3.output.brine,
}
extend{burnerBoilerAir}