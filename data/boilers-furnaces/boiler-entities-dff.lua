-- Create alternate version of the burner boiler for planets w-- TODO heat exchanger needs to also be changed to assembling-machine.ith air in the atmosphere.
--[[
local airBoiler = copy(ASSEMBLER["boiler-lsa"])
airBoiler.name = "boiler-lsa-air"
airBoiler.localised_name = {"entity-name."..airBoiler.name} -- TODO give it a different icon, so we can tell them apart in signal GUI etc.
airBoiler.localised_description = {"entity-description."..airBoiler.name}
airBoiler.hidden_in_factoriopedia = true
airBoiler.hidden = true
airBoiler.factoriopedia_alternative = "boiler-lsa"
airBoiler.minable.result = "boiler-lsa"
airBoiler.fluid_boxes_off_when_no_fluid_recipe = false
airBoiler.fluid_boxes = {waterIOFluidBox, steamOutputFluidBox, airCenterInputFluidBox, flueOutputFluidBox, linkedAirInputFluidBox}
extend{airBoiler}
]]