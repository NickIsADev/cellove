local AdjustableSlope = require("content/cells/slopes/AdjustableSlope")

local AdjustableSlopeCW = setmetatable({
    name = "adjustableslope_cw",
    k3 = 1092,
    title = "Adjustable Slope (CW)",
    description = "Adjustable Slope that always shifts cells clockwise.",
    sense = "cw",
    faces = {}
}, { __index = AdjustableSlope })
AdjustableSlopeCW.__index = AdjustableSlopeCW

return AdjustableSlopeCW
