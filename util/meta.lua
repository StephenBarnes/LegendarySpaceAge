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


--- LSP doesn't recognize the new additional_categories field, so this fixes that:

---@class data.RecipePrototype
---@field additional_categories? string[]

--- LSP doesn't recognize FurnacePrototype.circuit_connector.
---@class data.FurnacePrototype
---@field circuit_connector? data.CircuitConnectorDefinition