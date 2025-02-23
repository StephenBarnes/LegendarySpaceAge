--[[ This file removes the existing modules system from the game. Because I'm replacing them with charged and supercharged circuits.
]]

-- Add first 2 qualities to assembler 2 tech. (Originally in quality module tech. Assembler 2 now has builtin quality bonus.)
local assembler2Tech = TECH["automation-2"]
table.insert(assembler2Tech.effects, {
	type = "unlock-quality",
	quality = "uncommon",
})
table.insert(assembler2Tech.effects, {
	type = "unlock-quality",
	quality = "rare",
})

-- Hide all module items and recipes.
for _, category in pairs{"speed", "efficiency", "productivity", "quality"} do
	for tier = 1, 3 do
		local moduleName = category.."-module"
		if tier ~= 1 then moduleName = moduleName.."-"..tier end
		MODULE[moduleName].hidden = true
		RECIPE[moduleName].hidden = true
	end
end

------------------------------------------------------------------------
--- REMOVE ALL MODULE TECHS.
--- This is pretty tricky, need to change prereqs, etc.

-- Epic quality depends on Gleba science, yellow science, and quality module 1. Change it to electromagnetic and yellow science.
Tech.removePrereq("epic-quality", "agricultural-science-pack")
Tech.removePrereq("epic-quality", "quality-module")
Tech.addTechDependency("electromagnetic-science-pack", "epic-quality")
Tech.replaceSciencePack("epic-quality", "agricultural-science-pack", "electromagnetic-science-pack")

-- All tier 2 and 3 module techs can be hidden, nothing depends on them.
for _, category in pairs{"speed", "efficiency", "productivity", "quality"} do
	for tier = 2, 3 do
		local moduleName = category.."-module-"..tier
		Tech.hideTech(moduleName)
	end
end
Tech.hideTech("quality-module")

Tech.removePrereq("destroyer", "speed-module")
Tech.removePrereq("power-armor-mk2", "speed-module")
Tech.hideTech("speed-module")

Tech.removePrereq("power-armor-mk2", "efficiency-module")
Tech.hideTech("efficiency-module")

Tech.removePrereq("production-science-pack", "productivity-module")
Tech.hideTech("productivity-module")

Tech.hideTech("modules")