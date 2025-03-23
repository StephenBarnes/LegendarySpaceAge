-- This file makes changes so that rocket-parts-per-rocket is different for each surface. Default is 100, then 10 on Apollo.
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
extend{rocketSilo10}