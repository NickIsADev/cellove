local Slant = require("content/cells/slopes/Slant")

local SlantCCW = setmetatable({
    name = "slant_ccw",
    k3 = 1019,
    title = "Slant (CCW)",
    description = "Slant that always shifts cells counter-clockwise.",
    sense = "ccw",
    faces = {}
}, { __index = Slant })
SlantCCW.__index = SlantCCW

return SlantCCW
