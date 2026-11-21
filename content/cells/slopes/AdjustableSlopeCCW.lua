local AdjustableSlope = require("content/cells/slopes/AdjustableSlope")

local AdjustableSlopeCCW = setmetatable({
    name = "adjustableslope_ccw",
    k3 = 1093,
    title = "Adjustable Slope (CCW)",
    description = "Adjustable Slope that always shifts cells counter-clockwise.",
    sense = "ccw",
    faces = {}
}, { __index = AdjustableSlope })
AdjustableSlopeCCW.__index = AdjustableSlopeCCW

return AdjustableSlopeCCW
