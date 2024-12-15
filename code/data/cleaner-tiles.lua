-- This file makes placed tiles (stone bricks, concrete) more likely to remove decoratives.

local newProbs = {
	["stone-path"] = 0.65, -- Default was 0.15.

	["concrete"] = .8, -- Default was 0.25.
	["hazard-concrete-left"] = .8,
	["hazard-concrete-right"] = 8,

	["refined-concrete"] = 1, -- Default was 0.25.
	["refined-hazard-concrete-left"] = 1,
	["refined-hazard-concrete-right"] = 1,

	["foundation"] = 1, -- Default was 0.25.

	-- For landfill it's zero. Leaving as zero.
}
for name, prob in pairs(newProbs) do
	if not data.raw.tile[name] then
		log("Error: No tile named " .. name .. " to change.")
	else
		data.raw.tile[name].decorative_removal_probability = prob
	end
end