--[[ This file adjusts missile stuff for Gleba. Specifically, since there's no renewable iron for conventional ammo, I want to unlock missile turrets early, for defense.
]]

local Tech = require("code.util.tech")

-- Require missile tech before Gleba.
Tech.addTechDependency("rocketry", "planet-discovery-gleba")

-- Unlock missile turrets early.
local missileTurretTech = TECH["rocket-turret"]
missileTurretTech.unit = nil
missileTurretTech.research_trigger = {
	type = "craft-item",
	item = "sprouted-boomnut",
	count = 10,
}
missileTurretTech.prerequisites = {"boompuff-cultivation"}

-- Spidertron depended on missile turret, and bio science pack through that. So add that.
Tech.addTechDependency("agricultural-science-pack", "spidertron")