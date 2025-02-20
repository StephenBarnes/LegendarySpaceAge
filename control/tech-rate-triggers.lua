--[[ This file implements the "rate triggers" for some techs, ie techs that unlock when you produce n items per minute for m minutes.
We do this by checking the production stats of each force, and unlocking techs when the conditions are met.
We set force.technologies[techName].saved_progress in range [0, 1) to indicate how close the force is to unlocking the tech.
We only update techs that have their prereqs already researched.

Testing:
/c for i = 1, 10 do game.print(">" .. i .. ": " .. game.player.force.get_item_production_statistics("nauvis").get_flow_count{name = "ingot-iron-hot", category = "input", precision_index = defines.flow_precision_index.one_minute, sample_index = i}) end
The precision index is the total time-frame. If no sample index, it's the average (per minute) over the whole time-frame. Otherwise it's the index of the sample from 1 to 300, splitting the range into 300 equal segments.
We want to find the total production in maybe the last 3 minutes, or 5 minutes.
So if we use a time-frame of 10 hours, each sample index gives (600 minutes / 300 = 2 minutes) of data.
Could use a time-frame of 50 hours. Then each sample index gives 10 minutes of data, which is too high.
If we use a time-frame of 1 hour, each sample index gives (60 minutes / 300 = 0.2 minutes) of data. So we need to add up 5 samples to get production over 1 minute.
	Ok, we'll do that.
]]

local TECH_RATES = require("util.const.tech-rates")

---@param force LuaForce
local function techIsNext(force, techName)
	-- Returns true iff the force can research the tech, and has researched all its prereqs.
	local tech = force.technologies[techName]
	if tech == nil or not tech.enabled or tech.researched then return false end
	for _, prereq in pairs(tech.prerequisites) do
		if prereq == nil or not prereq.enabled or not prereq.researched then return false end
	end
	return true
end

---@param force LuaForce
local function productionOverLastNMinutes(force, itemName, numMinutes, category)
	-- Returns the total production of the item over the last N minutes.
	-- Category == "input" it's production of this item, not consumption.
	category = category or "input"
	local total = 0
	for i = 1, numMinutes * 5 do
		-- Look up production statistics for this 0.2-minute period.
		-- The amount returned per-minute, so for the actual amount we divide by 5. But we rather do that once at the end.
		total = total + force.get_item_production_statistics("nauvis").get_flow_count{
			name = itemName,
			category = category,
			precision_index = defines.flow_precision_index.one_hour,
			sample_index = i,
		}
	end
	return total / 5
end

---@param force LuaForce
---@param techName string
---@param progress number
local function setProgress(force, techName, progress)
	if progress < 0 then progress = 0 end
	if progress > 1 then
		force.technologies[techName].saved_progress = 0.999
		if #force.research_queue == 0 then
			force.add_research(techName)
			force.research_progress = 1
		elseif #force.research_queue > 0 and force.research_queue[1].name == techName then
			-- The progress readout doesn't update unless we also set this.
			force.research_progress = 1
		else
			local newResearchQueue = {techName}
			for _, tech in pairs(force.research_queue) do
				if tech.name ~= techName then
					table.insert(newResearchQueue, tech.name)
				end
			end
			force.research_queue = newResearchQueue
			force.research_progress = 1
		end
	else
		force.technologies[techName].saved_progress = progress
		if #force.research_queue == 0 then
			force.add_research(techName)
			force.research_progress = progress
		elseif #force.research_queue > 0 and force.research_queue[1].name == techName then
			-- The progress readout doesn't update unless we also set this.
			force.research_progress = progress
		end
	end
end

---@param force LuaForce
---@param techName string
---@param producedItemName string
---@param subtractInputItemName string|nil
---@param numMinutes number
local function updateRateTech(force, techName, producedItemName, subtractInputItemName, numMinutes)
	if not techIsNext(force, techName) then return end
	local requiredCount = TECH_RATES[techName].perSecond * (TECH_RATES[techName].numMinutes * 60 - 10)
		-- 10 second grace period reducing the amount required, since we only check every 10 seconds.
	local forceRate = productionOverLastNMinutes(force, producedItemName, numMinutes)
	if subtractInputItemName then
		forceRate = forceRate - productionOverLastNMinutes(force, subtractInputItemName, numMinutes, "output") -- Subtract out e.g. reheated iron ingots.
	end
	local progress = forceRate / requiredCount
	--force.print("force rate: " .. forceRate .. ", required: " .. requiredCount .. ", progress: " .. progress)
	setProgress(force, techName, progress)
end

local function onNthTick(e)
	for _, force in pairs(game.forces) do
		if #force.players > 0 then
			for techName, vals in pairs(TECH_RATES) do
				updateRateTech(force, techName, vals.item, vals.subtractInputItemName, vals.numMinutes)
			end
		end
	end
end

return {
	onNthTick = onNthTick,
}