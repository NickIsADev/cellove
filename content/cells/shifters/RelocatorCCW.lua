local Shifter = require("content/cells/shifters/Shifter")

local RelocatorCCW = setmetatable({
    name = "relocator_ccw",
    k3 = 261,
    title = "Relocator (CCW)",
    description = "Shifter (CCW) that does not rotate the outputted cell.",
    bend = -1,
    rotates = false
}, { __index = Shifter })
RelocatorCCW.__index = RelocatorCCW

return RelocatorCCW
