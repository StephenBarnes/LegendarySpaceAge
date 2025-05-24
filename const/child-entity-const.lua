--[[ This file defines child entities that get created alongside entities, move around with them, get destroyed when the parent is destroyed, etc.
See control/child-entities.lua for how this is used.

Returned table maps entity name => child name => list of child requirements.
The child name is the name of the child entity to create.
You can require multiple children of the same name, but they should have different positions.
Each child requirement can have fields:
* pos - position relative to parent. Should be a tile center or we won't be able to find it to update/delete.
* adjustForOrientation - if we should move the child when parent rotates.
* createdHandler - function to call when child is created. Called as createdHandler(parent, child).
* destroyedHandler - function to call right before child is destroyed. Called as destroyedHandler(parentName, child).
]]

local Export = {}

-- Add air input for furnaces on planets with air in the atmosphere.
local FurnaceConst = require("const.furnace-const")
for _, furnaceName in pairs{"stone-furnace-air", "steel-furnace-air", "ff-furnace-air"} do
	Export[furnaceName] = {
		["invisible-fluid-supplier"] = {{
			pos = {.5, .5},
			adjustForOrientation = false,
			createdHandler = function(parent, child)
				child.set_infinity_pipe_filter({name = "air", percentage = 1})
				parent.fluidbox.add_linked_connection(FurnaceConst.airLinkId, child, 1)
			end,
		}},
	}
end

-- TODO later I'll add invisible vents to stone furnaces.

return Export