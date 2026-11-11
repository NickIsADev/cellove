local Trash = require("content/cells/destroyers/Trash")

local ToughTrash = setmetatable({
    name = "toughtrash",
    k3 = 225,
    title = "Tough Trash",
    description = "Deletes any cell that moves into its front or back. Acts like a Wall on the other sides."
}, { __index = Trash })
ToughTrash.__index = ToughTrash

function ToughTrash:eats(dx, dy)
    return (dx == 0 or dy == 0) and self:_alignment(dx, dy) ~= 0
end

return ToughTrash
