local Shifter = require("content/cells/shifters/Shifter")

local DirelocatorCW = setmetatable({
    name = "direlocator_cw",
    k3 = 265,
    title = "Direlocator (CW)",
    description = "Dishifter (CW) that does not rotate the outputted cells.",
    outputs = { 0, 1 },
    rear = true,
    rotates = false
}, { __index = Shifter })
DirelocatorCW.__index = DirelocatorCW

return DirelocatorCW
