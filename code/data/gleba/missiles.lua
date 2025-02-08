--[[ This file adjusts missile stuff for Gleba. Specifically, since there's no renewable iron for conventional ammo, I want to unlock missile turrets early, for defense.
]]

local Tech = require("code.util.tech")

-- Require missile tech before Gleba.
Tech.addTechDependency("rocketry", "planet-discovery-gleba")

-- Unlock missile turrets early.
local missileTurretTech = data.raw.technology["rocket-turret"]
-- TODO set research trigger to producing boompuff stuff.

Tech.addTechDependency("agricultural-science-pack", "rocket-turret") -- TODO change this