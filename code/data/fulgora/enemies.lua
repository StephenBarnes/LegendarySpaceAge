-- Fulgoran enemies: make boss units (spawned by mining the vaults) have much lower health.
-- Mod gives them max health of 100k times level. Level is 1-10 determined by evolution.
-- For comparison, behemoth biter has 3k health.
for level = 1, 10 do
	local name = "walking-electric-unit-boss-"..level
	data.raw.unit[name].max_health = level * 1000
end

-- Fulgoran enemies: still require mining the vault ruin.
data.raw.technology["recycling"].research_trigger.entity="fulgoran-ruin-vault"

-- Fulgoran enemies: remove scrap drop from enemies.
for _, unit in pairs(data.raw.unit) do
	if unit.loot and #unit.loot == 1 and unit.loot[1].item == "scrap" then
		unit.loot = nil
	end
end