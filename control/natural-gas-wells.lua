--[[ This file replaces half the crude oil wells on Nauvis with natural gas wells instead. It runs when chunks are generated.
Aquilo also has natural gas wells, but since all of them get replaced, I'm rather doing that with autoplace, not control-stage code.
Could also do Nauvis with autoplace, but then I can't do stuff like converting exactly half the oil wells in each chunk to gas wells.
]]

---@param oilWell LuaEntity
local function replaceOilWellWithGasWell(surface, oilWell)
	local info = {
		name = "natural-gas-well",
		position = oilWell.position,
		direction = oilWell.direction,
		force = oilWell.force,
		amount = oilWell.amount,
		fast_replace = false,
		raise_built = true,
		create_build_effect_smoke = false,
		spawn_decorations = false,
	}
	oilWell.destroy()
	local gasWell = surface.create_entity(info)
	if gasWell ~= nil and gasWell.valid then
		surface.destroy_decoratives{area = gasWell.bounding_box}
	end
end

local function shuffleList(l)
	local n = #l
	if n <= 1 then return l end
	for i = n, 2, -1 do
		local j = math.random(i)
		l[i], l[j] = l[j], l[i]
	end
end

---@param e EventData.on_chunk_generated
local function onChunkGenerated(e)
	if not e.surface.valid then return end
	if e.surface.name ~= "nauvis" then return end

	local oilWells = e.surface.find_entities_filtered{area = e.area, name = "crude-oil", type = "resource"}
	if table_size(oilWells) == 0 then return end
	-- We want to replace roughly half of the oil wells with gas wells.
	-- Don't want to replace each with 50% probability, as that leads to some clusters having only 1 gas well or 1 oil well, so players will just ignore one of them and ship back the other.
	-- So instead we replace half of the wells in each chunk. Size of oil deposits is set so there's guaranteed to be clusters with like 10+ wells.
	shuffleList(oilWells)
	for i = 1, math.ceil(#oilWells/2) do
		replaceOilWellWithGasWell(e.surface, oilWells[i])
	end
end

return {
	onChunkGenerated = onChunkGenerated
}