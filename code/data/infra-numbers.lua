
-- Adjust stats of foundry.
local foundry = data.raw["assembling-machine"]["foundry"]
foundry.crafting_speed = 1 -- Instead of 4, we set it to base 1, increasing to 10.
foundry.effect_receiver = nil -- Remove base productivity bonus.
foundry.energy_source.emissions_per_minute = { pollution = 50 }
foundry.energy_source.drain = "1MW"
foundry.energy_usage = "9MW"

-- TODO also edit modules to instead be like +25% or +20%, not e.g. +30%.
