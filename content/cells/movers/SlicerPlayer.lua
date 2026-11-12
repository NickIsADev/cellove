local Player = require("content/cells/movers/Player")

local SlicerPlayer = setmetatable({
    name = "sliceplayer",
    k3 = 297,
    title = "Slicer Player",
    description = "A Player that moves into empty space. Upon hitting a cell, pushes it out of the way perpendicular to its own direction."
}, { __index = Player })
SlicerPlayer.__index = SlicerPlayer

function SlicerPlayer:_move(dx, dy)
    self:slice(dx, dy)
end

return SlicerPlayer
