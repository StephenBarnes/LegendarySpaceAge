-- This file makes changes so that rocket-parts-per-rocket can be different for each surface.
-- Currently it's 100 rocket parts per rocket everywhere, except 10 on Apollo. In future it might be balanced differently, could add other moons, etc.
-- We implement this by making a copy of the rocket-silo with 10 parts per rocket, then using a runtime script to swap rocket silos on build.

-- Set default rocket silo to use 100 parts per rocket.
local rocketSilo = RAW["rocket-silo"]["rocket-silo"]
rocketSilo.rocket_parts_required = 100

-- Make a copy of the rocket silo with 10 parts per rocket.
local rocketSilo10 = copy(rocketSilo)
rocketSilo10.rocket_parts_required = 10
rocketSilo10.name = "rocket-silo-10parts"
rocketSilo10.localised_name = {"entity-name.rocket-silo"}
rocketSilo10.localised_description = {"entity-description.rocket-silo"}
rocketSilo10.placeable_by = {item="rocket-silo", count=1}
rocketSilo10.hidden_in_factoriopedia = true
extend{rocketSilo10}