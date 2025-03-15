--[[ This file prevents craters from overlapping when placed on Heimdall.
We could do this in map-gen stage, but the logic is a bit tricky and I think it's probably more efficient to do it control-stage.
Basically we want to allow small craters inside big craters, but we don't want to let craters overlap in a "vesica piscis" shape because that's unrealistic (the 2nd asteroid impact would erase the crater border that it hit).
]]

local largeCraterRadH = 3 -- distance around 3 from the center to left/right.
local largeCraterRadV = 2 -- distance around 2 from the center to top/bottom.
local largeCraterEraserWidth = 1 -- distance around the edge of the large crater where other craters having their center there will get erased.

---@param e EventData.on_chunk_generated
local function onChunkGenerated(e)
	local surface = e.surface
	if not surface.valid then return end
	if surface.name ~= "heimdall" then return end

	local largeCraters = surface.find_decoratives_filtered{area = e.area, name = "heimdall-crater-large"}
	log("Found " .. #largeCraters .. " large craters in chunk " .. serpent.line(e.area))
	for _, largeCraterResult in ipairs(largeCraters) do
		local pos = largeCraterResult.position
		-- Find medium craters that are within the bounding box.
		for _, mediumCraterResult in ipairs(surface.find_decoratives_filtered{area = {
			{pos.x - largeCraterRadH - largeCraterEraserWidth, pos.y - largeCraterRadV - largeCraterEraserWidth},
			{pos.x + largeCraterRadH + largeCraterEraserWidth, pos.y + largeCraterRadV + largeCraterEraserWidth},
		}, name = "heimdall-crater-medium"}) do
			--local mediumCraterPos = mediumCraterResult.position
			-- mediumCraterResult.decorative -- this is a prototype.
			surface.decorat
		end
	end
end

return {
	onChunkGenerated = onChunkGenerated,
}