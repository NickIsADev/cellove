local Shifter = require("content/cells/shifters/Shifter")

local ShifterCCW = setmetatable({
    name = "shifter_ccw",
    k3 = 255,
    title = "Shifter (CCW)",
    description = "Shifter that bends cells counter-clockwise.",
    bend = -1
}, { __index = Shifter })
ShifterCCW.__index = ShifterCCW

return ShifterCCW
