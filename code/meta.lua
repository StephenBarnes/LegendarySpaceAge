---@meta
---This file is to fix an LSP / type checker issue where it thinks defines.direction.south etc. aren't valid directions.

---@class defines
---@field direction Direction

---@class Direction
---@field south integer
defines.direction = {
    north = 0,
	east = 4,
    south = 8,
	west = 12,
}