local Slope = require("content/cells/slopes/Slope")

local SlopeCCW = setmetatable({
    name = "slope_ccw",
    k3 = 383,
    title = "Slope (CCW)",
    description = "Slope that always shifts cells counter-clockwise.",
    sense = "ccw",
    faces = {}
}, { __index = Slope })
SlopeCCW.__index = SlopeCCW

return SlopeCCW
