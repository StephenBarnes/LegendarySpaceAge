-- This file will create/change recipes for asteroid chunks.

-- Hide the reprocessing recipes and tech.
--[[TECH["asteroid-reprocessing"].hidden = true
Tech.removePrereq("planet-discovery-aquilo", "asteroid-reprocessing")
for _, name in pairs{"metallic", "carbonic", "oxide"} do
	RECIPE[name.."-asteroid-reprocessing"].hidden = true
end
]]
-- Well, rather don't hide them completely, they are interesting and make more possible designs viable for the later-game asteroid belts, plus they only become available after you have space science, so they don't remove the need to visit all the asteroid belts.

-- Disable quality for reprocessing recipes, though.
for _, name in pairs{"metallic", "carbonic", "oxide"} do
	RECIPE[name.."-asteroid-reprocessing"].allow_quality = false
	RECIPE[name.."-asteroid-reprocessing"].allow_productivity = false -- Already disabled in vanilla SA.
end

-- TODO create new advanced recipes for eg dry gas from ice asteroids.