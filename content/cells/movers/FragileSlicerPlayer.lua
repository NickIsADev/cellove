local SlicerPlayer = require("content/cells/movers/SlicerPlayer")

local FragileSlicerPlayer = setmetatable({
    name = "fragilesliceplayer",
    k3 = 298,
    title = "Fragile Slicer Player",
    description = "Like a Slicer Player, but explodes when pushed into, taking the cell that pushed it along.",
    fragile = true
}, { __index = SlicerPlayer })
FragileSlicerPlayer.__index = FragileSlicerPlayer

return FragileSlicerPlayer
