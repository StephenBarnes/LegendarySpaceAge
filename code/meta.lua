---@meta
---This file is to fix LSP / type checker issues.

--- LSP thinks defines.direction.south etc. aren't valid directions. This fixes that:

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


--- LSP doesn't recognize auto_recycle, so this fixes that:

---@class data.RecipePrototype
---@field auto_recycle boolean Whether the recipe should automatically create recycling recipes.

---@class data.ItemPrototype
---@field auto_recycle boolean Whether the item should automatically get recycling recipes.