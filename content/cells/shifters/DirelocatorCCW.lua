local Shifter = require("content/cells/shifters/Shifter")

local DirelocatorCCW = setmetatable({
    name = "direlocator_ccw",
    k3 = 264,
    title = "Direlocator (CCW)",
    description = "Dishifter (CCW) that does not rotate the outputted cells.",
    outputs = { 0, 3 },
    rear = true,
    rotates = false
}, { __index = Shifter })
DirelocatorCCW.__index = DirelocatorCCW

return DirelocatorCCW
