local Trash = require("content/cells/destroyers/Trash")

local SquishTrash = setmetatable({
    name = "squishtrash",
    k3 = 348,
    title = "Squish Trash",
    description = "Acts like a Pushable, but deletes the cell that pushes it when it is squished against something immovable.",
    fixed = false
}, { __index = Trash })
SquishTrash.__index = SquishTrash

function SquishTrash:eats(dx, dy, action)
    return action == nil and not self.grid.simulator.movement:clear(self.x, self.y, dx, dy)
end

return SquishTrash
