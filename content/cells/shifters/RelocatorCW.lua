local Shifter = require("content/cells/shifters/Shifter")

local RelocatorCW = setmetatable({
    name = "relocator_cw",
    k3 = 260,
    title = "Relocator (CW)",
    description = "Shifter (CW) that does not rotate the outputted cell.",
    bend = 1,
    rotates = false
}, { __index = Shifter })
RelocatorCW.__index = RelocatorCW

return RelocatorCW
