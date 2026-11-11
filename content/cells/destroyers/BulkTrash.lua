local Trash = require("content/cells/destroyers/Trash")

local BulkTrash = setmetatable({
    name = "bulktrash",
    k3 = 733,
    title = "Bulk Trash",
    description = "Blocks pushes like a Wall, but deletes the cell that pushed it."
}, { __index = Trash })
BulkTrash.__index = BulkTrash

function BulkTrash:eats()
    return false
end

function BulkTrash:bump(_, _, pusher)
    if pusher then self.simulator.movement:destroy(pusher) end
end

return BulkTrash
