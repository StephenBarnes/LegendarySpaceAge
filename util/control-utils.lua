-- Globals used in control stage.

local Export = {}

---@param orientation float
---@return float
Export.flipOrientation = function(orientation)
	return (orientation + 0.5) % 1
end

---@param direction defines.direction
---@return defines.direction
Export.flipDirection = function(direction)
	return (direction + 8) % 16
end

return Export